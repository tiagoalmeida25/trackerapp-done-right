import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trackerapp/models/entry.dart';

class FirestoreService {
  final User user;

  FirestoreService({required this.user});

  CollectionReference get _usersCollectionReference =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('data');

  Stream<List<Entry>> getAllData() {
    return _usersCollectionReference.snapshots().map((snapshot) {
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
    await _usersCollectionReference.add({
      'id': id,
      'category': category,
      'subcategory': subcategory,
      'value': value,
      'date': date,
    });
  }

  Future<void> deleteData(String id) async {
    QuerySnapshot querySnapshot =
        await _usersCollectionReference.where('id', isEqualTo: id).get();
    for (var doc in querySnapshot.docs) {
      doc.reference.delete();
    }
  }

  Future<void> updateData(String id, String category, String subcategory,
      String value, DateTime date) async {
    QuerySnapshot querySnapshot =
        await _usersCollectionReference.where('id', isEqualTo: id).get();
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
}
