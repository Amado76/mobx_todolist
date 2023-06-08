// ignore_for_file: public_member_api_docs, sort_constructors_first, library_private_types_in_public_api
import 'package:mobx/mobx.dart';

part 'to_do_store.g.dart';

class ToDoStore = _ToDoStore with _$ToDoStore;

abstract class _ToDoStore with Store {
  final String id;
  final DateTime creationDate;
  @observable
  String title;
  @observable
  String content;
  @observable
  bool isDone;

  _ToDoStore({
    required this.id,
    required this.creationDate,
    required this.title,
    required this.content,
    required this.isDone,
  });

  @override
  bool operator ==(covariant _ToDoStore other) =>
      id == other.id &&
      title == other.title &&
      content == other.content &&
      isDone == other.isDone;

  @override
  int get hashCode => Object.hash(id, title, content, isDone);
}
