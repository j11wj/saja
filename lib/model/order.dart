
class Orders {
  String id;
  String name;
  String diveceId;
  String price;
  String phone;
  String address;
  String nameOfUser;
  String date;
  Orders({
    required this.id,
    required this.name,
    required this.diveceId,
    required this.price,
    required this.phone,
    required this.address,
    required this.nameOfUser,
    required this.date,
  });
  // Factory method to create a Order object from Firestore data
  factory Orders.fromFirestore(String id, Map<String, dynamic> data) {
    return Orders(
      id: id,
      name: data['nameOfProdect'] ?? '',
      diveceId: data['deviceId'] ?? '',
      price: data['price'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      nameOfUser: data['nameOfUser'] ?? '',
      date: data['date'] ?? '',
    );
  }
}
