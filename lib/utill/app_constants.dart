import 'package:resturant_delivery_boy/data/model/response/language_model.dart';
import 'package:resturant_delivery_boy/utill/images.dart';

class AppConstants {
  static const String appName = 'Restaurant Delivery Man';
  static const double appVersion = 10.2;
  static const String baseUrl = 'https://project.artisans.qa/go-crispy-new/';
  static const String profileUri = '/api/v1/delivery-man/profile?token=';
  static const String configUri = '/api/v1/config';
  static const String loginUri = '/api/v1/auth/delivery-man/login';
  static const String deliverymanOnlineUri = '/api/v1/delivery-man/deliveryman-status?delivery_man_id=is_online=1';
  static const String deliveryOfflineUri = '/api/v1/delivery-man/deliveryman-status?delivery_man_id=is_online=0';
  static const String orderCountUri = '/api/v1/delivery-man/deliveryman-orders-count?delivery_man_id=1';
  static const String notificationUri = '/api/v1/notifications';
  static const String updateProfileUri = '/api/v1/customer/update-profile';
  static const String currentOrdersUri = '/api/v1/delivery-man/current-orders?token=';
  static const String orderDetailsUri = '/api/v1/delivery-man/order-details?token=';
  static const String orderHistoryUri = '/api/v1/delivery-man/all-orders?token=';
  static const String recordLocationUri = '/api/v1/delivery-man/record-location-data';
  static const String updateOrderStatusUri = '/api/v1/delivery-man/update-order-status';
  static const String updatePaymentStatusUri = '/api/v1/delivery-man/update-payment-status';
  static const String tokenUri = '/api/v1/delivery-man/update-fcm-token';
  static const String getMessageUri = '/api/v1/delivery-man/message/get-message';
  static const String sendMessageUri = '/api/v1/delivery-man/message/send/deliveryman';
  static const String getOrderModel = '/api/v1/delivery-man/order-model?token=';
  static const String register = '/api/v1/auth/delivery-man/register';
    static const String popup='https://project.artisans.qa/go-crispy/api/v1/delivery-man/check-new-orders?delivery_man_id=1';
 static const String swipe='https://project.artisans.qa/go-crispy-new/api/v1/delivery-man/out-of-delivery?order_id=100351';


  // Shared Key
  static const String theme = 'theme';
  static const String token = 'token';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String cartList = 'cart_list';
  static const String userPassword = 'user_password';
  static const String userEmail = 'user_email';
  static const String orderId = 'order_id';

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: Images.unitedKingdom, languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: Images.arabic, languageName: 'Arabic', countryCode: 'SA', languageCode: 'ar'),
  ];
}
