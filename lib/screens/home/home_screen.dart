import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list_7_1/data/data.dart';
import 'package:todo_list_7_1/main.dart';
import 'package:todo_list_7_1/screens/edit/edit_task_screen.dart';
import 'package:todo_list_7_1/widgets.dart';


class HomePage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<String> searchKeywordNotifier = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Task>(taskBoxName);
    final themeData = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return EditTaskScreen(
                  task: Task(),
                );
              },
            ),
          );
        },
        label: Row(
          children: [
            Text('Add New Task'),
            Icon(Icons.add),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 110,
              decoration: BoxDecoration(
                color: Colors.red,
                gradient: LinearGradient(
                  colors: [
                    themeData.colorScheme.primary,
                    themeData.colorScheme.primaryContainer,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'To Do List',
                          style: themeData.textTheme.headline6!.apply(
                            color: themeData.colorScheme.onPrimary,
                          ),
                        ),
                        Icon(
                          CupertinoIcons.chevron_down_square,
                          color: themeData.colorScheme.onPrimary,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19),
                        color: themeData.colorScheme.onPrimary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.2),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) {
                          searchKeywordNotifier.value = _controller.text;
                        },
                        controller: _controller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(15),
                          label: Text('search task...'),
                          prefixIcon: Icon(CupertinoIcons.search),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<String>(
                valueListenable: searchKeywordNotifier,
                builder: (context, value, child) {
                  return ValueListenableBuilder<Box<Task>>(
                    valueListenable: box.listenable(),
                    builder: (context, box, child) {
                      final List<Task> items;
                      if (_controller.text.isEmpty) {
                        items = box.values.toList();
                      } else {
                        items = box.values
                            .where(
                              (task) => task.name!.contains(_controller.text),
                            )
                            .toList();
                      }
                      if (items.isNotEmpty) {
                        return ListView.builder(
                          itemCount: items.length + 1,
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Today',
                                        style: themeData.textTheme.headline6!
                                            .apply(
                                          fontSizeFactor: 0.9,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 4),
                                        width: 100,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: themeData.colorScheme.primary,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      )
                                    ],
                                  ),
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        box.clear();
                                      },
                                      label: Text('Delete All'),
                                      icon: Icon(CupertinoIcons.delete),
                                    ),
                                  ),
                                ],
                              );
                            }
                            final task = items[index - 1];
                            return TaskItem(task: task);
                          },
                        );
                      } else {
                        return EmptyState();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem({Key? key, required this.task}) : super(key: key);
  static const double height = 74;
  final Task task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final Color priorityColor;

    switch (widget.task.priority!) {
      case Priority.low:
        priorityColor = lowPriority;
        break;
      case Priority.noraml:
        priorityColor = normalPriority;
        break;
      case Priority.high:
        priorityColor = highPriority;
        break;
    }
    return InkWell(
      onLongPress: () {
        widget.task.delete();
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditTaskScreen(task: widget.task),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(20),
        height: TaskItem.height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: themeData.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          children: [
            MyCheckBox(
              value: widget.task.isCompleted!,
              onTap: () {
                setState(() {
                  widget.task.isCompleted = !widget.task.isCompleted!;
                });
              },
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.task.name!,
                style: TextStyle(
                  decoration: widget.task.isCompleted!
                      ? TextDecoration.lineThrough
                      : null,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Container(
              height: TaskItem.height,
              width: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                color: priorityColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}