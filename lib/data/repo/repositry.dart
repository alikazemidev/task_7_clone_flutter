import 'package:flutter/cupertino.dart';
import 'package:todo_list_7_1/data/data.dart';
import 'package:todo_list_7_1/data/source/source.dart';

class Repository<T> extends ChangeNotifier implements DataSource {
  final DataSource<T> localDataSource;

  Repository(this.localDataSource);

  @override
  Future createOrUpdate(data) async {
    final T result = await localDataSource.createOrUpdate(data);
    notifyListeners();
    return result;
  }

  @override
  Future<void> delete(data) async {
   await localDataSource.delete(data);
    notifyListeners();
  }

  @override
  Future<void> deleteAll() async {
  await  localDataSource.deleteAll();
    notifyListeners();
  }

  @override
  Future<void> deleteById(id) async {
  await  localDataSource.deleteById(id);
    notifyListeners();
  }

  @override
  Future<T> findById(id) {
    return localDataSource.findById(id);
  }

  @override
  Future<List<T>> getAll({String searchKeyword = ''}) {
    return localDataSource.getAll(searchKeyword: searchKeyword);
  }
}
