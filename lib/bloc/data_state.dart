part of 'data_bloc.dart';

@immutable
abstract class DataState {}

class DataInitial extends DataState {}

class DataLoading extends DataState {}

class DataLoaded extends DataState {
  final List<Entry> data;

  DataLoaded({required this.data});
}

class CategoriesLoaded extends DataState {
  final List<String> categories;
  final List<Entry> data;

  CategoriesLoaded({required this.categories, required this.data});
}

class SubCategoriesLoaded extends DataState {
  final List<String> subcategories;
  final String category;
  final List<Entry> data;

  SubCategoriesLoaded(
      {required this.subcategories,
      required this.category,
      required this.data});
}

class EntriesLoaded extends DataState {
  final List<Entry> entries;
  final List<Entry> data;
  final String category;
  final String subcategory;

  EntriesLoaded({required this.entries, required this.data, required this.category, required this.subcategory});
}

class DataError extends DataState {
  final String message;

  DataError({required this.message});
}

class DataOperationSuccess extends DataState {
  final String message;

  DataOperationSuccess({required this.message});
}
