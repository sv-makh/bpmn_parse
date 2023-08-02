// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bpmn_element.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BpmnElement _$BpmnElementFromJson(Map<String, dynamic> json) => BpmnElement(
      id: json['id'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      metaName: json['metaName'] as String?,
      condition: json['condition'] as String?,
      subprocessId: json['subprocessId'] as String?,
      description: json['description'] as String?,
      inVariables: json['inVariables'] as List<dynamic>,
      outVariables: json['outVariables'] as String?,
      properties: (json['properties'] as List<dynamic>)
          .map((e) => Map<String, String>.from(e as Map))
          .toList(),
      dateCreated: json['dateCreated'] as String,
      authorCreated: json['authorCreated'] as String,
      dateUpdated: json['dateUpdated'] as String,
      authorUpdated: json['authorUpdated'] as String,
    );

Map<String, dynamic> _$BpmnElementToJson(BpmnElement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'metaName': instance.metaName,
      'condition': instance.condition,
      'subprocessId': instance.subprocessId,
      'description': instance.description,
      'inVariables': instance.inVariables,
      'outVariables': instance.outVariables,
      'properties': instance.properties,
      'dateCreated': instance.dateCreated,
      'authorCreated': instance.authorCreated,
      'dateUpdated': instance.dateUpdated,
      'authorUpdated': instance.authorUpdated,
    };
