import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list_7_1/data.dart';
import 'package:todo_list_7_1/edit_task_screen.dart';

const taskBoxName = 'tasks';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<Task>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: primaryContainerColor),
  );
  runApp(
    const MyApp(),
  );
}

const primaryColor = Color(0xff794cff);
const primaryContainerColor = Color(0xff5c0aff);
const primaryTexColor = Color(0xff1d2830);
const secondaryTexColor = Color(0xffafbed0);
const normalPriority = Color(0xfff09819);
const highPriority = primaryColor;
const lowPriority = Color(0xff3bef1f1);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xffeaeff5),
            foregroundColor: secondaryTexColor,
            elevation: 0,
          ),
        ),
        // fontFamily: GoogleFonts.poppins(),
        textTheme: GoogleFonts.poppinsTextTheme(
          TextTheme(
            headline6: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: secondaryTexColor,
          ),
          iconColor: secondaryTexColor,
        ),
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          onPrimary: Colors.white,
          primaryContainer: primaryContainerColor,
          background: Color(0xfff3f5f8),
          onSurface: primaryTexColor,
          onBackground: primaryTexColor,
          secondary: primaryColor,
          onSecondary: Colors.white,
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              child: ValueListenableBuilder<Box<Task>>(
                valueListenable: box.listenable(),
                builder: (context, box, child) {
                  return ListView.builder(
                    itemCount: box.values.length + 1,
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Today',
                                  style: themeData.textTheme.headline6!.apply(
                                    fontSizeFactor: 0.9,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 4),
                                  width: 100,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: themeData.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                )
                              ],
                            ),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                label: Text('Delete All'),
                                icon: Icon(CupertinoIcons.delete),
                              ),
                            ),
                          ],
                        );
                      }
                      final task = box.values.toList()[index - 1];
                      return TaskItem(task: task);
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

class MyCheckBox extends StatelessWidget {
  final bool value;
  final GestureTapCallback onTap;
  const MyCheckBox({super.key, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          border: !value
              ? Border.all(
                  color: secondaryTexColor,
                  width: 2,
                )
              : null,
          borderRadius: BorderRadius.circular(12),
          color: value ? primaryColor : null,
        ),
        child: value
            ? Icon(
                CupertinoIcons.check_mark,
                size: 14,
                color: Theme.of(context).colorScheme.onPrimary,
              )
            : null,
      ),
    );
  }
}
