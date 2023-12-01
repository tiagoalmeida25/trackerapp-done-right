abstract class Data {}

class Category extends Data {
  String category;
  String categoryId;
  DateTime createdAt;
  DateTime updatedAt;

  Category(
      {required this.category, required this.categoryId, required this.createdAt, required this.updatedAt});
}

class Subcategory extends Data {
  String subcategory;
  String categoryId;
  String subcategoryId;
  DateTime createdAt;
  DateTime updatedAt;

  Subcategory(
      {required this.subcategory,
      required this.categoryId,
      required this.subcategoryId,
      required this.createdAt,
      required this.updatedAt});
}

class Entry extends Data {
  String id;
  String category;
  String subcategory;
  String value;
  DateTime date;

  Entry(
      {required this.id,
      required this.category,
      required this.subcategory,
      required this.value,
      required this.date});
}
