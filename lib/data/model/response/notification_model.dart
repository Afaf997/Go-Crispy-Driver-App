class NotificationModel {
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
  dynamic deliveryManId;
  double deliveryCharge;
  String? orderNote;
  String? couponCode;
  String orderType;
  dynamic carPlateNo;
  int branchId;
  dynamic callback;
  String deliveryDate;
  String deliveryTime;
  double extraDiscount;
  DeliveryAddress deliveryAddress;
  int preparationTime;
  dynamic tableId;
  dynamic numberOfPeople;
  dynamic tableOrderId;
  String orderFrom;

  NotificationModel({
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
    this.deliveryManId,
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
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['user_id'],
      isGuest: json['is_guest'],
      orderAmount: (json['order_amount'] as num).toDouble(),
      couponDiscountAmount: (json['coupon_discount_amount'] as num).toDouble(),
      couponDiscountTitle: json['coupon_discount_title'],
      paymentStatus: json['payment_status'],
      orderStatus: json['order_status'],
      totalTaxAmount: (json['total_tax_amount'] as num).toDouble(),
      paymentMethod: json['payment_method'],
      transactionReference: json['transaction_reference'],
      deliveryAddressId: json['delivery_address_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      checked: json['checked'],
      deliveryManId: json['delivery_man_id'],
      deliveryCharge: (json['delivery_charge'] as num).toDouble(),
      orderNote: json['order_note'],
      couponCode: json['coupon_code'],
      orderType: json['order_type'],
      carPlateNo: json['car_plateno'],
      branchId: json['branch_id'],
      callback: json['callback'],
      deliveryDate: json['delivery_date'],
      deliveryTime: json['delivery_time'],
      extraDiscount: (json['extra_discount'] as num).toDouble(),
      deliveryAddress: DeliveryAddress.fromJson(json['delivery_address']),
      preparationTime: json['preparation_time'],
      tableId: json['table_id'],
      numberOfPeople: json['number_of_people'],
      tableOrderId: json['table_order_id'],
      orderFrom: json['order_from'],
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
      'delivery_date': deliveryDate,
      'delivery_time': deliveryTime,
      'extra_discount': extraDiscount,
      'delivery_address': deliveryAddress.toJson(),
      'preparation_time': preparationTime,
      'table_id': tableId,
      'number_of_people': numberOfPeople,
      'table_order_id': tableOrderId,
      'order_from': orderFrom,
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
