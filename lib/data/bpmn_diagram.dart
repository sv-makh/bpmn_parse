import 'package:bpmn_parse/data/bpmn_element.dart';

class BpmnDiagram {
  String _startElementId = '';

  Map<String, BpmnElement> _allElements = {};


  Map<String, List<String>> _allNodes = {};

  BpmnDiagram(List<BpmnElement> list) {
    for (var e in list) {
      if (e.type == 'startEvent') {
        _startElementId = e.id;
      }

      _allElements[e.id] = e;

      if (e.type == 'flowSequence') {
        _allNodes[e.id] = [];
      } else {
        _allNodes[e.id] = [];
      }

    }
  }
}

//class DiagramNode {
//  String id;
//  List<String> children;

//  DiagramNode({required this.id, required this.children});
//}
