import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFireStoreService {
  final CollectionReference todo =
      FirebaseFirestore.instance.collection('todo');

  Future<void> deleteItem(String id) {
    return todo.doc(id).delete();
  }

  Future<DocumentReference<Object?>> addItem(Map<String, dynamic> item) {
    print("soso");
    return todo.add(item);
  }

  Future<void> updateItem(String id, Map<String, dynamic> item) {
    return todo.doc(id).update(item);
  }

  Stream<QuerySnapshot<Object?>> readItems() {
    return todo.snapshots();
  }
}
