import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:bpmn_parse/data/bpmn_diagram.dart';
import 'package:bpmn_parse/data/bpmn_element.dart';
import 'package:bpmn_parse/data/fetcher.dart';
import 'package:bpmn_parse/data/flow_objects/activities/activity.dart';
import 'package:bpmn_parse/data/flow_objects/activities/service_task.dart';
import 'package:bpmn_parse/data/flow_objects/activities/user_task.dart';
import 'package:bpmn_parse/data/flow_objects/events/end_event.dart';
import 'package:bpmn_parse/data/flow_objects/events/event.dart';
import 'package:bpmn_parse/data/flow_objects/events/start_event.dart';
import 'package:bpmn_parse/data/flow_objects/flow_object.dart';
import 'package:bpmn_parse/data/flow_objects/gateways/exclusive_gateway.dart';
import 'package:bpmn_parse/data/flow_objects/gateways/gateway.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Map<String, dynamic> varsStorage = {};

  late BpmnDiagram _diagram;

  //переменные для обхода диаграммы
  late String _currentElement;
  late List<String> _nextElements;

  //показывать ли пользователю кнопки для выбора пути
  bool _showChoice = false;

  //переменная для списка элементов, по которым произошёл обход диаграммы
  String _path = '';

  //используется для того, чтобы дождаться выбора пользователя, когда
  //появилась необходимость выбора пути
  late Completer<void>? _userChoiceCompleter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                _path = '';
                Fetcher().fetchBpmnElements().then((elements) {
                  _diagram = BpmnDiagram.fromList(elements);
                  _traverseDiagram();
                });
              },
              child: const Text('Download data & traverse diagram'),
            ),
            Text(_path),
            const Spacer(),
            _showChoice ? _choiceButtons(_nextElements) : Container(),
          ],
        ),
      ),
    );
  }

  //строка кнопок для выбора следующего элемента при обходе диаграммы
  Widget _choiceButtons(List<String> elements) {
    return Row(
      children: [
        for (var e in elements)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                setState(() {
                  _showChoice = false;
                  _currentElement = e;
                });
                //пользователь совершил выбор, можно продолжать обход диаграммы
                _userChoiceCompleter?.complete();
                _userChoiceCompleter = null;
              },
              child: Text(
                  _diagram.getElementById(id: e)!.properties[2]['value'] ?? ''),
            ),
          )
      ],
    );
  }

  //обход диаграммы
  Future<void> _traverseDiagram() async {
    //устанавливаются начальные значения - элемент, с которого начинается обход
    // и следующий элемент
    var firstElementId = _diagram.firstElementId();
    _currentElement = firstElementId;
    _nextElements = _diagram.nextElements(id: _currentElement);

    //обход продолжается, пока есть следующие элементы
    while (_nextElements.isNotEmpty) {
      //выбрать тип текущего элемента диаграммы
      FlowObject? currentObject = _classifyElement(_currentElement);
      //и выполнить соответствующее действие
      if (currentObject != null ) _executeFlowObject(currentObject);

      print(_diagram.getElementById(id: _currentElement).toString());
      setState(() {
        _path = currentObject != null ? currentObject.toString() : '';
      });

      _nextElements = _diagram.nextElements(id: _currentElement);
      //развилка в диаграмме - следующих элементов больше 1
      if (_nextElements.length > 1) {
        setState(() {
          _showChoice = true;
        });
        //ждём пока пользователь не нажмёт на кнопку выбора
        final completer = Completer<void>();
        _userChoiceCompleter = completer;
        await completer.future;
      } else if (_nextElements.isNotEmpty) {
        _currentElement = _nextElements[0];
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }

    String result = '';
    varsStorage.forEach((key, value) {result += '$key : $value\n'; });
    setState(() {
      _path = result;
    });
  }

  FlowObject? _classifyElement(String elementId) {
    BpmnElement element = _diagram.getElementById(id: elementId)!;
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

  void _executeFlowObject(FlowObject obj) {
    if (obj is Activity) { obj.execute(varsStorage); }
    else if (obj is Event) { obj.process(varsStorage); }
    else if (obj is Gateway) { obj.pass(varsStorage); }
  }
}
