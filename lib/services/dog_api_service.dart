import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/dog_model.dart';

class ApiService {
  static const String baseUrl = 'https://freetestapi.com/api/v1';

  Future<List<Dog>> getDogs() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/dogs'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Dog.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load dogs');
      }
    } catch (e) {
      throw Exception('Error fetching dogs: $e');
    }
  }
}
