import 'dart:async';

import 'package:bpmn_parse/data/bpmn_diagram.dart';
import 'package:bpmn_parse/data/fetcher.dart';
import 'package:mobx/mobx.dart';

import '../data/bpmn_element.dart';
import '../di/locator.dart';

part 'bpmn_store.g.dart';

class BpmnStore = _BpmnStore with _$BpmnStore;

abstract class _BpmnStore with Store {
  _BpmnStore(Fetcher fetcher)//, BpmnDiagram diagram)
      : _fetcher = fetcher;//,
        //_diagram = diagram;

  late final Fetcher _fetcher;
  //late final BpmnDiagram _diagram;

  @observable
  List<BpmnElement> elements = [];

  @observable
  bool isLoading = false;

  @observable
  bool isLoaded = false;

  @observable
  Completer<void>? userChoiceCompleter;

  @observable
  bool showChoice = false;

  @observable
  List<String> nextElements = [];

  @observable
  String chosenElement = '';

  @action
  Future getElements() async {
    isLoading = true;
    final elementsList = await _fetcher.fetchBpmnElements();
    elements = elementsList;
    print('fetched ${elements.length} el');
    getIt.get<BpmnDiagram>().fillFromList(elements);
    print('1st el - ${getIt.get<BpmnDiagram>().firstElementId()}');
    isLoading = false;
    isLoaded = true;
  }

  @action
  void initializeDiagram() {
    getIt.get<BpmnDiagram>().fillFromList(elements);
    //_diagram = BpmnDiagram.fromList(elements);
  }
}
