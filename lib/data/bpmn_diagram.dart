import 'dart:async';

import 'package:bpmn_parse/data/bpmn_element.dart';
import '../di/locator.dart';
import '../stores/bpmn_store.dart';
import 'package:bpmn_parse/data/flow_objects/activities/activity.dart';
import 'package:bpmn_parse/data/flow_objects/activities/service_task.dart';
import 'package:bpmn_parse/data/flow_objects/activities/user_task.dart';
import 'package:bpmn_parse/data/flow_objects/events/end_event.dart';
import 'package:bpmn_parse/data/flow_objects/events/event.dart';
import 'package:bpmn_parse/data/flow_objects/events/start_event.dart';
import 'package:bpmn_parse/data/flow_objects/flow_object.dart';
import 'package:bpmn_parse/data/flow_objects/gateways/exclusive_gateway.dart';
import 'package:bpmn_parse/data/flow_objects/gateways/gateway.dart';

import 'flow_objects/activities/task.dart';

//рассматриваем диаграмму как ориентированный граф, вершинами являются
// все элементы диаграммы (всех типов, даже flowSequence)
//_startElementId - стартовое событие диаграммы
//_allElements - все элементы диаграммы (вершины графа)
//_allNodes - список смежности для этого графа

class BpmnDiagram {
  BpmnDiagram();

  //id стартового события диаграммы
  String _startElementId = '';

  //все элементы диаграммы
  Map<String, BpmnElement> _allElements = {};

  //мапа _allNodes - список смежности для этого графа
  //элемент мапы _allNodes:
  //ключ - индекс элемента диаграммы
  //значение - список индексов элементов диаграммы,
  // в которые можно перейти из данного элемента
  Map<String, List<String>> _allNodes = {};

  void clear() {
    _startElementId = '';
    _allElements.clear();
    _allNodes.clear();
  }

  BpmnElement? getElementById({required String id}) {
    return _allElements[id];
  }

  String firstElementId() {
    return _startElementId;
  }

  //получение списка id элементов, к которым можно перейти из заданного элемента
  List<String> nextElements({required String id}) {
    return _allNodes[id] ?? [];
  }

  //заполнение:
  //- первого элемента _startElementId
  //- списка всех элементов диаграммы _allElements
  //- списка смежности _allNodes
  void fillFromList(List<BpmnElement> list) {
    for (var e in list) {
      if (e.type == 'startEvent') {
        _startElementId = e.id;
      }

      _allElements[e.id] = e;

      //строим список смежности _allNodes
      if (e.type == 'flowSequence') {
        String sourceId = e.properties[0]['value']!;
        String destinationId = e.properties[1]['value']!;

        //если элемент flowSequence, добавляем его
        //(т.к. он ранее не встречался - он не может встретиться как source в flowSequence)
        //и добавляем элемент, к которому можно перейти от него
        _allNodes[e.id] = [destinationId];
        //добавляем данный элемент flowSequence как элемент, к которому можно
        //перейти из элемента source
        _allNodes.update(
          sourceId,
          (value) => value..add(e.id),
          ifAbsent: () => [e.id],
        );
      } else {
        //если элемент не flowSequence, то информации о связях элементов в нём нет
        //просто добавляем его в мапу, если его там ещё нет
        //(он может там уже быть, если уже встретился как source в flowSequence)
        _allNodes.putIfAbsent(e.id, () => []);
      }
    }
  }

  //обход диаграммы
  void traverseDiagram() async {
    //устанавливаются начальные значения - элемент, с которого начинается обход
    // и следующий элемент
    var firstElement = firstElementId();
    var currentElement = firstElement;
    var nextElementsToGo = nextElements(id: currentElement);

    //обход продолжается, пока есть следующие элементы
    while (nextElementsToGo.isNotEmpty) {
      //выбрать тип текущего элемента диаграммы
      FlowObject? currentObject = _classifyElement(currentElement);

      //вывод на экран и в консоль
      var currentElementDescr = getElementById(id: currentElement).toString();
      print(currentElementDescr);
      getIt.get<BpmnStore>().path = currentObject != null
          ? currentElementDescr
          : '';

      //следующие элементы
      nextElementsToGo = nextElements(id: currentElement);

      //выполняется действие, соответствующее текущему объекту и выбираем следующий элемент
      currentElement = await _executeObj(currentObject, nextElementsToGo);
    }

    _fillPath();
  }

  FlowObject? _classifyElement(String elementId) {
    BpmnElement element = getElementById(id: elementId)!;
    switch (element.type) {
      case 'startEvent':
        return StartEvent(elementId);
      case 'endEvent':
        return EndEvent(elementId);
      case 'serviceTask':
        return ServiceTask(elementId, element.metaName!);
      case 'userTask':
        return UserTask(elementId, element.metaName!);
      case 'exclusiveGateway':
        return ExclusiveGateway(elementId);
      default: //объекты типа 'flowSequence' не являются FlowObject
        return null;
    }
  }

  //обрабатываем текущий элемент:
  //- выполняем его соответствующее действие
  //- при необходимости выбираем, показывать ли кнопки и что будет на них (если элемент UserTask)
  //- выбираем следующий элемент
  //возвращаем следующий элемент
  Future<String> _executeObj(FlowObject? obj, List<String> nextElementsList) async {
    var varsStorage = getIt.get<BpmnStore>().varsStorage;
    if (obj is Task) {
      await obj.executeAsync(varsStorage);

      if (nextElementsList.isEmpty) return '';

      //устанавливаем элементы, информация из которых будет показываться на кнопках

      //следующий значимый элемент - после flowSequence (т.е. после следующего подряд)
      var nextElementObject = nextElements(id: nextElementsList[0])[0];
      //если послеследующий элемент шлюз, на кнопках будут условия из flowSequence
      //которые исходят из шлюза
      if (getElementById(id: nextElementObject)!.type == 'exclusiveGateway') {
        getIt.get<BpmnStore>().nextElements =
            nextElements(id: nextElementObject);
      } else {
        //если послеследующий элемент любой другой, то он сам будет на кнопке
        getIt.get<BpmnStore>().nextElements = [nextElementObject];
      }

      //условие для показа кнопок
      getIt.get<BpmnStore>().showChoice = true;

      //ждём пока пользователь не нажмёт на кнопку
      final completer = Completer<void>();
      getIt.get<BpmnStore>().userChoiceCompleter = completer;
      await completer.future;

      return(nextElementsList[0]);

    } else if (obj is Activity) {
      obj.execute(varsStorage);
    } else if (obj is Event) {
      obj.process(varsStorage);
    } else if (obj is Gateway) {
      obj.pass(varsStorage);
    }

    if (nextElementsList.isEmpty) return '';

    //во всех случаях, если текущий элемент не user task
    // (даже если передан null - тогда текущий элемент flowSequence)

    //если есть выбор, куда дальше идти, идём по ранее выбранному пользоватем пути
    if (nextElementsList.length > 1) {
      return(getIt.get<BpmnStore>().chosenElement);
    } else { //если выбора нет - переходим куда есть)
      return(nextElementsList[0]);
    }
  }

  void _fillPath() {
    String result = '';
    getIt.get<BpmnStore>().varsStorage.forEach((key, value) {
      result += '$key : $value\n';
    });
    getIt.get<BpmnStore>().path = result;
  }
}
