part of 'data_bloc.dart';

@immutable
class DataEvent {}

class LoadUserEvent extends DataEvent {}

class LoadData extends DataEvent {}

class AddEntry extends DataEvent {
  final String id;
  final String category;
  final String subcategory;
  final String value;
  final DateTime date;

  AddEntry(
      {required this.id,
      required this.category,
      required this.subcategory,
      required this.value,
      required this.date});
}

class DeleteEntry extends DataEvent {
  final Entry entry;

  DeleteEntry({required this.entry});
}

class UpdateEntry extends DataEvent {
  final String id;
  final String category;
  final String subcategory;
  final String value;
  final DateTime date;

  UpdateEntry(
      {required this.id,
      required this.category,
      required this.subcategory,
      required this.value,
      required this.date});
}

class GoToCategoriesPage extends DataEvent {
  final List<Entry> data;

  GoToCategoriesPage({required this.data});
}

class GetSubCategories extends DataEvent {
  final List<Entry> data;
  final String category;

  GetSubCategories({required this.data, required this.category});
}

class GetEntries extends DataEvent {
  final List<Entry> data;
  final String category;
  final String subcategory;

  GetEntries(
      {required this.data, required this.category, required this.subcategory});
}

class GoToSubCategoryPage extends DataEvent {
  final List<Entry> data;
  final String category;

  GoToSubCategoryPage({required this.data, required this.category});
}

class GoToEntryPage extends DataEvent {
  final List<Entry> data;
  final String category;
  final String subcategory;

  GoToEntryPage(
      {required this.data, required this.category, required this.subcategory});
}
