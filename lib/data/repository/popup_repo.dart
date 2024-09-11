import 'package:resturant_delivery_boy/data/datasource/remote/dio/dio_client.dart';
import 'package:resturant_delivery_boy/data/datasource/remote/exception/api_error_handler.dart';
import 'package:resturant_delivery_boy/data/model/response/base/api_response.dart';
import 'package:resturant_delivery_boy/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PopupRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  PopupRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponse> getpopup() async {
    try {
      final response = await dioClient!.get('${AppConstants.popup}${sharedPreferences!.getString(AppConstants.token)}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}

