import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/data/model/response/base/api_response.dart';
import 'package:resturant_delivery_boy/data/model/response/userinfo_model.dart';
import 'package:resturant_delivery_boy/data/repository/online_repo.dart';
import 'package:resturant_delivery_boy/data/repository/profile_repo.dart';
import 'package:resturant_delivery_boy/helper/api_checker.dart';

class OnlineProvider with ChangeNotifier {
  final OnlineRepo? onlineRepo;

  OnlineProvider(this.onlineRepo,);

  UserInfoModel? _userInfoModel;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserInfoModel? get userInfoModel => _userInfoModel;

  getUserInfo(BuildContext context) async {
    _isLoading = true;
    ApiResponse apiResponse = await onlineRepo!.getOnlineshow();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _userInfoModel = UserInfoModel.fromJson(apiResponse.response!.data);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }
}
