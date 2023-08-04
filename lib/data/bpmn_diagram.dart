import 'package:bpmn_parse/data/bpmn_element.dart';

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

  BpmnElement? getElementById({required String id}) {
    return _allElements[id];
  }

  String firstElementId() { return _startElementId; }

  //получение списка id элементов, к которым можно перейти из заданного элемента
  List<String> nextElements({required String id}) {
    return _allNodes[id] ?? [];
  }

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

  //заполнение:
  //- первого элемента _startElementId
  //- списка всех элементов диаграммы _allElements
  //- списка смежности _allNodes
  BpmnDiagram.fromList(List<BpmnElement> list) {
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
}

