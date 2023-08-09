import 'dart:async';
import 'package:bpmn_parse/data/bpmn_diagram.dart';
import 'package:bpmn_parse/data/fetcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../di/locator.dart';
import '../stores/bpmn_store.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //переменная для списка элементов, по которым произошёл обход диаграммы
  String _path = '';

  final _bpmnStore = getIt.get<BpmnStore>();
  final _getItDiagram = getIt.get<BpmnDiagram>();

  late ReactionDisposer _disposer;

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }

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

                //запуск reaction для обхода диаграммы
                _disposer = when(
                  (_) => _bpmnStore.isLoaded,
                  () {
                    _getItDiagram.traverseDiagram();
                  },
                );
              },
              child: const Text('Download data & traverse diagram'),
            ),
            Observer(builder: (context) {
              if (_bpmnStore.isLoading)
                return const CircularProgressIndicator();
              return Container();
            }),
            Text(_path),
            const Spacer(),
            Observer(builder: (context) {
              if (_bpmnStore.showChoice) {
                return _choiceButtons(_bpmnStore.nextElements); }
              return Container();
            }),
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
                _bpmnStore.showChoice = false;
                _bpmnStore.chosenElement = e;

                //пользователь совершил выбор, можно продолжать обход диаграммы
                _bpmnStore.userChoiceCompleter?.complete();
              },
              child: Text( _getItDiagram.getElementById(id: e)!.properties[2]
                      ['value'] ?? ''),
            ),
          )
      ],
    );
  }
}
