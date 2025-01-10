import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import 'token_manager.dart';

class ApiHelper {
  static const Duration timeoutDuration =
      Duration(seconds: 10); // Standard timeout.

  /// HTTP request handling with error handling
  static Future<Map<String, dynamic>> handleRequest(
      Future<http.Response> request,
      {bool isLoginRequest = false}) async {
    try {
      final response = await request.timeout(timeoutDuration);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': response.body,
          'statusCode': response.statusCode
        };
      } else {
        //status token expired
        return {
          'success': false,
          'error': response.body,
          'statusCode': response.statusCode
        };
      }
    } on SocketException {
      return {
        'success': false,
        'type': const SocketException('No internet connection')
      };
    } on TimeoutException {
      return {'success': false, 'type': TimeoutException('Request timed out')};
    } on FormatException {
      return {
        'success': false,
        'type': const FormatException('Invalid response format')
      };
    } catch (e) {
      return {'success': false, 'type': UnsupportedError('Unsupported error')};
    }
  }

  //refresh token
  static Future<Map<String, dynamic>> refreshToken() async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}auth/refreshToken');
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString(TokenManager.REFRESH_TOKEN_KEY);
    Map<String, dynamic> data = {};
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $refreshToken'
      },
      body: json.encode({'refreshToken': refreshToken}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      data = {
        'success': true,
        'data': response.body,
        'statusCode': response.statusCode
      };
    } else {
      //status token expired
      data = {
        'success': false,
        'error': response.body,
        'statusCode': response.statusCode
      };
    }
    //update token
    if (data['success']) {
      final token = json.decode(data['data'])['token']['result'];
      final tokenExpiry = DateTime.now().add(
          Duration(seconds: json.decode(data['data'])['token']['expiresIn']));

      await TokenManager.updateToken(token, tokenExpiry);
    }
    return data;
  }

  //validate token and refresh token expiry
  static Future<bool> validateToken() async {
    final isTokenExpired = await TokenManager.isTokenExpired();
    final isRefreshTokenExpired = await TokenManager.isRefreshTokenExpired();
    if (isTokenExpired && isRefreshTokenExpired) {
      logout();
      return false;
    } else if (isTokenExpired && !isRefreshTokenExpired) {
      final response = await refreshToken();
      if (response['success']) {
        return true;
      } else {
        logout();
        return false;
      }
    } else {
      return true;
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    //navigate to login screen
  }
}
