import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:todo_list_7_1/data/data.dart';
import 'package:todo_list_7_1/screens/edit/edit_task_screen.dart';
import 'package:todo_list_7_1/screens/home/home_screen.dart';
import 'package:todo_list_7_1/widgets.dart';

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
          floatingLabelBehavior: FloatingLabelBehavior.never,
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


