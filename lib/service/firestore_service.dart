import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trackerapp/models/entry.dart';
import 'package:trackerapp/models/category.dart';
import 'package:trackerapp/models/subcategory.dart';

class FirestoreService {
  final String id;

  FirestoreService({required this.id});

  CollectionReference get _entriesCollectionReference =>
      FirebaseFirestore.instance.collection('users').doc(id).collection('entries');

  CollectionReference get _categoriesCollectionReference =>
      FirebaseFirestore.instance.collection('users').doc(id).collection('categories');

  CollectionReference get _subcategoriesCollectionReference =>
      FirebaseFirestore.instance.collection('users').doc(id).collection('subcategories');

  Stream<List<Category>> getCategories() {
    return _categoriesCollectionReference.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return Category(
          categoryId: doc.id,
          category: data['category'],
          createdAt: data['created_at'].toDate(),
          updatedAt: data['updated_at'].toDate(),
        );
      }).toList();
    });
  }

  Stream<List<Subcategory>> getSubcategories(String categoryId) {
    final data = _subcategoriesCollectionReference.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data['category_id'] != categoryId) {
          return null;
        }
        return Subcategory(
          subcategory: data['subcategory'],
          categoryId: data['category_id'],
          subcategoryId: doc.id,
          createdAt: data['created_at'].toDate(),
          updatedAt: data['updated_at'].toDate(),
        );
      }).toList();
    });

    return data.map((event) {
      return event.where((element) => element != null).toList().cast<Subcategory>();
    });
  }

  Stream<List<Entry>> getEntries(String categoryId, String subcategoryId) {
    final data = _entriesCollectionReference.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data['category'] != categoryId || data['subcategory'] != subcategoryId) {
          return null;
        }

        return Entry(
          id: doc.id,
          category: data['category'],
          subcategory: data['subcategory'],
          value: data['value'],
          date: data['date'].toDate(),
        );
      }).toList();
    });

    return data.map((event) {
      return event.where((element) => element != null).toList().cast<Entry>();
    });
  }

  Stream<List<Entry>> getAllEntries() {
    return _entriesCollectionReference.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return Entry(
          id: doc.id,
          category: data['category'],
          subcategory: data['subcategory'],
          value: data['value'],
          date: data['date'].toDate(),
        );
      }).toList();
    });
  }

  Future<void> createEntry(String category, String subcategory, String value, DateTime date) async {
    String categoryId = '';
    String subcategoryId = '';

    final categoryQuery = await _categoriesCollectionReference.where('category', isEqualTo: category).get();

    if (categoryQuery.docs.isEmpty) {
      final categoryDoc = await _categoriesCollectionReference.add({
        'category': category.trim(),
        'category_id': _categoriesCollectionReference.doc().id,
        'created_at': date,
        'updated_at': date,
      });

      categoryId = categoryDoc.id;
    } else {
      categoryId = categoryQuery.docs.first.id;
      _categoriesCollectionReference.doc(categoryId).update({
        'updated_at': date,
      });
    }

    final subcategoryQuery =
        await _subcategoriesCollectionReference.where('subcategory', isEqualTo: subcategory).get();

    if (subcategoryQuery.docs.isEmpty) {
      final subcategoryDoc = await _subcategoriesCollectionReference.add({
        'subcategory': subcategory.trim(),
        'category_id': categoryId,
        'subcategory_id': _subcategoriesCollectionReference.doc().id,
        'created_at': date,
        'updated_at': date,
      });

      subcategoryId = subcategoryDoc.id;
    } else {
      subcategoryId = subcategoryQuery.docs.first.id;
      _subcategoriesCollectionReference.doc(subcategoryId).update({
        'updated_at': date,
      });
    }

    await _entriesCollectionReference.add({
      'id': _entriesCollectionReference.doc().id,
      'category': categoryId,
      'subcategory': subcategoryId,
      'value': value.trim(),
      'date': date,
    });
  }

  Future<void> addEntry(String categoryId, String subcategoryId, String value, DateTime date) async {
    await _entriesCollectionReference.add({
      'id': _entriesCollectionReference.doc().id,
      'category': categoryId,
      'subcategory': subcategoryId,
      'value': value.trim(),
      'date': date,
    });

    await _categoriesCollectionReference.doc(categoryId).update({
      'updated_at': date,
    });

    await _subcategoriesCollectionReference.doc(subcategoryId).update({
      'updated_at': date,
    });
  }

  Future<void> createCategory(String categoryName, DateTime date) async {
    await _categoriesCollectionReference.add({
      'category_id': _categoriesCollectionReference.doc().id,
      'category': categoryName,
      'created_at': date,
      'updated_at': date,
    });
  }

  Future<void> createSubcategory(String subcategoryName, String categoryId, DateTime date) async {
    await _subcategoriesCollectionReference.add({
      'category_id': categoryId,
      'subcategory_id': _subcategoriesCollectionReference.doc().id,
      'subcategory': subcategoryName,
      'created_at': date,
      'updated_at': date,
    });
  }

  Future<void> deleteCategory(String id) async {
    await _categoriesCollectionReference.doc(id).delete();

    final subcategoriesQuery =
        await _subcategoriesCollectionReference.where('category_id', isEqualTo: id).get();

    for (final subcategory in subcategoriesQuery.docs) {
      await _subcategoriesCollectionReference.doc(subcategory.id).delete();
    }

    final entriesQuery = await _entriesCollectionReference.where('category', isEqualTo: id).get();

    for (final entry in entriesQuery.docs) {
      await _entriesCollectionReference.doc(entry.id).delete();
    }
  }

  Future<void> deleteSubcategory(String id) async {
    await _subcategoriesCollectionReference.doc(id).delete();

    final entriesQuery = await _entriesCollectionReference.where('subcategory', isEqualTo: id).get();

    for (final entry in entriesQuery.docs) {
      await _entriesCollectionReference.doc(entry.id).delete();
    }
  }

  Future<void> deleteEntry(String id) async {
    await _entriesCollectionReference.doc(id).delete();
  }

  Future<void> updateEntry(
      String id, String category, String subcategory, String value, DateTime date) async {
    await _entriesCollectionReference.doc(id).update({
      'category': category,
      'subcategory': subcategory,
      'value': value,
      'date': date,
    });
  }
}
