import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/data/model/response/base/api_response.dart';
import 'package:resturant_delivery_boy/data/model/response/status_model.dart';
import 'package:resturant_delivery_boy/data/repository/countstatus_repo.dart';
import 'package:resturant_delivery_boy/helper/api_checker.dart';

class StatusProvider with ChangeNotifier {
  final StatusRepo? statusRepo;

  StatusProvider({this.statusRepo});

  OrderCountModel? _orderCountModel;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  OrderCountModel? get orderCountModel => _orderCountModel;

  getStatusInfo(BuildContext context) async {
    _isLoading = true;
    ApiResponse apiResponse = await statusRepo!.getStatus();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _orderCountModel = OrderCountModel.fromJson(apiResponse.response!.data);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }
}
