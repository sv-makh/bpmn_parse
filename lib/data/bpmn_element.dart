import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bpmn_element.g.dart';

@JsonSerializable()
class BpmnElement extends Equatable {
  final String id;
  final String type;
  final String name;
  final String? metaName;
  final String? condition;
  final String? subprocessId;
  final String? description;
  final List<dynamic> inVariables;
  final String? outVariables;
  final List<Map<String, String>> properties;
  final String dateCreated;
  final String authorCreated;
  final String dateUpdated;
  final String authorUpdated;

  const BpmnElement({
    required this.id,
    required this.type,
    required this.name,
    this.metaName,
    this.condition,
    this.subprocessId,
    this.description,
    required this.inVariables,
    this.outVariables,
    required this.properties,
    required this.dateCreated,
    required this.authorCreated,
    required this.dateUpdated,
    required this.authorUpdated,
  });

  factory BpmnElement.fromJson(Map<String, dynamic> json) => _$BpmnElementFromJson(json);

  Map<String, dynamic> toJson() => _$BpmnElementToJson(this);

  @override
  String toString() {
    var choice = '';
    if (properties.length == 3) { choice = ' ${properties[2]['value']}'; }
    var meta = ' ${metaName ?? ''}';
    return '$id $type$meta$choice';
  }

  @override
  List<Object?> get props => [
        id,
        type,
        name,
        metaName,
        condition,
        subprocessId,
        description,
        inVariables,
        outVariables,
        properties,
        dateCreated,
        authorCreated,
        dateUpdated,
        authorUpdated,
      ];
}
