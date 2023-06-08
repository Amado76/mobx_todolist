import 'package:mobx_todolist/store/to_do_store.dart';

class ToDoDto {
  String? id;
  final DateTime creationDate;
  final String title;
  final String content;
  final bool isDone;

  ToDoDto({
    this.id,
    required this.creationDate,
    required this.title,
    required this.content,
    required this.isDone,
  });

  factory ToDoDto.fromModel(ToDoStore model) {
    return ToDoDto(
      id: model.id,
      creationDate: model.creationDate,
      title: model.title,
      content: model.content,
      isDone: model.isDone,
    );
  }

  ToDoStore toModel() {
    if (id == null) {
      throw Exception('id is null');
    }
    return ToDoStore(
      id: id!,
      creationDate: creationDate,
      title: title,
      content: content,
      isDone: isDone,
    );
  }
}
