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
            repository.fetchBpmnElements().then((value) => print(value.length));
          },
          child: Text('Download & parse'),
        ),
      ),
    );
  }
}
