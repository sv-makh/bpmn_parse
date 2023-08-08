import 'package:bpmn_parse/data/flow_objects/activities/activity.dart';

class UserTask extends Activity {
  UserTask(super.id, super.meta);

  @override
  void execute(Map<String, dynamic> vars) {
    vars[super.meta] = 'done';
  }

  @override
  Future<void> executeAsync(Map<String, dynamic> vars) async {
    vars[super.meta] = 'done';
    await Future.delayed(const Duration(seconds: 1));
  }
}