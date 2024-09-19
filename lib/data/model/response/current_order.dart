// To parse this JSON data, do
//
//     final currentOrders = currentOrdersFromJson(jsonString);

import 'dart:convert';

List<CurrentOrders> currentOrdersFromJson(String str) => List<CurrentOrders>.from(json.decode(str).map((x) => CurrentOrders.fromJson(x)));

String currentOrdersToJson(List<CurrentOrders> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CurrentOrders {
    int id;
    int userId;
    int isGuest;
    int orderAmount;
    int couponDiscountAmount;
    dynamic couponDiscountTitle;
    String paymentStatus;
    String orderStatus;
    int totalTaxAmount;
    String paymentMethod;
    dynamic transactionReference;
    int deliveryAddressId;
    DateTime createdAt;
    DateTime updatedAt;
    int checked;
    int deliveryManId;
    int deliveryCharge;
    dynamic orderNote;
    dynamic couponCode;
    String orderType;
    dynamic carPlateno;
    int branchId;
    dynamic callback;
    DateTime deliveryDate;
    String deliveryTime;
    String extraDiscount;
    DeliveryAddress deliveryAddress;
    int preparationTime;
    dynamic tableId;
    dynamic numberOfPeople;
    dynamic tableOrderId;
    String orderFrom;
    Customer customer;
    List<dynamic> orderPartialPayments;

    CurrentOrders({
        required this.id,
        required this.userId,
        required this.isGuest,
        required this.orderAmount,
        required this.couponDiscountAmount,
        required this.couponDiscountTitle,
        required this.paymentStatus,
        required this.orderStatus,
        required this.totalTaxAmount,
        required this.paymentMethod,
        required this.transactionReference,
        required this.deliveryAddressId,
        required this.createdAt,
        required this.updatedAt,
        required this.checked,
        required this.deliveryManId,
        required this.deliveryCharge,
        required this.orderNote,
        required this.couponCode,
        required this.orderType,
        required this.carPlateno,
        required this.branchId,
        required this.callback,
        required this.deliveryDate,
        required this.deliveryTime,
        required this.extraDiscount,
        required this.deliveryAddress,
        required this.preparationTime,
        required this.tableId,
        required this.numberOfPeople,
        required this.tableOrderId,
        required this.orderFrom,
        required this.customer,
        required this.orderPartialPayments,
    });

    factory CurrentOrders.fromJson(Map<String, dynamic> json) => CurrentOrders(
        id: json["id"],
        userId: json["user_id"],
        isGuest: json["is_guest"],
        orderAmount: json["order_amount"],
        couponDiscountAmount: json["coupon_discount_amount"],
        couponDiscountTitle: json["coupon_discount_title"],
        paymentStatus: json["payment_status"],
        orderStatus: json["order_status"],
        totalTaxAmount: json["total_tax_amount"],
        paymentMethod: json["payment_method"],
        transactionReference: json["transaction_reference"],
        deliveryAddressId: json["delivery_address_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        checked: json["checked"],
        deliveryManId: json["delivery_man_id"],
        deliveryCharge: json["delivery_charge"],
        orderNote: json["order_note"],
        couponCode: json["coupon_code"],
        orderType: json["order_type"],
        carPlateno: json["car_plateno"],
        branchId: json["branch_id"],
        callback: json["callback"],
        deliveryDate: DateTime.parse(json["delivery_date"]),
        deliveryTime: json["delivery_time"],
        extraDiscount: json["extra_discount"],
        deliveryAddress: DeliveryAddress.fromJson(json["delivery_address"]),
        preparationTime: json["preparation_time"],
        tableId: json["table_id"],
        numberOfPeople: json["number_of_people"],
        tableOrderId: json["table_order_id"],
        orderFrom: json["order_from"],
        customer: Customer.fromJson(json["customer"]),
        orderPartialPayments: List<dynamic>.from(json["order_partial_payments"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "is_guest": isGuest,
        "order_amount": orderAmount,
        "coupon_discount_amount": couponDiscountAmount,
        "coupon_discount_title": couponDiscountTitle,
        "payment_status": paymentStatus,
        "order_status": orderStatus,
        "total_tax_amount": totalTaxAmount,
        "payment_method": paymentMethod,
        "transaction_reference": transactionReference,
        "delivery_address_id": deliveryAddressId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "checked": checked,
        "delivery_man_id": deliveryManId,
        "delivery_charge": deliveryCharge,
        "order_note": orderNote,
        "coupon_code": couponCode,
        "order_type": orderType,
        "car_plateno": carPlateno,
        "branch_id": branchId,
        "callback": callback,
        "delivery_date": "${deliveryDate.year.toString().padLeft(4, '0')}-${deliveryDate.month.toString().padLeft(2, '0')}-${deliveryDate.day.toString().padLeft(2, '0')}",
        "delivery_time": deliveryTime,
        "extra_discount": extraDiscount,
        "delivery_address": deliveryAddress.toJson(),
        "preparation_time": preparationTime,
        "table_id": tableId,
        "number_of_people": numberOfPeople,
        "table_order_id": tableOrderId,
        "order_from": orderFrom,
        "customer": customer.toJson(),
        "order_partial_payments": List<dynamic>.from(orderPartialPayments.map((x) => x)),
    };
}

class Customer {
    int id;
    String fName;
    String lName;
    String email;
    dynamic userType;
    String userFrom;
    int isActive;
    dynamic image;
    int isPhoneVerified;
    dynamic emailVerifiedAt;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic emailVerificationToken;
    dynamic countryCode;
    String phone;
    String cmFirebaseToken;
    int point;
    dynamic temporaryToken;
    dynamic loginMedium;
    String walletBalance;
    dynamic referCode;
    dynamic referBy;
    int loginHitCount;
    int isTempBlocked;
    dynamic tempBlockTime;
    String languageCode;
    int status;
    int ordersCount;

    Customer({
        required this.id,
        required this.fName,
        required this.lName,
        required this.email,
        required this.userType,
        required this.userFrom,
        required this.isActive,
        required this.image,
        required this.isPhoneVerified,
        required this.emailVerifiedAt,
        required this.createdAt,
        required this.updatedAt,
        required this.emailVerificationToken,
        required this.countryCode,
        required this.phone,
        required this.cmFirebaseToken,
        required this.point,
        required this.temporaryToken,
        required this.loginMedium,
        required this.walletBalance,
        required this.referCode,
        required this.referBy,
        required this.loginHitCount,
        required this.isTempBlocked,
        required this.tempBlockTime,
        required this.languageCode,
        required this.status,
        required this.ordersCount,
    });

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        fName: json["f_name"],
        lName: json["l_name"],
        email: json["email"],
        userType: json["user_type"],
        userFrom: json["user_from"],
        isActive: json["is_active"],
        image: json["image"],
        isPhoneVerified: json["is_phone_verified"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        emailVerificationToken: json["email_verification_token"],
        countryCode: json["country_code"],
        phone: json["phone"],
        cmFirebaseToken: json["cm_firebase_token"],
        point: json["point"],
        temporaryToken: json["temporary_token"],
        loginMedium: json["login_medium"],
        walletBalance: json["wallet_balance"],
        referCode: json["refer_code"],
        referBy: json["refer_by"],
        loginHitCount: json["login_hit_count"],
        isTempBlocked: json["is_temp_blocked"],
        tempBlockTime: json["temp_block_time"],
        languageCode: json["language_code"],
        status: json["status"],
        ordersCount: json["orders_count"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "f_name": fName,
        "l_name": lName,
        "email": email,
        "user_type": userType,
        "user_from": userFrom,
        "is_active": isActive,
        "image": image,
        "is_phone_verified": isPhoneVerified,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "email_verification_token": emailVerificationToken,
        "country_code": countryCode,
        "phone": phone,
        "cm_firebase_token": cmFirebaseToken,
        "point": point,
        "temporary_token": temporaryToken,
        "login_medium": loginMedium,
        "wallet_balance": walletBalance,
        "refer_code": referCode,
        "refer_by": referBy,
        "login_hit_count": loginHitCount,
        "is_temp_blocked": isTempBlocked,
        "temp_block_time": tempBlockTime,
        "language_code": languageCode,
        "status": status,
        "orders_count": ordersCount,
    };
}

class DeliveryAddress {
    int id;
    String addressType;
    String contactPersonNumber;
    dynamic floor;
    dynamic house;
    dynamic road;
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
        required this.floor,
        required this.house,
        required this.road,
        required this.address,
        required this.latitude,
        required this.longitude,
        required this.createdAt,
        required this.updatedAt,
        required this.userId,
        required this.isGuest,
        required this.contactPersonName,
    });

    factory DeliveryAddress.fromJson(Map<String, dynamic> json) => DeliveryAddress(
        id: json["id"],
        addressType: json["address_type"],
        contactPersonNumber: json["contact_person_number"],
        floor: json["floor"],
        house: json["house"],
        road: json["road"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        userId: json["user_id"],
        isGuest: json["is_guest"],
        contactPersonName: json["contact_person_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "address_type": addressType,
        "contact_person_number": contactPersonNumber,
        "floor": floor,
        "house": house,
        "road": road,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user_id": userId,
        "is_guest": isGuest,
        "contact_person_name": contactPersonName,
    };
}
