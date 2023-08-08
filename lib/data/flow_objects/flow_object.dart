class FlowObject {
  String id;
  FlowObject(this.id);

  @override
  String toString() {
    return '$id $runtimeType';
  }
}