import 'package:flutter/material.dart';

void timePicker({
  required BuildContext context,
}) async {
  await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
      initialEntryMode: TimePickerEntryMode.input);
}
