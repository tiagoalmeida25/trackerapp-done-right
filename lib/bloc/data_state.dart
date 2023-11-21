part of 'data_bloc.dart';

@immutable
abstract class DataState {}

class DataInitial extends DataState {}

class DataLoading extends DataState {}

class CategoriesLoaded extends DataState {
  final List<Category> categories;

  CategoriesLoaded({required this.categories});
}

class SubcategoriesLoaded extends DataState {
  final List<Subcategory> subcategories;
  final String category;

  SubcategoriesLoaded({required this.subcategories, required this.category});
}

class EntriesLoaded extends DataState {
  final List<Entry> entries;
  final String category;
  final String subcategory;

  EntriesLoaded(
      {required this.entries,
      required this.category,
      required this.subcategory});
}

class DataError extends DataState {
  final String message;

  DataError({required this.message});
}

class DataOperationSuccess extends DataState {
  final String message;

  DataOperationSuccess({required this.message});
}
