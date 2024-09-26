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
    try {
      int? deliveryManId = sharedPreferences.getInt('delivery_man_id');
      // log("Retrieved Delivery Man ID for Online Status: $deliveryManId");

      final response = await dioClient.get(
        '${AppConstants.deliverymanOnlineUri}&delivery_man_id=$deliveryManId',
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getOfflineStatus() async {
    try {
      int? deliveryManId = sharedPreferences.getInt('delivery_man_id');
      // log("Retrieved Delivery Man ID for Offline Status: $deliveryManId");

      final response = await dioClient.get(
        '${AppConstants.deliveryOfflineUri}&delivery_man_id=$deliveryManId',
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // New method to get initial online status
  Future<ApiResponse> getInitialOnlineStatus(String deliveryManId) async {
    try {
      log("Retrieving Initial Online Status for Delivery Man ID: $deliveryManId");

      final response = await dioClient.post(
        '${AppConstants.baseUrl}api/v1/delivery-man/get-deliveryman-status?delivery_man_id=$deliveryManId',
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}