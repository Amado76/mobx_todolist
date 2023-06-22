import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentReference, Timestamp;
import 'package:mobx_todolist/store/to_do_store.dart';
import 'package:mobx_todolist/util/to_do_dto.dart';

import '../adapter/remote_storage_adapter.dart';

sealed class IToDoRepository {
  final RemoteStorageAdapter remoteStorageAdapter;

  IToDoRepository({required this.remoteStorageAdapter});
  Future<List<ToDoStore>> getAllCollection(String userId);
  Future<void> deleteAllDataFromRemoteStorage(String userId);
  Future<void> deleteDataFromRemoteStorage(
      {required String userId, required ToDoStore toDo});
  Future<DocumentReference> addDataToRemoteStorage(
      {required String userId, required ToDoDto toDoDto});
  Future<List<ToDoStore>> addData(
      {required ToDoDto toDoDto,
      required String userId,
      required List<ToDoStore> toDoList});
  Future<void> updateData(
      {required ToDoStore toDo,
      required String userId,
      required Map<String, dynamic> data});
}

class ToDoRepository extends IToDoRepository {
  ToDoRepository({required super.remoteStorageAdapter});

  @override
  Future<List<ToDoStore>> getAllCollection(String userId) async {
    List<ToDoStore> toDoList;
    final collection = await remoteStorageAdapter.getAllCollection(userId);

    toDoList = collection
        .map((doc) => ToDoStore(
              id: doc.id,
              creationDate: (doc[_ToDoKeys.creationDate] as Timestamp).toDate(),
              title: doc[_ToDoKeys.title] as String,
              content: doc[_ToDoKeys.content] as String,
              isDone: doc[_ToDoKeys.isDone] as bool,
            ))
        .toList();
    return toDoList;
  }

  @override
  Future<void> deleteAllDataFromRemoteStorage(String userId) async {
    await remoteStorageAdapter.deleteAllData(userId);
  }

  @override
  Future<void> deleteDataFromRemoteStorage(
      {required String userId, required ToDoStore toDo}) async {
    final id = toDo.id;
    await remoteStorageAdapter.deleteData(userId: userId, id: id);
  }

  @override
  Future<List<ToDoStore>> addData(
      {required ToDoDto toDoDto,
      required String userId,
      required List<ToDoStore> toDoList}) async {
    final savedToDo =
        await addDataToRemoteStorage(toDoDto: toDoDto, userId: userId);
    toDoDto.id = savedToDo.id;
    toDoList.add(toDoDto.toModel());
    return toDoList;
  }

  @override
  Future<DocumentReference> addDataToRemoteStorage(
      {required String userId, required ToDoDto toDoDto}) async {
    final Map<String, dynamic> data = {
      _ToDoKeys.title: toDoDto.title,
      _ToDoKeys.content: toDoDto.content,
      _ToDoKeys.creationDate: toDoDto.creationDate,
      _ToDoKeys.isDone: toDoDto.isDone,
    };
    return await remoteStorageAdapter.addData(userId: userId, data: data);
  }

  @override
  Future<void> updateData(
      {required ToDoStore toDo,
      required String userId,
      required Map<String, dynamic> data}) async {
    await remoteStorageAdapter.updateData(
        id: toDo.id, userId: userId, data: data);
  }
}

abstract class _ToDoKeys {
  static const String title = 'title';
  static const String isDone = 'isDone';
  static const String creationDate = 'reationDate';
  static const String content = 'content';
}
