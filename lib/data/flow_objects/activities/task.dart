import 'package:bpmn_parse/data/flow_objects/flow_object.dart';

abstract class Task extends FlowObject {
  String meta;
  Task(super.id, this.meta);

  void execute(Map<String, dynamic> vars);

  Future<void> executeAsync(Map<String, dynamic> vars);
}