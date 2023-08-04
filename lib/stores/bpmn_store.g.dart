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
isLoading: ${isLoading}
    ''';
  }
}
