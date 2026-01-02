import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://your-api-url.com/api';

  // Login Call
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'email': email, 'password': password},
    );
    return response.statusCode == 200;
  }

  // Fetch Dashboard Stats
  Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await http.get(Uri.parse('$baseUrl/dashboard/stats'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load stats');
    }
  }

  Future<Map<String, dynamic>> fetchDashboardData() async {
    // In a real app, you'd add headers: {'Authorization': 'Bearer $token'}
    final response = await http.get(Uri.parse("$baseUrl/admin/stats"));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      // Returning mock data for testing if API is not ready
      return {
        "total_registrations": "1,250",
        "total_doctors": "84",
        "pets_registered": "920",
        "today_bookings": "15",
      };
    }
  }
}
