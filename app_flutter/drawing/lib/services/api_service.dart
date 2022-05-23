import 'dart:io';

import 'package:dio/dio.dart';

import '../constantes.dart';

class ApiService {
  final Dio client = Dio();

  Future<String> predict(File file) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: 'test'),
    });

    final response =
        await client.post<String>('$baseUrl/predict', data: formData);

    return response.data ?? "";
  }

  Future test() async {
    try {
      final response = await client.get('$baseUrl/test');

      print(response);
    } catch (e) {
      print(e);
    }
  }
}
