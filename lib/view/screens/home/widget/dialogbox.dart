// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:resturant_delivery_boy/data/datasource/remote/exception/api_error_handler.dart';
// import 'package:resturant_delivery_boy/data/model/response/base/api_response.dart';
// import 'package:resturant_delivery_boy/data/model/response/order_model.dart';
// import 'package:resturant_delivery_boy/helper/price_converter.dart';
// import 'package:resturant_delivery_boy/localization/language_constrants.dart';
// import 'package:resturant_delivery_boy/main.dart';
// import 'package:resturant_delivery_boy/provider/order_provider.dart';
// import 'package:resturant_delivery_boy/utill/app_constants.dart';
// import 'package:resturant_delivery_boy/utill/dimensions.dart';
// import 'package:resturant_delivery_boy/utill/styles.dart';
// import 'package:resturant_delivery_boy/view/base/custom_button.dart';
// import 'package:resturant_delivery_boy/view/screens/order/order_details_screen.dart';
// import 'package:provider/provider.dart';

// class DeliveryDialogbox extends StatelessWidget {
//   final Function onTap;
//   final OrderModel? orderModel; // OrderModel can be null
//   final double? totalPrice;

//   const DeliveryDialogbox({Key? key, required this.onTap, this.totalPrice, this.orderModel}) : super(key: key);

//   Future<ApiResponse> callOutOfDeliveryApi(String orderId) async {
//   try {
//     // Making the API call
//     final response = await dioClient!.get('${AppConstants.swipe}${sharedPreferences!.get(AppConstants.token)}');
//     log("API Response: ${response.data}");
//     log("Response Code: ${response.statusCode}");

//     if (response.statusCode == 200) {
//       log('Out of delivery API called successfully for order ID: $orderId');
//       return ApiResponse.withSuccess(response);
//     } else {
//       log('Failed to call out of delivery API for order ID: $orderId');
//       return ApiResponse.withError('Failed with status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     log("Error: ${ApiErrorHandler.getMessage(e)}");
//     return ApiResponse.withError(ApiErrorHandler.getMessage(e)); // Return error response
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         decoration: BoxDecoration(
//             color: Theme.of(context).cardColor,
//             borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
//             border: Border.all(color: Theme.of(context).primaryColor, width: 0.2)),
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 20),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: Text(
//                     getTranslated('out of delivery', context)!,
//                     style: rubikRegular,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: Text(
//                     PriceConverter.convertPrice(context, totalPrice),
//                     style: rubikMedium.copyWith(
//                         color: Theme.of(context).primaryColor, fontSize: 30),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: CustomButton(
//                         btnTxt: getTranslated('no', context),
//                         isShowBorder: true,
//                         onTap: () {
//                           Navigator.pop(context);
//                           Navigator.of(context).pushReplacement(MaterialPageRoute(
//                               builder: (_) => OrderDetailsScreen(orderModelItem: orderModel)));
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: Dimensions.paddingSizeDefault),
//                     Expanded(
//                       child: Consumer<OrderProvider>(
//                         builder: (context, order, child) {
//                           return !order.isLoading
//                               ? CustomButton(
//                                   btnTxt: getTranslated('yes', context),
//                                   onTap: () {
//                                     if (orderModel != null) {
//                                       String orderId = orderModel!.id.toString(); // Null check applied here
//                                       callOutOfDeliveryApi(orderId);
//                                       Navigator.pop(context);
//                                     } else {
//                                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                         content: Text('Order data is unavailable. Please try again.'),
//                                       ));
//                                     }
//                                   },
//                                 )
//                               : Center(
//                                   child: CircularProgressIndicator(
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                         Theme.of(context).primaryColor),
//                                   ),
//                                 );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             Positioned(
//               right: -20,
//               top: -20,
//               child: IconButton(
//                   padding: const EdgeInsets.all(0),
//                   icon: const Icon(Icons.clear, size: Dimensions.paddingSizeLarge),
//                   onPressed: () {
//                     Navigator.pop(context);
//                     Navigator.of(context).pushReplacement(MaterialPageRoute(
//                         builder: (_) => OrderDetailsScreen(orderModelItem: orderModel)));
//                   }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:developer';
// import 'package:dio/dio.dart';
// import 'package:resturant_delivery_boy/data/datasource/remote/exception/api_error_handler.dart';
// import 'package:resturant_delivery_boy/data/model/response/base/api_response.dart';
// import 'package:resturant_delivery_boy/main.dart';
// import 'package:resturant_delivery_boy/utill/app_constants.dart';

// Future<ApiResponse> callOutOfDeliveryApi(String orderId) async {
//   try {
//     // Making the API call dynamically with order ID
//     final response = await dioClient!.get(
//       'https://project.artisans.qa/go-crispy-new/api/v1/delivery-man/out-of-delivery?order_id=$orderId',
//       options: Options(
//         headers: {
//           'Authorization': 'Bearer ${sharedPreferences!.get(AppConstants.token)}'
//         }
//       ),
//     );
    
//     log("API Response: ${response.data}");
//     log("Response Code: ${response.statusCode}");

//     if (response.statusCode == 200) {
//       log('Out of delivery API called successfully for order ID: $orderId');
//       return ApiResponse.withSuccess(response);
//     } else {
//       log('Failed to call out of delivery API for order ID: $orderId');
//       return ApiResponse.withError('Failed with status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     // Catch any exceptions that occur during the API call
//     log("Error: ${ApiErrorHandler.getMessage(e)}");
//     return ApiResponse.withError(ApiErrorHandler.getMessage(e)); // Return error response
//   }
// }
