import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl =
      'https://jsonplaceholder.typicode.com'; // Base API URL

  Future<List<dynamic>> fetchPosts() async {
    final response = await http.get(Uri.parse('$_baseUrl/posts'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load posts');
    }

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> fetchPostById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/posts/$id'));

    if (response.statusCode != 200) {
      throw Exception("Failed to load post");
    }

    return jsonDecode(response.body);
  }
}
