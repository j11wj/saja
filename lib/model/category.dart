
class Category {
  String id;
  String name;

  Category({required this.id, required this.name});

  // Factory method to create a Category object from Firestore data
  factory Category.fromFirestore(String id, Map<String, dynamic> data) {
    return Category(
      id: id,
      name: data['name'] ?? '',
    );
  }
}
