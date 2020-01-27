import 'dart:io';

import 'package:dio/dio.dart';
import 'package:lama_frontend/constants.dart';
import 'package:lama_frontend/credential.dart';

class Authentication {
  Credential credential;
  Authentication(this.credential);
  String token;

  void regisNewUser() async {
    await Dio().post("${Constants.apiServer}/authenticate", data: credential.toObject());
  }

  Future fetchAuthToken() async {
    Response response = await Dio().post("${Constants.apiServer}/authenticate", data: credential.toObject());
    token = response.data['token'].toString();
    return response;
  }

  Options getCredentialOption() {
    return Options(
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token"
      }
    );
  }
}
