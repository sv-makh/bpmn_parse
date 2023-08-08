import 'package:bpmn_parse/data/flow_objects/flow_object.dart';

abstract class Event extends FlowObject{
  Event(super.id);

  void process(Map<String, dynamic> vars);

  Future<void> processAsync(Map<String, dynamic> vars);

}