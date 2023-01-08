import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_7_1/data/data.dart';
import 'package:todo_list_7_1/data/repo/repositry.dart';

import 'package:todo_list_7_1/main.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  EditTaskScreen({required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.task.name);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.surface,
        foregroundColor: themeData.colorScheme.onSurface,
        elevation: 0,
        title: Text('add task'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          widget.task.name = _controller.text;
          widget.task.priority = widget.task.priority;
          widget.task.isCompleted = false;
          final repository =
              Provider.of<Repository<Task>>(context, listen: false);
          repository.createOrUpdate(widget.task);

          Navigator.pop(context);
        },
        label: Row(
          children: [
            Text('save changes'),
            Icon(Icons.check),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                  flex: 1,
                  child: PriorityCheckBox(
                    onTap: () {
                      setState(() {
                        widget.task.priority = Priority.high;
                      });
                    },
                    lable: 'High',
                    isSelected: widget.task.priority == Priority.high,
                    color: highPriority,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  flex: 1,
                  child: PriorityCheckBox(
                      onTap: () {
                        setState(() {
                          widget.task.priority = Priority.noraml;
                        });
                      },
                      lable: 'Normal',
                      isSelected: widget.task.priority == Priority.noraml,
                      color: normalPriority),
                ),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  flex: 1,
                  child: PriorityCheckBox(
                    onTap: () {
                      setState(() {
                        widget.task.priority = Priority.low;
                      });
                    },
                    lable: 'Low',
                    isSelected: widget.task.priority == Priority.low,
                    color: lowPriority,
                  ),
                ),
              ],
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                  label: Text('Add a task for today...'),
                  labelStyle: TextStyle(
                    color: primaryTexColor,
                    fontSize: 20,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  final String lable;
  final bool isSelected;
  final Color color;
  final GestureTapCallback onTap;
  const PriorityCheckBox({
    super.key,
    required this.lable,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 2,
            color: secondaryTexColor.withOpacity(0.5),
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(lable),
            ),
            Positioned(
              right: 5,
              bottom: 0,
              top: 0,
              child: Center(
                child: CheckBoxShape(
                  value: isSelected,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckBoxShape extends StatelessWidget {
  final bool value;
  final Color color;
  const CheckBoxShape({super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              size: 14,
              color: Theme.of(context).colorScheme.onPrimary,
            )
          : null,
    );
  }
}
