import 'dart:convert';

import 'package:http/http.dart';
import 'package:dio/dio.dart' as dio;
import 'package:profanity_detector/util/constants.dart';

enum Intensity {
  high,
  medium,
  low,
}

class APIHelper {
  static Future<List<dynamic>> checkProfanity({required String text}) async {
    final Map<String, String> formData = {
      "text": text,
      "mode": "standard",
      "lang": "en",
      "api_user": Constants.API_USER,
      "api_secret": Constants.API_SECRET,
    };
    final url = Uri.parse(Constants.API_URL);
    final result = await post(
      url,
      body: formData,
    );
    final response = json.decode(result.body);
    return response["profanity"]["matches"];
  }

  static Future<dynamic> checkNudity({required String? path}) async {
    final formData = dio.FormData.fromMap({
      "image": await dio.MultipartFile.fromFile(
        path!,
      ),
    });

    final dioInstance = dio.Dio();
    final response = await dioInstance.post(
      Constants.NSFW_API,
      options: dio.Options(headers: Constants.NSFW_HEADERS),
      data: formData,
    );
    final result = response.data;
    return result;
  }
}
