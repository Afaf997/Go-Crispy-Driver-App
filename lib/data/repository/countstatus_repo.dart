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
      // Get the token from shared preferences
      String? token = sharedPreferences!.getString(AppConstants.token);
      log("Token: " + token.toString());

      // Ensure token is available
      if (token == null) {
        return ApiResponse.withError("Token is missing");
      }

      // Correct API URL with delivery_man_id and token
      final String url = '${AppConstants.orderCountUri}?delivery_man_id=&token=$token';

      // Make the API request
      final response = await dioClient!.get(url);

      log('Status Response ===> ${response.data}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
