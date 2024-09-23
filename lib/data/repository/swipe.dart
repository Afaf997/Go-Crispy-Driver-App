// import 'dart:developer';
// import 'package:resturant_delivery_boy/data/datasource/remote/exception/api_error_handler.dart';
// import 'package:resturant_delivery_boy/data/model/response/base/api_response.dart';
// import 'package:resturant_delivery_boy/main.dart';
// import 'package:resturant_delivery_boy/utill/app_constants.dart';


// Future<ApiResponse> getswipe(String orderId) async {
//   try {
//     // Use the dynamic orderId in the API URL
//     String apiUrl = 'https://project.artisans.qa/go-crispy-new/api/v1/delivery-man/out-of-delivery?order_id=$orderId';

//     // Append the token to the URL
//     final response = await dioClient!.get('$apiUrl&token=${sharedPreferences!.get(AppConstants.token)}');
    
//     // Log the token and full response data
//     log("Token: ${sharedPreferences!.get(AppConstants.token)}");
//     log("Response Data: ${response.data}");
    
//     return ApiResponse.withSuccess(response);
//   } catch (e) {
//     // Log the error message and return the error response
//     log("Error: ${ApiErrorHandler.getMessage(e)}");
//     return ApiResponse.withError(ApiErrorHandler.getMessage(e));
//   }
// }
