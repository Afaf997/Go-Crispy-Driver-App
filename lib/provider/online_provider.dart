import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:resturant_delivery_boy/data/model/response/base/api_response.dart';
import 'package:resturant_delivery_boy/data/model/response/online_model.dart';
import 'package:resturant_delivery_boy/data/repository/online_repo.dart';
import 'package:resturant_delivery_boy/helper/api_checker.dart';

class OnlineProvider with ChangeNotifier {
  final OnlineRepo? onlineRepo;

  OnlineProvider({this.onlineRepo});

OnlineModel _onlineModel = OnlineModel(status: 'offline'); // Default status
  bool _isLoading = false;

  bool get isOnline => _onlineModel.status == 'online'; // Getter for online status

  bool get isLoading => _isLoading;
  OnlineModel? get onlineModel => _onlineModel;
Future<void> toggleOnlineStatus(BuildContext context, bool newValue) async {
  _isLoading = true;
  notifyListeners();

  ApiResponse apiResponse;
  if (newValue) {
    apiResponse = await onlineRepo!.getOnlineStatus();
  } else {
    apiResponse = await onlineRepo!.getOfflineStatus();
  }

  if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
    _onlineModel = OnlineModel(status: newValue ? 'online' : 'offline');
  } else {
    ApiChecker.checkApi(apiResponse);
  }

  _isLoading = false;
  notifyListeners();
}
Future<void> getInitialStatus(BuildContext context, String deliveryManId) async {
  _isLoading = true;
  notifyListeners();

  try {
    log('Fetching initial online status for Delivery Man ID: $deliveryManId');

    ApiResponse apiResponse = await onlineRepo!.getInitialOnlineStatus(deliveryManId);
    log('API Response: ${apiResponse.response}');  // Log full response

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      // Log status code and check response data
      log('Status Code: ${apiResponse.response!.statusCode}');
      final responseData = apiResponse.response!.data;
      log('Response Data: $responseData');  // Log the full response data

      if (responseData != null && responseData.containsKey('is_online')) {
        // Log the "is_online" field
        final int isOnline = responseData['is_online'] ?? 0; // Default to 0 if null
        log('Parsed isOnline value: $isOnline');

        // Set the online status in the model
        _onlineModel = OnlineModel(status: isOnline == 1 ? 'online' : 'offline');
        log('Updated OnlineModel status: ${_onlineModel.status}');
      } else {
        log('Error: "is_online" key not found in response.');
      }
    } else {
      log('Error: Invalid response or non-200 status code received.');
      ApiChecker.checkApi(apiResponse);
    }
  } catch (e, stacktrace) {
    log('Exception occurred during API call: $e');
    log('Stacktrace: $stacktrace');
  }

  _isLoading = false;
  log('Loading state set to false, UI should update.');
  notifyListeners();
}
}
