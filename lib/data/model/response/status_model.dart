class OrderSummary {
  int allOrders;
  int completedOrders;
  int pendingOrders;

  // Constructor
  OrderSummary({
    required this.allOrders,
    required this.completedOrders,
    required this.pendingOrders,
  });

  // Factory method to create an instance from a JSON map
  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    return OrderSummary(
      allOrders: json['all_orders'],
      completedOrders: json['completed_orders'],
      pendingOrders: json['pending_orders'],
    );
  }

  // Method to convert the instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'all_orders': allOrders,
      'completed_orders': completedOrders,
      'pending_orders': pendingOrders,
    };
  }
}
