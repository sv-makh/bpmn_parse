import 'package:bpmn_parse/data/bpmn_diagram.dart';
import 'package:bpmn_parse/data/repository.dart';
import 'package:flutter/material.dart';

import '../data/bpmn_element.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Repository repository;
  late List<BpmnElement> elements;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(
          onPressed: () {
            repository = Repository();
            repository.fetchBpmnElements().then((value) {
              elements = List<BpmnElement>.from(value);
              print(elements.length);
              var diagram = BpmnDiagram.fromList(elements);
              var firstElementId = diagram.firstElementId();
              var currentElement = firstElementId;
              print('first element: $firstElementId');
              var secondElementId = diagram.nextElements(id: firstElementId)[0];
              print('next element: $secondElementId');
              List<String> nextElements = diagram.nextElements(id: currentElement);
              while (nextElements.length == 1) {
                print(diagram.getElementById(id: currentElement).toString());
                nextElements = diagram.nextElements(id: currentElement);
                if (nextElements.length != 1) break;
                currentElement = nextElements[0];
              }
            });
          },
          child: Text('Download & parse'),
        ),
      ),
    );
  }
}
