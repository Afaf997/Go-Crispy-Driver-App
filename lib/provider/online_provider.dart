import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/data/model/response/base/api_response.dart';
import 'package:resturant_delivery_boy/data/model/response/online_model.dart';
import 'package:resturant_delivery_boy/data/repository/online_repo.dart';
import 'package:resturant_delivery_boy/helper/api_checker.dart';

class OnlineProvider with ChangeNotifier {
  final OnlineRepo? onlineRepo;

  OnlineProvider({this.onlineRepo});

  OnlineModel? _onlineModel;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  OnlineModel? get onlineModel => _onlineModel;

  Future<void> toggleOnlineStatus(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    bool isCurrentlyOnline = _onlineModel?.status == 'online';

    ApiResponse apiResponse;
    if (isCurrentlyOnline) {
      apiResponse = await onlineRepo!.getOfflineStatus();
    } else {
      apiResponse = await onlineRepo!.getOnlineStatus();
    }

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _onlineModel = OnlineModel.fromJson(apiResponse.response!.data);
      _onlineModel!.status = isCurrentlyOnline ? 'offline' : 'online';
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getInitialStatus(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await onlineRepo!.getOnlineStatus(); 
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _onlineModel = OnlineModel.fromJson(apiResponse.response!.data);
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
  }
}
