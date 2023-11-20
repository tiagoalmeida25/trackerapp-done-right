part of 'data_bloc.dart';

@immutable
class DataEvent {}

class LoadUserEvent extends DataEvent {}

class GetAllDataEvent extends DataEvent {}

class AddDataEvent extends DataEvent {
  final Entry entry;

  AddDataEvent({required this.entry});
}

class DeleteDataEvent extends DataEvent {
  final Entry entry;

  DeleteDataEvent({required this.entry});
}

class UpdateDataEvent extends DataEvent {
  final Entry entry;

  UpdateDataEvent({required this.entry});
}

class GetCategoriesEvent extends DataEvent {}

class GetSubCategoriesEvent extends DataEvent {
  final String category;

  GetSubCategoriesEvent({required this.category});
}

class GetEntriesByCategoryEvent extends DataEvent {
  final String category;
  final String subcategory;

  GetEntriesByCategoryEvent(
      {required this.category, required this.subcategory});
}

class GoToSubCategoryPageEvent extends DataEvent {
  final String category;

  GoToSubCategoryPageEvent({required this.category});
}

class GoToEntryPageEvent extends DataEvent {
  final String category;
  final String subcategory;

  GoToEntryPageEvent({required this.category, required this.subcategory});
}
