import 'package:bpmn_parse/data/flow_objects/gateways/gateway.dart';

class ExclusiveGateway extends Gateway {
  ExclusiveGateway(super.id);

  @override
  void pass(Map<String, dynamic> vars) {
    vars['exclusiveGateway'] = 'passed';
  }

  @override
  Future<void> passAsync(Map<String, dynamic> vars) async {
    vars['exclusiveGateway'] = 'passed';
    await Future.delayed(const Duration(seconds: 1));
  }
}