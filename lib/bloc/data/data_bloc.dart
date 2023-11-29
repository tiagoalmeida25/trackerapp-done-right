import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:trackerapp/models/entry.dart';
import 'package:trackerapp/models/category.dart';
import 'package:trackerapp/models/subcategory.dart';
import 'package:trackerapp/service/firestore_service.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  final FirestoreService firestoreService;

  DataBloc(this.firestoreService) : super(DataInitial()) {
    on<LoadCategories>(((event, emit) async {
      try {
        emit(DataLoading());
        final data = await firestoreService.getCategories().first;
        emit(CategoriesLoaded(categories: data));
      } catch (e) {
        emit(DataError(message: e.toString()));
      }
    }));

    on<LoadSubcategories>(((event, emit) async {
      try {
        final data = await firestoreService.getSubcategories(event.categoryId).first;
        emit(
            SubcategoriesLoaded(subcategories: data, category: event.category, categoryId: event.categoryId));
      } catch (e) {
        emit(DataError(message: e.toString()));
      }
    }));

    on<LoadEntries>(((event, emit) async {
      try {
        final data = await firestoreService.getEntries(event.categoryId, event.subcategoryId).first;
        emit(EntriesLoaded(
          entries: data,
          category: event.category,
          subcategory: event.subcategory,
          categoryId: event.categoryId,
          subcategoryId: event.subcategoryId,
        ));
      } catch (e) {
        emit(DataError(message: e.toString()));
      }
    }));

    // when entering all fields
    on<CreateEntry>((event, emit) async {
      try {
        await firestoreService.createEntry(
          event.category,
          event.subcategory,
          event.value,
          event.date,
        );
        emit(DataOperationSuccess(message: 'Entry added'));
      } catch (e) {
        emit(DataError(message: e.toString()));
      }
    });

    // for adding when pressing on category -> subcategory
    on<AddEntry>((event, emit) async {
      try {
        emit(DataLoading());
        await firestoreService.addEntry(
          event.categoryId,
          event.subcategoryId,
          event.value,
          event.date,
        );
        emit(DataOperationSuccess(message: 'Entry added'));
      } catch (e) {
        emit(DataError(message: e.toString()));
      }
    });

    on<DeleteEntry>((event, emit) async {
      try {
        emit(DataLoading());
        await firestoreService.deleteData(event.entry.id);
        emit(DataOperationSuccess(message: 'Entry deleted'));
      } catch (e) {
        emit(DataError(message: e.toString()));
      }
    });

    on<UpdateEntry>((event, emit) async {
      try {
        emit(DataLoading());
        await firestoreService.updateData(
          event.id,
          event.categoryId,
          event.subcategoryId,
          event.value,
          event.date,
        );
        emit(DataOperationSuccess(message: 'Entry updated'));
      } catch (e) {
        emit(DataError(message: e.toString()));
      }
    });

    add(LoadCategories());
  }
}
