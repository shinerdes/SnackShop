class Cart {
  const Cart({
    required this.count,
    required this.name,
    required this.price,
    required this.image,
  });

  final String name;
  final int price;
  final String image;
  final int count;

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "price": price,
      "image": image,
      "count": count,
    };
  }

  factory Cart.fromJson(Map<dynamic, dynamic> json) {
    return Cart(
      name: json['name'],
      price: json['price'],
      image: json['image'],
      count: json['count'],
    );
  }
}
