part of 'data_bloc.dart';

@immutable
class DataEvent {}

class LoadUserEvent extends DataEvent {}

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

class GoToCategoriesPage extends DataEvent {
  final List<Category> data;

  GoToCategoriesPage({required this.data});
}

class LoadSubcategories extends DataEvent {
  final String categoryId;

  LoadSubcategories({required this.categoryId});
}

class GoToSubCategoriesPage extends DataEvent {
  final List<Entry> data;
  final String categoryId;

  GoToSubCategoriesPage({required this.data, required this.categoryId});
}

class LoadEntries extends DataEvent {
  final String categoryId;
  final String subcategoryId;

  LoadEntries({required this.categoryId, required this.subcategoryId});
}

class GoToEntriesPage extends DataEvent {
  final List<Entry> data;
  final String categoryId;
  final String subcategoryId;

  GoToEntriesPage(
      {required this.data,
      required this.categoryId,
      required this.subcategoryId});
}
