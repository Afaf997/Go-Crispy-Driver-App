class CurrentOrder {
  int id;
  int userId;
  int isGuest;
  double orderAmount;
  double couponDiscountAmount;
  String? couponDiscountTitle;
  String paymentStatus;
  String orderStatus;
  double totalTaxAmount;
  String paymentMethod;
  String? transactionReference;
  int deliveryAddressId;
  DateTime createdAt;
  DateTime updatedAt;
  int checked;
  int deliveryManId;
  double deliveryCharge;
  String? orderNote;
  String? couponCode;
  String orderType;
  String? carPlateNo;
  int branchId;
  String? callback;
  DateTime deliveryDate;
  String deliveryTime;
  double extraDiscount;
  DeliveryAddress deliveryAddress;
  int preparationTime;
  int? tableId;
  int? numberOfPeople;
  int? tableOrderId;
  String orderFrom;
  Customer customer;
  List<dynamic> orderPartialPayments;

  CurrentOrder({
    required this.id,
    required this.userId,
    required this.isGuest,
    required this.orderAmount,
    required this.couponDiscountAmount,
    this.couponDiscountTitle,
    required this.paymentStatus,
    required this.orderStatus,
    required this.totalTaxAmount,
    required this.paymentMethod,
    this.transactionReference,
    required this.deliveryAddressId,
    required this.createdAt,
    required this.updatedAt,
    required this.checked,
    required this.deliveryManId,
    required this.deliveryCharge,
    this.orderNote,
    this.couponCode,
    required this.orderType,
    this.carPlateNo,
    required this.branchId,
    this.callback,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.extraDiscount,
    required this.deliveryAddress,
    required this.preparationTime,
    this.tableId,
    this.numberOfPeople,
    this.tableOrderId,
    required this.orderFrom,
    required this.customer,
    required this.orderPartialPayments,
  });

  factory CurrentOrder.fromJson(Map<String, dynamic> json) {
    return CurrentOrder(
      id: json['id'],
      userId: json['user_id'],
      isGuest: json['is_guest'],
      orderAmount: json['order_amount'].toDouble(),
      couponDiscountAmount: json['coupon_discount_amount'].toDouble(),
      couponDiscountTitle: json['coupon_discount_title'],
      paymentStatus: json['payment_status'],
      orderStatus: json['order_status'],
      totalTaxAmount: json['total_tax_amount'].toDouble(),
      paymentMethod: json['payment_method'],
      transactionReference: json['transaction_reference'],
      deliveryAddressId: json['delivery_address_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      checked: json['checked'],
      deliveryManId: json['delivery_man_id'],
      deliveryCharge: json['delivery_charge'].toDouble(),
      orderNote: json['order_note'],
      couponCode: json['coupon_code'],
      orderType: json['order_type'],
      carPlateNo: json['car_plateno'],
      branchId: json['branch_id'],
      callback: json['callback'],
      deliveryDate: DateTime.parse(json['delivery_date']),
      deliveryTime: json['delivery_time'],
      extraDiscount: json['extra_discount'].toDouble(),
      deliveryAddress: DeliveryAddress.fromJson(json['delivery_address']),
      preparationTime: json['preparation_time'],
      tableId: json['table_id'],
      numberOfPeople: json['number_of_people'],
      tableOrderId: json['table_order_id'],
      orderFrom: json['order_from'],
      customer: Customer.fromJson(json['customer']),
      orderPartialPayments: List<dynamic>.from(json['order_partial_payments']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'is_guest': isGuest,
      'order_amount': orderAmount,
      'coupon_discount_amount': couponDiscountAmount,
      'coupon_discount_title': couponDiscountTitle,
      'payment_status': paymentStatus,
      'order_status': orderStatus,
      'total_tax_amount': totalTaxAmount,
      'payment_method': paymentMethod,
      'transaction_reference': transactionReference,
      'delivery_address_id': deliveryAddressId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'checked': checked,
      'delivery_man_id': deliveryManId,
      'delivery_charge': deliveryCharge,
      'order_note': orderNote,
      'coupon_code': couponCode,
      'order_type': orderType,
      'car_plateno': carPlateNo,
      'branch_id': branchId,
      'callback': callback,
      'delivery_date': deliveryDate.toIso8601String(),
      'delivery_time': deliveryTime,
      'extra_discount': extraDiscount,
      'delivery_address': deliveryAddress.toJson(),
      'preparation_time': preparationTime,
      'table_id': tableId,
      'number_of_people': numberOfPeople,
      'table_order_id': tableOrderId,
      'order_from': orderFrom,
      'customer': customer.toJson(),
      'order_partial_payments': orderPartialPayments,
    };
  }
}

class DeliveryAddress {
  int id;
  String addressType;
  String contactPersonNumber;
  String? floor;
  String? house;
  String? road;
  String address;
  String latitude;
  String longitude;
  DateTime createdAt;
  DateTime updatedAt;
  int userId;
  int isGuest;
  String contactPersonName;

  DeliveryAddress({
    required this.id,
    required this.addressType,
    required this.contactPersonNumber,
    this.floor,
    this.house,
    this.road,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.isGuest,
    required this.contactPersonName,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      id: json['id'],
      addressType: json['address_type'],
      contactPersonNumber: json['contact_person_number'],
      floor: json['floor'],
      house: json['house'],
      road: json['road'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      userId: json['user_id'],
      isGuest: json['is_guest'],
      contactPersonName: json['contact_person_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address_type': addressType,
      'contact_person_number': contactPersonNumber,
      'floor': floor,
      'house': house,
      'road': road,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user_id': userId,
      'is_guest': isGuest,
      'contact_person_name': contactPersonName,
    };
  }
}

class Customer {
  int id;
  String firstName;
  String lastName;
  String email;
  String? userType;
  String userFrom;
  int isActive;
  String? image;
  int isPhoneVerified;
  String? emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;
  String? emailVerificationToken;
  String? countryCode;
  String phone;
  String cmFirebaseToken;
  int point;
  String? temporaryToken;
  String? loginMedium;
  String walletBalance;
  String? referCode;
  String? referBy;
  int loginHitCount;
  int isTempBlocked;
  String? tempBlockTime;
  String languageCode;
  int status;
  int ordersCount;

  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.userType,
    required this.userFrom,
    required this.isActive,
    this.image,
    required this.isPhoneVerified,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    this.emailVerificationToken,
    this.countryCode,
    required this.phone,
    required this.cmFirebaseToken,
    required this.point,
    this.temporaryToken,
    this.loginMedium,
    required this.walletBalance,
    this.referCode,
    this.referBy,
    required this.loginHitCount,
    required this.isTempBlocked,
    this.tempBlockTime,
    required this.languageCode,
    required this.status,
    required this.ordersCount,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      firstName: json['f_name'],
      lastName: json['l_name'],
      email: json['email'],
      userType: json['user_type'],
      userFrom: json['user_from'],
      isActive: json['is_active'],
      image: json['image'],
      isPhoneVerified: json['is_phone_verified'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      emailVerificationToken: json['email_verification_token'],
      countryCode: json['country_code'],
      phone: json['phone'],
      cmFirebaseToken: json['cm_firebase_token'],
      point: json['point'],
      temporaryToken: json['temporary_token'],
      loginMedium: json['login_medium'],
      walletBalance: json['wallet_balance'],
      referCode: json['refer_code'],
      referBy: json['refer_by'],
      loginHitCount: json['login_hit_count'],
      isTempBlocked: json['is_temp_blocked'],
      tempBlockTime: json['temp_block_time'],
      languageCode: json['language_code'],
      status: json['status'],
      ordersCount: json['orders_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'f_name': firstName,
      'l_name': lastName,
      'email': email,
      'user_type': userType,
      'user_from': userFrom,
      'is_active': isActive,
      'image': image,
      'is_phone_verified': isPhoneVerified,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'email_verification_token': emailVerificationToken,
      'country_code': countryCode,
      'phone': phone,
      'cm_firebase_token': cmFirebaseToken,
      'point': point,
      'temporary_token': temporaryToken,
      'login_medium': loginMedium,
      'wallet_balance': walletBalance,
      'refer_code': referCode,
      'refer_by': referBy,
      'login_hit_count': loginHitCount,
      'is_temp_blocked': isTempBlocked,
      'temp_block_time': tempBlockTime,
      'language_code': languageCode,
      'status': status,
      'orders_count': ordersCount,
    };
  }
}
