import 'package:cloud_firestore/cloud_firestore.dart';

sealed class RemoteStorageAdapter {
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAllCollection(
      String userId);
  Future<void> deleteAllData(String userId);
  Future<void> deleteData({required String userId, required String id});
  Future<DocumentReference> addData(
      {required String userId, required Map<String, dynamic> data});
  Future<void> updateData(
      {required String id,
      required String userId,
      required Map<String, dynamic> data});
}

class FirestorageAdapter implements RemoteStorageAdapter {
  final FirebaseFirestore firestore;

  FirestorageAdapter({required this.firestore});
  @override
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAllCollection(
      String userId) async {
    final collection = await firestore.collection(userId).get();
    return collection.docs;
  }

  @override
  Future<void> deleteAllData(String userId) async {
    await firestore.collection(userId).doc().delete();
  }

  @override
  Future<void> deleteData({required String userId, required String id}) async {
    final collection = await fetchAllData(userId);
    final toDo = collection.docs.firstWhere((element) => element.id == id);
    await toDo.reference.delete();
  }

  @override
  Future<DocumentReference> addData(
      {required String userId, required Map<String, dynamic> data}) async {
    final savedData = await firestore.collection(userId).add(data);

    return savedData;
  }

  @override
  Future<void> updateData(
      {required String id,
      required String userId,
      required Map<String, dynamic> data}) async {
    final collection = await fetchAllData(userId);
    final toDo = collection.docs.firstWhere((element) => element.id == id);
    await toDo.reference.update(data);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchAllData(
      String userId) async {
    return await firestore.collection(userId).get();
  }
}
