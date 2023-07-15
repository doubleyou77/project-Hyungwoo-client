import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class MLService {
  Dio dio = Dio();


  // ml server
  // https://github.com/PuzzleLeaf/tensorflow_flask_api_server
  Future<String?> convertDocImage (Uint8List imageData) async {

    try {
      var encodedData = await compute(base64Encode, imageData);
      Response response = await dio.post('http://192.168.0.38:5000/v1/ocr',
       data: {
         'image': encodedData
       }
      );

      if (response.statusCode == 200) {
        // 요청이 성공적으로 처리됨
        print('POST request succeeded');
        print(response.data);

      } else {
        // 요청이 실패함
        print('POST request failed with status code: ${response.statusCode}');
      }


      // Response response = await dio.post('https://port-0-flask-kvmh2mlk0ntkzl.sel4.cloudtype.app/v1',
      //     data: {
      //       'image': encodedData
      //     }
      // );
      http://192.168.0.38:5000
      String result = response.data;

      return result;
    } catch (e) {
      return null;
    }
  }

  Future<String?> answertoText (String context, String question) async {
    try {
      Response response = await dio.post('http://192.168.0.38:5000/v1/qa',
          data: {
            'context' : context,
            'question' : question,
          }
      );

      if (response.statusCode == 200) {
        // 요청이 성공적으로 처리됨
        print('POST request succeeded');
        print(response.data);

      } else {
        // 요청이 실패함
        print('POST request failed with status code: ${response.statusCode}');
      }


      String result = response.data;

      return result;
    } catch (e) {
      return null;
    }
  }
}
