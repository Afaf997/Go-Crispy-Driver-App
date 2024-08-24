import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:resturant_delivery_boy/data/datasource/remote/dio/dio_client.dart';
import 'package:resturant_delivery_boy/data/datasource/remote/exception/api_error_handler.dart';
import 'package:resturant_delivery_boy/data/model/response/base/api_response.dart';
import 'package:resturant_delivery_boy/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnlineRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
                    
  OnlineRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getOnlineStatus() async {
      log(sharedPreferences.getString(AppConstants.token).toString());
    try {
      final response = await dioClient.get(
        AppConstants.deliverymanOnlineUri,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${sharedPreferences.getString(AppConstants.token)}',
          },
        ),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getOfflineStatus() async {
     log(sharedPreferences.getString(AppConstants.token).toString());            
    try {
      final response = await dioClient.get(
        AppConstants.deliveryOfflineUri,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${sharedPreferences.getString(AppConstants.token)}',
          },
        ),
      );
   
      return ApiResponse.withSuccess(response);
      
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
