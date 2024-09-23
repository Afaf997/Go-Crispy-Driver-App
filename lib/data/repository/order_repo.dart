import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:resturant_delivery_boy/data/datasource/remote/dio/dio_client.dart';
import 'package:resturant_delivery_boy/data/datasource/remote/exception/api_error_handler.dart';
import 'package:resturant_delivery_boy/data/model/response/base/api_response.dart';
import 'package:resturant_delivery_boy/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  OrderRepo({required this.dioClient, required this.sharedPreferences});



Future<ApiResponse> performPostRequest() async {
  AudioPlayer audioPlayer = AudioPlayer();
  
  try {
    final response = await dioClient!.get('${AppConstants.currentOrdersUri}${sharedPreferences!.get(AppConstants.token)}');
    if (response.statusCode == 200) {
      await audioPlayer.play(AssetSource('assets/success_sound.mp3'));
    }

    return ApiResponse.withSuccess(response);
  } catch (e) {
    return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  }
}


  Future<ApiResponse> getOrderDetails({String? orderID}) async {
    try {
      final response = await dioClient!.get('${AppConstants.orderDetailsUri}${sharedPreferences!.get(AppConstants.token)}&order_id=$orderID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getAllOrderHistory() async {
    try {
      final response = await dioClient!.get('${AppConstants.orderHistoryUri}${sharedPreferences!.get(AppConstants.token)}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateOrderStatus({String? token, int? orderId, String? status}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.updateOrderStatusUri,
        data: {"token": token, "order_id": orderId, "status": status, "_method": 'put'},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> updatePaymentStatus({String? token, int? orderId, String? status}) async {
    try {
      Response response = await dioClient!.post(
        AppConstants.updatePaymentStatusUri,
        data: {"token": token, "order_id": orderId, "status": status, "_method": 'put'},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getOrderModel(String orderId) async {
    try {
      final response = await dioClient!.get('${AppConstants.getOrderModel}${sharedPreferences!.get(AppConstants.token)}&id=$orderId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

Future<ApiResponse> getAllOrders() async {
  try {
    final response = await dioClient!.get(
      '${AppConstants.currentOrdersUri}${sharedPreferences!.get(AppConstants.token)}'
    );
    if (response.data.isNotEmpty) {
      log(response.data[0].toString());
      int deliveryManId = response.data[0]['delivery_man_id'];
      await sharedPreferences!.setInt('delivery_man_id', deliveryManId);
      
      // Retrieve and log the delivery_man_id from shared preferences
      int? storedDeliveryManId = sharedPreferences!.getInt('delivery_man_id');
      log("Stored Delivery Man ID from Shared Preferences: $storedDeliveryManId");
    }

    return ApiResponse.withSuccess(response);
  } catch (e) {
    log("Error: ${ApiErrorHandler.getMessage(e)}");
    return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  }
}

Future<ApiResponse> outofdelivery({int? orderId}) async {
  try {
    log("Attempting to update order with ID: $orderId");

    // Make sure the URL is correct and properly formatted
    final String url = '${AppConstants.swipe}?order_id=$orderId';
    Response response = await dioClient!.post(url);

    log('Response received: ${response.data}');

    return ApiResponse.withSuccess(response);
  } catch (e) {
    log('API Error: ${ApiErrorHandler.getMessage(e)}');
    return ApiResponse.withError(ApiErrorHandler.getMessage(e));
  }
}


}
