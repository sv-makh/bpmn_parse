import 'package:bpmn_parse/data/flow_objects/events/event.dart';

class EndEvent extends Event {
  EndEvent(super.id);

  @override
  void process(Map<String, dynamic> vars) {
    vars['endEvent'] = 'happened';
  }

  @override
  Future<void> processAsync(Map<String, dynamic> vars) async {
    vars['endEvent'] = 'happened';
    await Future.delayed(const Duration(seconds: 1));
  }

}