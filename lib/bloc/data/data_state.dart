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
  final String categoryId;

  SubcategoriesLoaded({required this.subcategories, required this.category, required this.categoryId});
}

class EntriesLoaded extends DataState {
  final List<Entry> entries;
  final String category;
  final String categoryId;
  final String subcategory;
  final String subcategoryId;

  EntriesLoaded(
      {required this.entries,
      required this.category,
      required this.categoryId,
      required this.subcategory,
      required this.subcategoryId});
}

class DataError extends DataState {
  final String message;

  DataError({required this.message});
}

class DataOperationSuccess extends DataState {
  final dynamic previousState;
  final String message;

  DataOperationSuccess({required this.previousState, required this.message});
}
