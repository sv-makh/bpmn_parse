import 'dart:convert';

import 'package:bpmn_parse/data/bpmn_element.dart';
import 'package:http/http.dart' as http;

const String mockDataUri = 'https://mocki.io/v1/42accf9e-86fe-4860-acf0-29144bf2d440';

class Fetcher {  
  Future<List<BpmnElement>> fetchBpmnElements() async {
    final response = await http.get(Uri.parse(mockDataUri));

    if (response.statusCode == 200) {
      var elements = jsonDecode(response.body)['data']['bpmn']['elements'];
      return List<BpmnElement>.from(elements
          .map((data) => BpmnElement.fromJson(data))
          .toList());
    } else {
      throw Exception('Failed to load');
    }
  }

}
