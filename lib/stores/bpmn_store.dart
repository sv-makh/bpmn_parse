import 'dart:async';

import 'package:bpmn_parse/data/bpmn_diagram.dart';
import 'package:bpmn_parse/data/fetcher.dart';
import 'package:mobx/mobx.dart';

import '../data/bpmn_element.dart';
import '../di/locator.dart';

part 'bpmn_store.g.dart';

class BpmnStore = _BpmnStore with _$BpmnStore;

abstract class _BpmnStore with Store {
  _BpmnStore(Fetcher fetcher)
      : _fetcher = fetcher;

  late final Fetcher _fetcher;

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

  @observable
  Map<String, dynamic> varsStorage = {};

  @observable
  String path = '';

  @action
  Future getElements() async {
    _resetStore();
    isLoading = true;
    final elementsList = await _fetcher.fetchBpmnElements();
    elements = elementsList;
    getIt.get<BpmnDiagram>().fillFromList(elements);
    isLoading = false;
    isLoaded = true;
  }

  void _resetStore() {
    isLoaded = false;
    nextElements.clear();
    showChoice = false;
    userChoiceCompleter = null;
    nextElements.clear();
    elements.clear();
    varsStorage.clear();
    getIt.get<BpmnDiagram>().clear();
  }
}
