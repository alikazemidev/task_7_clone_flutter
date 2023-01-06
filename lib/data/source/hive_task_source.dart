import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list_7_1/data/data.dart';
import 'package:todo_list_7_1/data/source/source.dart';

class HiveTaskSource implements DataSource<Task> {
  final Box<Task> box;

  HiveTaskSource(this.box);

  @override
  Future<Task> createOrUpdate(Task data) async {
    if (data.isInBox) {
      data.save();
    } else {
      data.id = await box.add(data);
    }
    return data;
  }

  @override
  Future<void> delete(Task data) async {
    return data.delete();
  }

  @override
  Future<void> deleteAll() {
    return box.clear();
  }

  @override
  Future<void> deleteById(id) {
    return box.delete(id);
  }

  @override
  Future<Task> findById(id) async {
    return box.values.firstWhere((element) => element.id == id);
  }

  @override
  Future<List<Task>> getAll({String searchKeyword = ''}) async{
    return box.values.toList();
  }
}
