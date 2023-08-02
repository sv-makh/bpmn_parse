import 'package:bpmn_parse/data/bpmn_element.dart';

class BpmnDiagram {
  String _startElementId = '';

  Map<String, BpmnElement> _allElements = {};

  BpmnElement? getElementById({required String id}) {
    return _allElements[id];
  }

  Map<String, List<String>> _allNodes = {};

  BpmnDiagram(List<BpmnElement> list) {
    for (var e in list) {
      if (e.type == 'startEvent') {
        _startElementId = e.id;
      }

      _allElements[e.id] = e;

      if (e.type == 'flowSequence') {
        String sourceId = e.properties[0]['value']!;
        String destinationId = e.properties[1]['value']!;

        _allNodes[e.id] = [destinationId];
        _allNodes.update(
          sourceId,
          (value) => value..add(e.id),
          ifAbsent: () => [e.id],
        );
      } else {
        _allNodes.putIfAbsent(e.id, () => []);
      }
    }
  }
}

