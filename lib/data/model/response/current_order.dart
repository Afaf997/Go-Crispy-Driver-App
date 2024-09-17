class CurrentOrder {
  final int id;
  final int userId;
  final bool isGuest;
  final double orderAmount;
  final double couponDiscountAmount;
  final String? couponDiscountTitle;
  final String paymentStatus;
  final String orderStatus;
  final double totalTaxAmount;
  final String paymentMethod;
  final String? transactionReference;
  final int deliveryAddressId;
  final String createdAt;
  final String updatedAt;
  final bool checked;
  final int deliveryManId;
  final double deliveryCharge;
  final String? orderNote;
  final String? couponCode;
  final String orderType;
  final String? carPlateno;
  final int branchId;
  final String? callback;
  final String deliveryDate;
  final String deliveryTime;
  final String extraDiscount;
  final String? deliveryAddress;
  final int preparationTime;
  final int? tableId;
  final int? numberOfPeople;
  final int? tableOrderId;
  final String orderFrom;
  final dynamic customer; // You can create a separate model if needed
  final List<dynamic> orderPartialPayments; // You can create a model for partial payments

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
    this.carPlateno,
    required this.branchId,
    this.callback,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.extraDiscount,
    this.deliveryAddress,
    required this.preparationTime,
    this.tableId,
    this.numberOfPeople,
    this.tableOrderId,
    required this.orderFrom,
    this.customer,
    required this.orderPartialPayments,
  });

  factory CurrentOrder.fromJson(Map<String, dynamic> json) {
    return CurrentOrder(
      id: json['id'],
      userId: json['user_id'],
      isGuest: json['is_guest'] == 1,
      orderAmount: (json['order_amount'] as num).toDouble(),
      couponDiscountAmount: (json['coupon_discount_amount'] as num).toDouble(),
      couponDiscountTitle: json['coupon_discount_title'],
      paymentStatus: json['payment_status'],
      orderStatus: json['order_status'],
      totalTaxAmount: (json['total_tax_amount'] as num).toDouble(),
      paymentMethod: json['payment_method'],
      transactionReference: json['transaction_reference'],
      deliveryAddressId: json['delivery_address_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      checked: json['checked'] == 1,
      deliveryManId: json['delivery_man_id'],
      deliveryCharge: (json['delivery_charge'] as num).toDouble(),
      orderNote: json['order_note'],
      couponCode: json['coupon_code'],
      orderType: json['order_type'],
      carPlateno: json['car_plateno'],
      branchId: json['branch_id'],
      callback: json['callback'],
      deliveryDate: json['delivery_date'],
      deliveryTime: json['delivery_time'],
      extraDiscount: json['extra_discount'],
      deliveryAddress: json['delivery_address'],
      preparationTime: json['preparation_time'],
      tableId: json['table_id'],
      numberOfPeople: json['number_of_people'],
      tableOrderId: json['table_order_id'],
      orderFrom: json['order_from'],
      customer: json['customer'],
      orderPartialPayments: json['order_partial_payments'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'is_guest': isGuest ? 1 : 0,
      'order_amount': orderAmount,
      'coupon_discount_amount': couponDiscountAmount,
      'coupon_discount_title': couponDiscountTitle,
      'payment_status': paymentStatus,
      'order_status': orderStatus,
      'total_tax_amount': totalTaxAmount,
      'payment_method': paymentMethod,
      'transaction_reference': transactionReference,
      'delivery_address_id': deliveryAddressId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'checked': checked ? 1 : 0,
      'delivery_man_id': deliveryManId,
      'delivery_charge': deliveryCharge,
      'order_note': orderNote,
      'coupon_code': couponCode,
      'order_type': orderType,
      'car_plateno': carPlateno,
      'branch_id': branchId,
      'callback': callback,
      'delivery_date': deliveryDate,
      'delivery_time': deliveryTime,
      'extra_discount': extraDiscount,
      'delivery_address': deliveryAddress,
      'preparation_time': preparationTime,
      'table_id': tableId,
      'number_of_people': numberOfPeople,
      'table_order_id': tableOrderId,
      'order_from': orderFrom,
      'customer': customer,
      'order_partial_payments': orderPartialPayments,
    };
  }
}
