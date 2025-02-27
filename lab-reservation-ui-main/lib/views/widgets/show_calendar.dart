import 'package:flutter/material.dart';

void pickDate({required BuildContext context}) async {
  await showDatePicker(
    context: context,
    keyboardType: TextInputType.datetime,
    initialDatePickerMode: DatePickerMode.day,
    initialEntryMode: DatePickerEntryMode.calendar,
    firstDate: DateTime(
      1900,
      DateTime.january,
    ),
    lastDate: DateTime(
      DateTime.now().year,
      DateTime.december,
    ),
  );
}
