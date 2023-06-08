import 'package:cloud_firestore/cloud_firestore.dart';

sealed class RemoteStorageAdapter {
  Future<Map<String, dynamic>> getAllCollection(String userId);
  Future<void> deleteAllData(String userId);
  Future<void> deleteData({required String userId, required String id});
  Future<DocumentReference> addData(
      {required String userId, required Map<String, dynamic> data});
}

class FirestorageAdapter implements RemoteStorageAdapter {
  final FirebaseFirestore firestore;

  FirestorageAdapter({required this.firestore});
  @override
  Future<Map<String, dynamic>> getAllCollection(String userId) async {
    final Map<String, dynamic> fetchedData;
    final DocumentSnapshot<Map<String, dynamic>> collection =
        await fetchData(userId);

    fetchedData = collection.data() as Map<String, dynamic>;
    return fetchedData;
  }

  @override
  Future<void> deleteAllData(String userId) async {
    await firestore.collection('users').doc(userId).delete();
  }

  @override
  Future<void> deleteData({required String userId, required String id}) async {
    final collection = await firestore.collection(userId).get();
    final toDo = collection.docs.firstWhere((element) => element.id == id);
    await toDo.reference.delete();
  }

  @override
  Future<DocumentReference> addData(
      {required String userId, required Map<String, dynamic> data}) async {
    final savedData = await firestore.collection(userId).add(data);

    return savedData;
  }

  fetchData(String userId) async {
    return await firestore.collection('users').doc(userId).get();
  }
}
