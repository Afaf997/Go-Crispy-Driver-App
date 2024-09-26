import 'dart:developer';

import 'package:resturant_delivery_boy/data/datasource/remote/dio/dio_client.dart';
import 'package:resturant_delivery_boy/data/datasource/remote/exception/api_error_handler.dart';
import 'package:resturant_delivery_boy/data/model/response/base/api_response.dart';
import 'package:resturant_delivery_boy/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  StatusRepo({required this.dioClient, required this.sharedPreferences});

Future<ApiResponse> getStatus() async {
    try {
      log('Status url ===> ${AppConstants.orderCountUri}?delivery_man_id=${sharedPreferences!.get(AppConstants.token)}');
      final response = await dioClient!.get(
          '${AppConstants.orderCountUri}?delivery_man_id=${sharedPreferences!.get(AppConstants.token)}');
      log('Status Responce === > ${response.data}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
