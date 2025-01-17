
class Basket {
  String id;
  String name;
  String price;
  Basket({
    required this.id,
    required this.name,
    required this.price,
  });
  // Factory method to create a Basket object from Firestore data
  factory Basket.fromFirestore(String id, Map<String, dynamic> data) {
    return Basket(
      id: id,
      name: data['name'] ?? '',
      price: data['price'] ?? '',
    );
  }
}

