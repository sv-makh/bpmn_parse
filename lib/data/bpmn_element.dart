import 'package:equatable/equatable.dart';

class BpmnElement extends Equatable {
  final String id;
  final String type;
  final String name;
  final String metaName;
  final String condition;
  final String subprocessId;
  final String description;
  final List<dynamic> inVariables;
  final String outVariables;
  final List<Map<String, String>> properties;
  final String dateCreated;
  final String authorCreated;
  final String dateUpdated;
  final String authorUpdated;

  const BpmnElement({
    required this.id,
    required this.type,
    required this.name,
    required this.metaName,
    required this.condition,
    required this.subprocessId,
    required this.description,
    required this.inVariables,
    required this.outVariables,
    required this.properties,
    required this.dateCreated,
    required this.authorCreated,
    required this.dateUpdated,
    required this.authorUpdated,
  });

  @override
  List<Object> get props => [
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
