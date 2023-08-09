// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bpmn_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BpmnStore on _BpmnStore, Store {
  late final _$elementsAtom =
      Atom(name: '_BpmnStore.elements', context: context);

  @override
  List<BpmnElement> get elements {
    _$elementsAtom.reportRead();
    return super.elements;
  }

  @override
  set elements(List<BpmnElement> value) {
    _$elementsAtom.reportWrite(value, super.elements, () {
      super.elements = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_BpmnStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isLoadedAtom =
      Atom(name: '_BpmnStore.isLoaded', context: context);

  @override
  bool get isLoaded {
    _$isLoadedAtom.reportRead();
    return super.isLoaded;
  }

  @override
  set isLoaded(bool value) {
    _$isLoadedAtom.reportWrite(value, super.isLoaded, () {
      super.isLoaded = value;
    });
  }

  late final _$userChoiceCompleterAtom =
      Atom(name: '_BpmnStore.userChoiceCompleter', context: context);

  @override
  Completer<void>? get userChoiceCompleter {
    _$userChoiceCompleterAtom.reportRead();
    return super.userChoiceCompleter;
  }

  @override
  set userChoiceCompleter(Completer<void>? value) {
    _$userChoiceCompleterAtom.reportWrite(value, super.userChoiceCompleter, () {
      super.userChoiceCompleter = value;
    });
  }

  late final _$showChoiceAtom =
      Atom(name: '_BpmnStore.showChoice', context: context);

  @override
  bool get showChoice {
    _$showChoiceAtom.reportRead();
    return super.showChoice;
  }

  @override
  set showChoice(bool value) {
    _$showChoiceAtom.reportWrite(value, super.showChoice, () {
      super.showChoice = value;
    });
  }

  late final _$nextElementsAtom =
      Atom(name: '_BpmnStore.nextElements', context: context);

  @override
  List<String> get nextElements {
    _$nextElementsAtom.reportRead();
    return super.nextElements;
  }

  @override
  set nextElements(List<String> value) {
    _$nextElementsAtom.reportWrite(value, super.nextElements, () {
      super.nextElements = value;
    });
  }

  late final _$chosenElementAtom =
      Atom(name: '_BpmnStore.chosenElement', context: context);

  @override
  String get chosenElement {
    _$chosenElementAtom.reportRead();
    return super.chosenElement;
  }

  @override
  set chosenElement(String value) {
    _$chosenElementAtom.reportWrite(value, super.chosenElement, () {
      super.chosenElement = value;
    });
  }

  late final _$getElementsAsyncAction =
      AsyncAction('_BpmnStore.getElements', context: context);

  @override
  Future<dynamic> getElements() {
    return _$getElementsAsyncAction.run(() => super.getElements());
  }

  @override
  String toString() {
    return '''
elements: ${elements},
isLoading: ${isLoading},
isLoaded: ${isLoaded},
userChoiceCompleter: ${userChoiceCompleter},
showChoice: ${showChoice},
nextElements: ${nextElements},
chosenElement: ${chosenElement}
    ''';
  }
}
