import 'package:bpmn_parse/service_tasks/service_task.dart';

class InitApp extends ServiceTask {
  InitApp();

  @override
  void execute(Map<String, dynamic> vars) {
    vars['initApp'] = 'ok';
  }

  @override
  Future<void> executeAsync(Map<String, dynamic> vars) async {
    vars['initApp'] = 'ok';
    await Future.delayed(const Duration(seconds: 1));
  }
}
