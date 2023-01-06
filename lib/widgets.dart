import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_list_7_1/main.dart';



class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/empty_state.svg',
            width: 200,
            height: 200,
          ),
          SizedBox(
            height: 20,
          ),
          Text('your task list is empty'),
        ],
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