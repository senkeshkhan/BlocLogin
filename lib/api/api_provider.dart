import 'dart:io';

import 'package:http/http.dart' as http;

class ApiProvider {
  static const baseUrl = "";

  getHeader(String token) {
    return {
      'device': 'mobile',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    };
  }

  Future<dynamic> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/login');
      // final response = await http.post(
      //   url,
      //   body: jsonEncode(
      //     {"email": email, "password": password},
      //   ),
      //   // headers: getHeader(''),
      // );
      // return response;

      final request = http.MultipartRequest("POST", url);
      // request.headers.addAll(getHeader(''));
      request.fields['email'] = email;
      request.fields['password'] = password;
      // request.files
      //     .add(await http.MultipartFile.fromPath('image', 'file_path'));
      final response = await request.send();
      final streamResponse = await http.Response.fromStream(response);
      return streamResponse;
    } catch (e) {
      return Exception("Cannot login right now");
    }
  }

  // Future<dynamic> getMethod() async {
  //   try {
  //     final url = Uri.parse('uri');
  //     final response = http.get(
  //       url,
  //       headers: getHeader(''),
  //     );
  //     return response;
  //   } catch (e) {
  //     return Exception("Cannot login right now");
  //   }
  // }
}
