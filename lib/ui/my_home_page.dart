import 'dart:async';

import 'package:bpmn_parse/data/bpmn_diagram.dart';
import 'package:bpmn_parse/data/fetcher.dart';
import 'package:flutter/material.dart';

import '../data/bpmn_element.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late BpmnDiagram diagram;

  late String currentElement;
  late List<String> nextElements;

  bool showChoice = false;

  String path = '';

  late Completer<void>? userChoiceCompleter;

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
                path = '';
                Fetcher().fetchBpmnElements().then((elements) {
                  diagram = BpmnDiagram.fromList(elements);
                  traverseDiagram();
                });
              },
              child: Text('Download data & traverse diagram'),
            ),
            Text(path),
            const Spacer(),
            showChoice ? choiceButtons(nextElements) : Container(),
          ],
        ),
      ),
    );
  }

  Widget choiceButtons(List<String> elements) {
    return Row(
      children: [
        for (var e in elements)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                setState(() {
                  showChoice = false;
                  currentElement = e;
                });
                userChoiceCompleter?.complete();
                userChoiceCompleter = null;
              },
              child: Text(
                  diagram.getElementById(id: e)!.properties[2]['value'] ?? ''),
            ),
          )
      ],
    );
  }

  Future<void> traverseDiagram() async {
    var firstElementId = diagram.firstElementId();
    currentElement = firstElementId;
    nextElements = diagram.nextElements(id: currentElement);
    while (nextElements.isNotEmpty) {
      var currentElementDescr =
          diagram.getElementById(id: currentElement).toString();
      print(currentElementDescr);
      setState(() {
        path += '$currentElementDescr\n';
      });
      nextElements = diagram.nextElements(id: currentElement);
      if (nextElements.length == 0) {
        break;
      } else if (nextElements.length > 1) {
        setState(() {
          showChoice = true;
        });
        final completer = Completer<void>();
        userChoiceCompleter = completer;
        await completer.future;
      } else {
        currentElement = nextElements[0];
      }
    }
  }
}
