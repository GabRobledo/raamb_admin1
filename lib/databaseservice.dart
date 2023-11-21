import 'package:flutter/material.dart';
import 'package:flutter_application_1/lib/userdata.dart'; // Update the path as necessary
import 'lib/verificationsrequest.dart'; // Update the path as necessary
import 'package:http/http.dart' as http;
import 'dart:convert';

class DatabaseService with ChangeNotifier {
  List<User> _users = [];
  List<VerificationRequest> _verificationRequests = [];

  List<User> get users => _users;
  List<VerificationRequest> get verificationRequests => _verificationRequests;

  // Method to fetch users from MongoDB via your server
  Future<void> fetchUsers() async {
    
    try {
      final response = await http.get(Uri.parse('https://raamb-admin1-nvky-el4vaku3a-cravewolf.vercel.app/users')); // Update with your server URL
      if (response.statusCode == 200) {
        _users = (json.decode(response.body) as List).map((u) => User.fromMap(u)).toList();
        notifyListeners();
        print ('twerk');
        
      } else {
        print('Failed to fetch users. Status Code: ${response.statusCode}');
        print('$response');
      }
    } catch (e) {
      
      print('Error fetching users: $e');
      
    }
  }

  // Method to fetch verification requests from MongoDB via your server
  Future<void> fetchVerificationRequests() async {
    try {
      final response = await http.get(Uri.parse('https://raamb-admin1-nvky-el4vaku3a-cravewolf.vercel.app/verification-requests')); // Update with your server URL
      if (response.statusCode == 200) {
        _verificationRequests = (json.decode(response.body) as List).map((v) => VerificationRequest.fromMap(v)).toList();
        notifyListeners();
        print ('yaurr');
      } else {
        print('Failed to fetch verification requests. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching verification requests: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
