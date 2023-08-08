import 'package:bpmn_parse/data/flow_objects/events/event.dart';

class StartEvent extends Event {
  StartEvent(super.id);

  @override
  void process(Map<String, dynamic> vars) {
    vars['startEvent'] = 'happened';
  }

  @override
  Future<void> processAsync(Map<String, dynamic> vars) async {
    vars['startEvent'] = 'happened';
    await Future.delayed(const Duration(seconds: 1));
  }

}