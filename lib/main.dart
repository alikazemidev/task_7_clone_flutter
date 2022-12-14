import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list_7_1/data.dart';

const taskBoxName = 'tasks';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<Task>(taskBoxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return EditTaskScreen();
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
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: ValueListenableBuilder<Box<Task>>(
        valueListenable: box.listenable(),
        builder: (context, box, child) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                color: Colors.red,
                height: 100,
                width: double.infinity,
                child: Center(
                  child: Text(
                    box.values.toList()[index].name!,
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
            itemCount: box.values.length,
          );
        },
      ),
    );
  }
}

class EditTaskScreen extends StatelessWidget {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add task'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            final task = Task(
              name: _controller.text,
              priority: Priority.low,
              isCompleted: false,
            );
            //Todo uncomment this
            if (task.isInBox) {
              task.save();
            } else {
              final Box<Task> box = Hive.box(taskBoxName);
              box.add(task);
            }
            Navigator.pop(context);
          },
          label: Row(
            children: [
              Text('save changes'),
              Icon(Icons.check),
            ],
          )),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              label: Text('Add a task for today...'),
            ),
          ),
        ],
      ),
    );
  }
}
