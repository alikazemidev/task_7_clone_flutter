import 'package:hive_flutter/adapters.dart';
part 'data.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String? name = '';
  @HiveField(1)
  bool? isCompleted = false;
  @HiveField(2)
  Priority? priority = Priority.low;

  Task({
    this.name,
    this.isCompleted,
    this.priority,
  });
}

enum Priority {
  low,
  noraml,
  high,
}
