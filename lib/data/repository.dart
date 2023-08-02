import 'dart:convert';

import 'package:bpmn_parse/data/bpmn_element.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class Repository {
  Future<List<BpmnElement>> fetchBpmnElements() async {
    final responce = await http.get(Uri.parse(mockDataUri));

    if (responce.statusCode == 200) {
      print(jsonDecode(responce.body)['data']['bpmn']['elements'][0]);
      var listOfElements = jsonDecode(responce.body)['data']['bpmn']['elements'];
      return listOfElements
          .map((data) => BpmnElement.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load');
    }
  }
}
