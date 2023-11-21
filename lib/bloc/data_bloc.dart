import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:trackerapp/models/entry.dart';
import 'package:trackerapp/service/firestore_service.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  final FirestoreService firestoreService;

  DataBloc(this.firestoreService) : super(DataInitial()) {
    on<LoadData>((event, emit) async {
      try {
        emit(DataLoading());
        final data = await firestoreService.getAllData().first;
        emit(DataLoaded(data: data));
      } catch (e) {
        emit(DataError(message: e.toString()));
      }
    });

    on<AddEntry>((event, emit) async {
      try {
        emit(DataLoading());
        await firestoreService.addData(
          event.id,
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
          event.category,
          event.subcategory,
          event.value,
          event.date,
        );
        emit(DataOperationSuccess(message: 'Entry updated'));
      } catch (e) {
        emit(DataError(message: e.toString()));
      }
    });

    on<GoToCategoriesPage>(
      (event, emit) {
        try {
          emit(DataLoading());
          final data = firestoreService.getCategories(event.data);
          emit(CategoriesLoaded(categories: data, data: event.data));
        } catch (e) {
          emit(DataError(message: e.toString()));
        }
      },
    );

    on<GoToSubCategoryPage>(
      (event, emit) {
        try {
          emit(DataLoading());
          final data =
              firestoreService.getSubCategories(event.data, event.category);
          emit(SubCategoriesLoaded(
              subcategories: data, data: event.data, category: event.category));
        } catch (e) {
          emit(DataError(message: e.toString()));
        }
      },
    );

    on<GoToEntryPage>(
      (event, emit) {
        try {
          emit(DataLoading());
          final data = firestoreService.getEntries(
              event.data, event.category, event.subcategory);
          data.sort((a, b) => b.date.compareTo(a.date));
          emit(EntriesLoaded(
            entries: data,
            data: event.data,
            category: event.category,
            subcategory: event.subcategory,
          ));
        } catch (e) {
          emit(DataError(message: e.toString()));
        }
      },
    );
  }
}
