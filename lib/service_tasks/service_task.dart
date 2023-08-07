abstract class ServiceTask {

  ServiceTask();

  void execute(Map<String, dynamic> vars);

  Future<void> executeAsync(Map<String, dynamic> vars);
}
