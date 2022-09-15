import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePickerPage extends StatefulWidget {
  const DatePickerPage({Key? key}) : super(key: key);

  @override
  State<DatePickerPage> createState() => _DatePickerPageState();
}

class _DatePickerPageState extends State<DatePickerPage> {
  bool dateMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Date Picker'),
      ),
      body: Column(
        children: [
          Switch(
            value: dateMode,
            onChanged: (v) => setState(() {
              dateMode = v;
            }),
          ),
          const Text('DatePicker在createState中添加了创建State的逻辑，所以不能动态更改mode'),
          Expanded(
            child: SingleChildScrollView(
              child: CupertinoDatePicker(
                mode: dateMode
                    ? CupertinoDatePickerMode.date
                    : CupertinoDatePickerMode.time,
                onDateTimeChanged: (d) {
                  print(d);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
