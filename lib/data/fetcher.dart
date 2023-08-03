import 'dart:convert';

import 'package:bpmn_parse/data/bpmn_element.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class Fetcher {
  Future<List<BpmnElement>> fetchBpmnElements() async {
    final responce = await http.get(Uri.parse(mockDataUri));

    if (responce.statusCode == 200) {
      var elements = jsonDecode(responce.body)['data']['bpmn']['elements'];
      return List<BpmnElement>.from(elements
          .map((data) => BpmnElement.fromJson(data))
          .toList());
    } else {
      throw Exception('Failed to load');
    }
  }

}
