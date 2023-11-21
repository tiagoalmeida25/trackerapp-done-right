import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trackerapp/models/entry.dart';

class FirestoreService {
  final User user;

  FirestoreService({required this.user});

  CollectionReference get _dataCollectionReference => FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('data');

  CollectionReference get _categoriesCollectionReference =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('categories');

  CollectionReference get _subcategoriesCollectionReference =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('subcategories');

  Stream<List<Entry>> getAllData() {
    return _dataCollectionReference.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return Entry(
          id: data['id'],
          category: data['category'],
          subcategory: data['subcategory'],
          value: data['value'],
          date: data['date'].toDate(),
        );
      }).toList();
    });
  }

  Future<void> addData(String id, String category, String subcategory,
      String value, DateTime date) async {
    await _dataCollectionReference.add({
      'id': id,
      'category': category,
      'subcategory': subcategory,
      'value': value,
      'date': date,
    });

    // QuerySnapshot querySnapshot = await _categoriesCollectionReference
    //     .where('category', isEqualTo: category)
    //     .get();

    // if (querySnapshot.docs.isEmpty) {
    //   await _categoriesCollectionReference.add({
    //     'category': category,
    //     'category_id': Timestamp.now().toString(),
    //   });
  }

  Future<void> deleteData(String id) async {
    QuerySnapshot querySnapshot =
        await _dataCollectionReference.where('id', isEqualTo: id).get();
    for (var doc in querySnapshot.docs) {
      doc.reference.delete();
    }
  }

  Future<void> updateData(String id, String category, String subcategory,
      String value, DateTime date) async {
    QuerySnapshot querySnapshot =
        await _dataCollectionReference.where('id', isEqualTo: id).get();
    for (var doc in querySnapshot.docs) {
      doc.reference.update({
        'category': category,
        'subcategory': subcategory,
        'value': value,
        'date': date,
      });
    }
  }

  List<String> getCategories(List<Entry> data) {
    return data.map((entry) => entry.category).toSet().toList();
  }

  List<String> getSubCategories(List<Entry> data, String category) {
    return data
        .where((entry) => entry.category == category)
        .map((entry) => entry.subcategory)
        .toSet()
        .toList();
  }

  List<Entry> getEntries(
      List<Entry> data, String category, String subcategory) {
    return data
        .where((entry) =>
            entry.category == category && entry.subcategory == subcategory)
        .toList();
  }

  // Future<void> addCategory(String category) async {
  //   await _dataCollectionReference.add({
  //     'id': category,
  //     'category': category,
  //     'subcategory': '',
  //     'value': '',
  //     'date': DateTime.now(),
  //   });
  // }
}
