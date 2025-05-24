import 'dart:convert';
import 'dart:io';
import '../models/user.dart';

class ApiService {
  static const String _baseUrl = 'https://randomuser.me/api';
  static const int _resultsPerPage = 20;

  Future<List<User>> fetchUsers(int page) async {
    final uri = Uri.parse('$_baseUrl?page=$page&results=$_resultsPerPage');
    
    final httpClient = HttpClient();
    try {
      final request = await httpClient.getUrl(uri);
      final response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        final responseBody = await response.transform(utf8.decoder).join();
        final jsonData = json.decode(responseBody);
        final List<dynamic> userList = jsonData['results'];
        return userList.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } finally {
      httpClient.close();
    }
  }
}
