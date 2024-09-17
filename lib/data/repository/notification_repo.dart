// import 'package:dio/dio.dart';
// import 'package:resturant_delivery_boy/data/datasource/remote/dio/dio_client.dart';
// import 'package:resturant_delivery_boy/data/model/response/base/api_response.dart';
// import 'package:resturant_delivery_boy/utill/app_constants.dart';

// class getNotificationservices {
//   Dio dio = Dio();
//     final DioClient? dioClient;

//   Future<ApiResponse> getNotificationFunc() async {
//     try {
//   final response = await dioClient!.get('${AppConstants.currentOrdersUri}${sharedPreferences!.get(AppConstants.token)}');

//       Response response = await dio.get(apiUrl);
//       if (response.statusCode == 200) {
//         return response.data;
//       } else {
//         throw Exception("Failed to retrieve user details. Status code: ${response.statusCode}");
//       }
//     } catch (error) {
//       print('Error fetchi ang user details: $error');
//       throw Exception("Error fetching user details: $error");
//     }
//   }


//     Future<ApiResponse> getAllOrders() async {
//     try {
//       final response = await dioClient!.get('${AppConstants.currentOrdersUri}${sharedPreferences!.get(AppConstants.token)}');
//       // log("${sharedPreferences!.get(AppConstants.token)}");
//       return ApiResponse.withSuccess(response);
//     } catch (e) {
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e));
//     }
//   }
// }