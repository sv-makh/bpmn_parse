import 'package:bpmn_parse/data/bpmn_diagram.dart';
import 'package:bpmn_parse/data/fetcher.dart';
import 'package:bpmn_parse/stores/bpmn_store.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setUp() {
  getIt.registerSingleton(Fetcher());
  getIt.registerSingleton(BpmnDiagram());
  getIt.registerSingleton(BpmnStore(getIt.get<Fetcher>()));
}
