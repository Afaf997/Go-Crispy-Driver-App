import 'dart:convert'; // For jsonDecode
import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/data/model/response/base/api_response.dart';
import 'package:resturant_delivery_boy/data/model/response/config_model.dart';
import 'package:resturant_delivery_boy/data/repository/splash_repo.dart';
import 'package:resturant_delivery_boy/helper/api_checker.dart';

class SplashProvider extends ChangeNotifier {
  final SplashRepo? splashRepo;
  SplashProvider({required this.splashRepo});

  ConfigModel? _configModel;
  BaseUrls? _baseUrls;

  ConfigModel? get configModel => _configModel;
  BaseUrls? get baseUrls => _baseUrls;

  Future<bool> initConfig(BuildContext context) async {
    ApiResponse apiResponse = await splashRepo!.getConfig();
    bool isSuccess;

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      var data = apiResponse.response!.data;

      // Check if the response data is a String and try to decode it as JSON
      if (data is String) {
        try {
          data = jsonDecode(data);
        } catch (e) {
          print('Failed to decode JSON: $e');
          return false;
        }
      }

      // Assign the parsed data to configModel and baseUrls
      _configModel = ConfigModel.fromJson(data);
      _baseUrls = _configModel!.baseUrls;
      
      isSuccess = true;
      notifyListeners();
    } else {
      isSuccess = false;
      ApiChecker.checkApi(apiResponse);
    }
    return isSuccess;
  }

  Future<bool> initSharedData() {
    return splashRepo!.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashRepo!.removeSharedData();
  }
}
