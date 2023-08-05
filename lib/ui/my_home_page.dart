import 'dart:async';
import 'package:bpmn_parse/data/bpmn_diagram.dart';
import 'package:bpmn_parse/data/fetcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../di/locator.dart';
import '../stores/bpmn_store.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  final _bpmnStore = getIt.get<BpmnStore>();
  final _getItDiagram = getIt.get<BpmnDiagram>();

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
                _bpmnStore.getElements();
                //_bpmnStore.initializeDiagram();
                //print('elem - ${_bpmnStore.elements.length}');
                //print('1st el - ${_getItDiagram.firstElementId()}');
/*                Fetcher().fetchBpmnElements().then((elements) {
                  _diagram = BpmnDiagram.fromList(elements);
                  _traverseDiagram();
                });*/

              },
              child: const Text('Download data & traverse diagram'),
            ),
            Observer(builder: (context) {
              if (_bpmnStore.isLoading) return const CircularProgressIndicator();
              return Text('1st el - ${getIt.get<BpmnDiagram>().firstElementId()}');
            }),
            Text(_path),
            const Spacer(),
            //_showChoice ? _choiceButtons(_nextElements) : Container(),
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
      var currentElementDescr =
          _diagram.getElementById(id: _currentElement).toString();
      print(currentElementDescr);
      setState(() {
        _path += '$currentElementDescr\n';
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
      } else {
        _currentElement = _nextElements[0];
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }
}
