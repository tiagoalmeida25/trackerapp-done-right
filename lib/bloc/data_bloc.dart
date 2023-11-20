import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trackerapp/models/entry.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc() : super(DataInitial()) {
    on<DataEvent>((event, emit) async {
      if (event is LoadUserEvent) {
        emit(DataState(isLoading: true));

        final User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          emit(DataState(user: user, isLoading: false, dataLoaded: false));
        } else {
          emit(DataState(isLoading: false, dataLoaded: false));
        }
      } else if (event is GetAllDataEvent) {
        emit(DataState(isLoading: true));

        final QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .doc(state.user!.uid)
                .collection('data')
                .get();

        final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
            querySnapshot.docs;

        final List<Entry> data = docs.map((doc) {
          final docsData = doc.data();
          return Entry(
            id: doc.id,
            date: DateTime.parse(docsData['date']),
            value: docsData['value'],
            category: docsData['category'],
            subcategory: docsData['subcategory'],
          );
        }).toList();

        emit(DataState(
            isLoading: false, dataLoaded: true, data: data, user: state.user));
      } else if (event is AddDataEvent) {
        emit(DataState(isLoading: true));

        final CollectionReference<Map<String, dynamic>> dataCollection =
            FirebaseFirestore.instance.doc(state.user!.uid).collection('data');

        await dataCollection.add({
          'date': event.entry.date.toString(),
          'value': event.entry.value,
          'category': event.entry.category,
          'subcategory': event.entry.subcategory,
        });

        emit(DataState(isLoading: false, dataLoaded: false, user: state.user));
      } else if (event is DeleteDataEvent) {
        emit(DataState(isLoading: true));

        final CollectionReference<Map<String, dynamic>> dataCollection =
            FirebaseFirestore.instance.doc(state.user!.uid).collection('data');

        await dataCollection.doc(event.entry.id).delete();

        final querySnapshot = await dataCollection.get();

        final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
            querySnapshot.docs;

        final List<Entry> data = docs.map((doc) {
          final docsData = doc.data();
          return Entry(
            id: doc.id,
            date: DateTime.parse(docsData['date']),
            value: docsData['value'],
            category: docsData['category'],
            subcategory: docsData['subcategory'],
          );
        }).toList();

        emit(DataState(isLoading: false, user: state.user, data: data));
      } else if (event is UpdateDataEvent) {
        emit(DataState(isLoading: true));

        final CollectionReference<Map<String, dynamic>> dataCollection =
            FirebaseFirestore.instance.doc(state.user!.uid).collection('data');

        await dataCollection.doc(event.entry.id).update({
          'date': event.entry.date.toString(),
          'value': event.entry.value,
          'category': event.entry.category,
          'subcategory': event.entry.subcategory,
        });

        final querySnapshot = await dataCollection.get();

        final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
            querySnapshot.docs;

        final List<Entry> data = docs.map((doc) {
          final docsData = doc.data();
          return Entry(
            id: doc.id,
            date: DateTime.parse(docsData['date']),
            value: docsData['value'],
            category: docsData['category'],
            subcategory: docsData['subcategory'],
          );
        }).toList();

        emit(DataState(isLoading: false, user: state.user, data: data));
      } else if (event is GetCategoriesEvent) {
        state.categoryData = [];
        for (Entry e in state.data!) {
          if (!state.categoryData!.contains(e)) {
            state.categoryData!.add(e);
          }
        }

        emit(DataState(isLoading: false, categoryData: state.categoryData));
      } else if (event is GetSubCategoriesEvent) {
        state.categoryData = [];
        for (Entry e in state.data!) {
          if (e.category == event.category) {
            state.categoryData!.add(e);
          }
        }

        emit(DataState(isLoading: false, categoryData: state.categoryData));
      } else if (event is GetEntriesByCategoryEvent) {
        state.categoryData = [];
        for (Entry e in state.data!) {
          if (e.category == event.category &&
              e.subcategory == event.subcategory) {
            state.categoryData!.add(e);
          }
        }

        emit(DataState(isLoading: false, categoryData: state.categoryData));
      }
      else if(event is GoToSubCategoryPageEvent){
        emit(DataState(isLoading: false, currentPage: 'subcategories'));
      }
      else if(event is GoToEntryPageEvent){
        emit(DataState(isLoading: false, currentPage: 'entries'));
      }
    });
  }
}
