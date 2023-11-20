part of 'data_bloc.dart';

@immutable
class DataState {
  List<Entry>? data;
  List<Entry>? categoryData;
  bool? dataLoaded;
  bool? isLoading;
  User? user;
  String? currentPage;
  String? selectedCategory;
  String? selectedSubcategory;
  bool? firstLoad;

  DataState({
    this.dataLoaded = false,
    this.isLoading = false,
    this.data,
    this.user,
    this.categoryData,
    this.currentPage,
    this.selectedCategory,
    this.selectedSubcategory,
    this.firstLoad,
  });
}

class DataInitial extends DataState {
  DataInitial()
      : super(
            dataLoaded: false,
            isLoading: false,
            firstLoad: false,
            data: null,
            currentPage: 'categories');
}
