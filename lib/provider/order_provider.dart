import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/data/model/response/base/api_response.dart';
import 'package:resturant_delivery_boy/data/model/response/order_details_model.dart';
import 'package:resturant_delivery_boy/data/model/response/order_model.dart';
import 'package:resturant_delivery_boy/data/repository/order_repo.dart';
import 'package:resturant_delivery_boy/data/repository/response_model.dart';
import 'package:resturant_delivery_boy/helper/api_checker.dart';
import 'package:resturant_delivery_boy/helper/price_converter.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepo? orderRepo;

  OrderProvider({required this.orderRepo});

  // get all current order
  List<OrderModel> _currentOrders = [];
  List<OrderModel> _currentOrdersReverse = [];
  OrderModel? _currentOrderModel;
  String _orderTotalAmount = "0.0";
  double _orderHistoryTotal = 0.0;

  bool _isOrderHistoryLoading = false;

  OrderModel? get currentOrderModel => _currentOrderModel;

  List<OrderModel> get currentOrders => _currentOrders;
  String get orderTotalAmount => _orderTotalAmount;
  double get orderHistoryTotal => _orderHistoryTotal;
  bool get isOrderHistoryLoading => _isOrderHistoryLoading;

  Future getAllOrders(BuildContext context) async {
    ApiResponse apiResponse = await orderRepo!.getAllOrders();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _currentOrders = [];
      _currentOrdersReverse = [];

      apiResponse.response!.data.forEach((order) {
        _currentOrdersReverse.add(OrderModel.fromJson(order));
      });

      _currentOrders = List.from(_currentOrdersReverse.reversed);

      log('Processed Orders:' +
          _currentOrders[0].deliveryAddress!.longitude.toString());
    } else {
      ApiChecker.checkApi(apiResponse);
      print('API Error: ${apiResponse.error}');
    }

    notifyListeners();
  }

  // get order details
  final OrderDetailsModel _orderDetailsModel = OrderDetailsModel();

  OrderDetailsModel get orderDetailsModel => _orderDetailsModel;
  List<OrderDetailsModel>? _orderDetails;

  List<OrderDetailsModel>? get orderDetails => _orderDetails;

  Future<List<OrderDetailsModel>?> getOrderDetails(
      String orderID, BuildContext context) async {
    _orderDetails = null;
    ApiResponse apiResponse =
        await orderRepo!.getOrderDetails(orderID: orderID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _orderDetails = [];
      apiResponse.response!.data.forEach((orderDetail) =>
          _orderDetails!.add(OrderDetailsModel.fromJson(orderDetail)));
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return _orderDetails;
  }

  // get all order history
  List<OrderModel>? _allOrderHistory;
  late List<OrderModel> _allOrderReverse;

  List<OrderModel>? get allOrderHistory => _allOrderHistory;

  // Future<List<OrderModel>?> getOrderHistory(BuildContext context) async {
  //   ApiResponse apiResponse = await orderRepo!.getAllOrderHistory();
  //   if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
  //     _allOrderHistory = [];
  //     _allOrderReverse = [];
  //     apiResponse.response!.data.forEach((orderDetail) => _allOrderReverse.add(OrderModel.fromJson(orderDetail)));
  //     _allOrderHistory = List.from(_allOrderReverse.reversed);
  //     _allOrderHistory!.removeWhere((order) => (order.orderStatus) != 'delivered');
  //   } else {
  //     ApiChecker.checkApi(apiResponse);
  //   }
  //   notifyListeners();
  //   return _allOrderHistory;
  // }
  Future<List<OrderModel>?> getOrderHistory(
      BuildContext context, bool? isFiltered, DateTimeRange? range) async {
    _isOrderHistoryLoading = true;
    ApiResponse apiResponse = await orderRepo!.getAllOrderHistory();

    double _temporderTotalAmount = 0.0; // Initialize total amount
    _orderHistoryTotal = 0.0;

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _allOrderHistory = [];
      _allOrderReverse = [];

      apiResponse.response!.data.forEach((orderDetail) {
        OrderModel order = OrderModel.fromJson(orderDetail);

        // Add each order to the reverse list
        _allOrderReverse.add(order);

        // Sum the order amounts for delivered orders
        // if (order.orderStatus == 'delivered') {
        //   _orderTotalAmount += (order.orderAmount ?? 0.0) +
        //       (order.deliveryCharge ??
        //           0.0); // Safely sum both orderAmount and deliveryCharge
        // }
      });

      // Reverse the order list
      _allOrderHistory = List.from(_allOrderReverse.reversed);

      // Remove non-delivered orders from the list
      _allOrderHistory!
          .removeWhere((order) => order.orderStatus != 'delivered');

      _allOrderHistory!.forEach((order) {
        PriceConverter.convertPrice(
            context, (order.orderAmount ?? 0) + (order.deliveryCharge ?? 0));
        _temporderTotalAmount +=
            (order.orderAmount ?? 0.0) + (order.deliveryCharge ?? 0.0);
        _orderTotalAmount = _temporderTotalAmount.toString();
        _orderHistoryTotal = _temporderTotalAmount;
      });

      if (isFiltered != null && isFiltered) {
        if (range != null) {
          _orderHistoryTotal = 0.0;
          log(range.toString());

          notifyListeners();
          print(_isOrderHistoryLoading);
          // _allOrderHistory = _allOrderHistory!.where((order) {
          //   DateTime updatedAt = DateTime.parse(order.updatedAt!);
          //   return updatedAt.isAfter(range!.start) &&
          //       updatedAt.isBefore(range.end);
          // }).toList();
          _allOrderHistory = _allOrderHistory!.where((order) {
            DateTime updatedAt = DateTime.parse(order.updatedAt!);
            // Create a DateTime that includes the whole end date by setting it to 23:59:59
            DateTime endDate = DateTime(
                range!.end.year, range.end.month, range.end.day, 23, 59, 59);

            return updatedAt.isAtSameMomentAs(range.start) ||
                updatedAt.isAtSameMomentAs(endDate) ||
                (updatedAt.isAfter(range.start) && updatedAt.isBefore(endDate));
          }).toList();
          // notifyListeners()
          log(_allOrderHistory.toString());

          // Calculating the total sum of the filtered orders' amounts
          // _orderHistoryTotal = _allOrderHistory!.fold(0.0, (sum, order) {
          //   return sum + (order.orderAmount ?? 0.0);
          // });
          _allOrderHistory!.forEach((order) {
            PriceConverter.convertPrice(context,
                (order.orderAmount ?? 0) + (order.deliveryCharge ?? 0));
            _orderHistoryTotal +=
                (order.orderAmount ?? 0.0) + (order.deliveryCharge ?? 0.0);
            // _orderTotalAmount = _temporderTotalAmount.toString();
            // _orderHistoryTotal = _temporderTotalAmount;
          });

          print(_isOrderHistoryLoading);
        }
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    notifyListeners();
    _isOrderHistoryLoading = false;

    print(
        'Total Order Amount: $_orderTotalAmount'); // Debug print to check total amount

    return _allOrderHistory;
  }

  // update Order Status
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? _feedbackMessage;

  String? get feedbackMessage => _feedbackMessage;

  Future<ResponseModel> updateOrderStatus(
      {String? token, int? orderId, String? status}) async {
    _isLoading = true;
    _feedbackMessage = '';
    notifyListeners();
    ApiResponse apiResponse = await orderRepo!
        .updateOrderStatus(token: token, orderId: orderId, status: status);

    ResponseModel responseModel;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      //  _currentOrdersReverse[index].orderStatus = status;
      _feedbackMessage = apiResponse.response!.data['message'];
      responseModel =
          ResponseModel(apiResponse.response!.data['message'], true);
    } else {
      _feedbackMessage = ApiChecker.getError(apiResponse).errors![0].message;
      responseModel = ResponseModel(_feedbackMessage, false);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> updatedeliveryorder({
    String? token,
    int? orderId,
  }) async {
    _isLoading = true;
    _feedbackMessage = '';
    notifyListeners();

    ApiResponse apiResponse = await orderRepo!.outofdelivery(orderId: orderId);
    ResponseModel? responseModel;

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (apiResponse.response!.data != null) {
        _feedbackMessage = apiResponse.response!.data['message'] ??
            'Order updated successfully';
        log('Success: $_feedbackMessage');
        responseModel = ResponseModel(_feedbackMessage, true);
      } else {
        _feedbackMessage = 'No message found in response';
        log('Error: No message found in response');
        responseModel = ResponseModel(_feedbackMessage, false);
      }
    } else {
      _feedbackMessage = 'Failed to update order';
      log('Error: ${apiResponse.error.toString()}');
      responseModel = ResponseModel(_feedbackMessage, false);
    }

    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future updatePaymentStatus(
      {String? token, int? orderId, String? status}) async {
    await orderRepo!
        .updatePaymentStatus(token: token, orderId: orderId, status: status);
    notifyListeners();
  }

  Future<List<OrderModel>?> refresh(BuildContext context) async {
    getAllOrders(context);
    Timer(const Duration(seconds: 5), () {});
    return getOrderHistory(context, false, null);
  }

  Future<OrderModel?> getOrderModel(String orderID) async {
    _currentOrderModel = null;
    ApiResponse apiResponse = await orderRepo!.getOrderModel(orderID);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _currentOrderModel = OrderModel.fromJson(apiResponse.response!.data);
      log(_currentOrderModel.toString());
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
    return _currentOrderModel;
  }
}
