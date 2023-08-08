import 'package:bpmn_parse/data/flow_objects/flow_object.dart';

abstract class Gateway extends FlowObject {
  Gateway(super.id);

  void pass(Map<String, dynamic> vars);

  Future<void> passAsync(Map<String, dynamic> vars);
}