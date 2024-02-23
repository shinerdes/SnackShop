class Order {
  const Order({
    required this.orderName,
    required this.orderAddress,
    required this.phoneNumber,
    required this.orderMemo,
    required this.cost,
  });

  final String orderName;
  final String orderAddress;
  final String phoneNumber;
  final String orderMemo;
  final int cost;

  factory Order.fromJson(Map<dynamic, dynamic> json) {
    return Order(
      orderName: json['orderName'],
      orderAddress: json['orderAddress'],
      phoneNumber: json['phoneNumber'],
      orderMemo: json['orderMemo'],
      cost: json['cost'],
    );
  }
}
