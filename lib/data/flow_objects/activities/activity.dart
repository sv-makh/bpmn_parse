import 'package:bpmn_parse/data/flow_objects/flow_object.dart';

abstract class Activity extends FlowObject {
  String meta;
  Activity(super.id, this.meta);

  void execute(Map<String, dynamic> vars);

  Future<void> executeAsync(Map<String, dynamic> vars);
}