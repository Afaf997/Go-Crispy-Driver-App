class OrderCountModel {
  final List<dynamic> allOrders;
  final List<dynamic> completedOrders;
  final List<dynamic> pendingOrders;

  OrderCountModel({
    required this.allOrders,
    required this.completedOrders,
    required this.pendingOrders,
  });

  factory OrderCountModel.fromJson(Map<String, dynamic> json) {
    return OrderCountModel(
      allOrders: json['all_orders'] ?? [],
      completedOrders: json['completed_orders'] ?? [],
      pendingOrders: json['pending_orders'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'all_orders': allOrders,
      'completed_orders': completedOrders,
      'pending_orders': pendingOrders,
    };
  }
}
