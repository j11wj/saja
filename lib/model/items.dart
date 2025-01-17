
class Items {
  String id;
  String name;
  String price;
  String description;
  String image;
  List suggestions;
  String category;
  Items({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.suggestions,
    required this.category,
  });
  // Factory method to create a Items object from Firestore data
  factory Items.fromFirestore(String id, Map<String, dynamic> data) {
    return Items(
      id: id,
      name: data['name'] ?? '',
      price: data['price'] ?? '',
      description: data['discription'] ?? '',
      image: data['image'] ?? '',
      suggestions: data['suggestions'] ?? '',
      category: data['category'] ?? '',
    );
  }
}