part of 'data_bloc.dart';

@immutable
abstract class DataEvent {}

class LoadUserEvent extends DataEvent {}

class CreateCategory extends DataEvent {
  final String name;

  CreateCategory({required this.name});
}

class CreateSubcategory extends DataEvent {
  final String categoryId;
  final String name;

  CreateSubcategory({required this.categoryId, required this.name});
}

class CreateEntry extends DataEvent {
  final String id;
  final String category;
  final String subcategory;
  final String value;
  final DateTime date;

  CreateEntry(
      {required this.id,
      required this.category,
      required this.subcategory,
      required this.value,
      required this.date});
}

class AddEntry extends DataEvent {
  final String id;
  final String categoryId;
  final String subcategoryId;
  final String value;
  final DateTime date;

  AddEntry(
      {required this.id,
      required this.categoryId,
      required this.subcategoryId,
      required this.value,
      required this.date});
}

class DeleteCategory extends DataEvent {
  final Category category;

  DeleteCategory({required this.category});
}

class DeleteSubcategory extends DataEvent {
  final Subcategory subcategory;

  DeleteSubcategory({required this.subcategory});
}

class DeleteEntry extends DataEvent {
  final Entry entry;

  DeleteEntry({required this.entry});
}

class UpdateEntry extends DataEvent {
  final String id;
  final String categoryId;
  final String subcategoryId;
  final String value;
  final DateTime date;

  UpdateEntry(
      {required this.id,
      required this.categoryId,
      required this.subcategoryId,
      required this.value,
      required this.date});
}

class LoadCategories extends DataEvent {}

class LoadSubcategories extends DataEvent {
  final String category;
  final String categoryId;

  LoadSubcategories({required this.category, required this.categoryId});
}

class LoadEntries extends DataEvent {
  final String category;
  final String categoryId;
  final String subcategory;
  final String subcategoryId;

  LoadEntries(
      {required this.category,
      required this.categoryId,
      required this.subcategory,
      required this.subcategoryId});
}

class LoadAllEntries extends DataEvent {}
