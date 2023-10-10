import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFireStoreService {
  late CollectionReference collectionName;

  Future<void> initalize(String email) async {
    collectionName = FirebaseFirestore.instance.collection(email);
  }

  Future<void> deleteItem(String id) {
    return collectionName.doc(id).delete();
  }

  Future<DocumentReference<Object?>> addItem(Map<String, dynamic> item) {
    return collectionName.add(item);
  }

  Future<void> updateItem(String id, Map<String, dynamic> item) {
    return collectionName.doc(id).update(item);
  }

  Stream<QuerySnapshot<Object?>> readItems() {
    return collectionName.snapshots();
  }
}
