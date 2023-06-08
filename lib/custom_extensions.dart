import 'package:mobx_todolist/store/to_do_store.dart';

extension ToInt on bool {
  int toInt() => this ? 1 : 0;
}

extension Sorted on List<ToDoStore> {
  List<ToDoStore> sorted() => [...this]..sort((lhs, rhs) {
      final isDone = lhs.isDone.toInt().compareTo(rhs.isDone.toInt());
      if (isDone != 0) {
        return isDone;
      }
      return lhs.creationDate.compareTo(rhs.creationDate);
    });
}
