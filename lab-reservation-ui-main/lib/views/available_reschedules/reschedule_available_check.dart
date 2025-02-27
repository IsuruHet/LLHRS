import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reserv/blocs/reschedule/reschedule_cubit.dart';
import 'package:reserv/models/session.dart';
import 'package:reserv/views/widgets/popup.dart';
import 'package:reserv/views/widgets/snack_bar.dart';

final formkey = GlobalKey<FormState>();

class RescheduleAvailableCheck extends StatefulWidget {
  const RescheduleAvailableCheck({super.key, required this.session});
  final Session session;
  @override
  State<RescheduleAvailableCheck> createState() =>
      _RescheduleAvailableCheckState();
}

class _RescheduleAvailableCheckState extends State<RescheduleAvailableCheck> {
  final TextEditingController startTimeText = TextEditingController();

  final TextEditingController endTimeText = TextEditingController();

  final TextEditingController capacity = TextEditingController();

  final TextEditingController dateText = TextEditingController();

  late DateTime date;
  late TimeOfDay endTime;
  late TimeOfDay startTime;
  late String moduleType;

  void _search() async {
    if (formkey.currentState?.validate() ?? false) {
      await context.read<RescheduleCubit>().getAvailableSlots(
          date: date,
          startTime: startTime,
          endTime: endTime,
          capacity: int.parse(capacity.text),
          moduleType: moduleType);
    }
  }

  @override
  void dispose() {
    startTimeText.dispose();
    endTimeText.dispose();
    capacity.dispose();
    dateText.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<RescheduleCubit>().reset();
    capacity.text = "150";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reschedule"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 12),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Text(
                  widget.session.moduleName,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  widget.session.moduleCode,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                const SizedBox(
                  height: 8,
                ),
                Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field cannot be empty';
                        }
                        return null;
                      },
                      onTap: () async {
                        final dateTime = await datePicker();
                        if (dateTime != null) {
                          date = dateTime;
                          dateText.text = "${dateTime.month}/${dateTime.day}";
                        }
                      },
                      controller: dateText,
                      readOnly: true,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.calendar_month),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Pick a Date",
                        labelText: "Pick a Date",
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.46,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field cannot be empty';
                              }
                              return null;
                            },
                            onTap: () async {
                              final time = await timePicker();
                              if (time != null) {
                                startTime = time;
                                startTimeText.text =
                                    "${time.hour}:${time.minute}";
                              }
                            },
                            controller: startTimeText,
                            readOnly: true,
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.timelapse),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              hintText: "Start time",
                              labelText: "Start time",
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.04,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.46,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field cannot be empty';
                              }
                              return null;
                            },
                            onTap: () async {
                              final time = await timePicker();
                              if (time != null) {
                                endTime = time;
                                endTimeText.text =
                                    "${time.hour}:${time.minute}";
                              }
                            },
                            controller: endTimeText,
                            readOnly: true,
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.timelapse),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              hintText: "End time",
                              labelText: "End time",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    DropdownButtonFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field cannot be empty';
                        }
                        return null;
                      },
                      items: ["Lecture", "Practical", "Tutorial"]
                          .map((value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                              )))
                          .toList(),
                      hint: const Text("Select module type"),
                      onChanged: (value) {
                        if (value != null) {
                          moduleType = value;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Select module type",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field cannot be empty';
                        }
                        return null;
                      },
                      controller: capacity,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.cabin_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Capacity",
                        labelText: "Capacity",
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () {
                          _search();
                        },
                        child: const Icon(Icons.search),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
                Builder(builder: (context) {
                  final state = context.watch<RescheduleCubit>().state;
                  if (state.status == RescheduleStatus.searched) {
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        return Material(
                          borderRadius: BorderRadius.circular(12),
                          elevation: 5,
                          child: ListTile(
                            title: Text(
                              state.availableSlots[index].hlName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 20),
                            ),
                            trailing: ElevatedButton(
                                style: const ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.teal)),
                                onPressed: () {
                                  showYesNoPopup(context,
                                      message: "Do you need to book this hall?",
                                      onYesClick: () async {
                                    context.pop();
                                    final res = await context
                                        .read<RescheduleCubit>()
                                        .rescheduleModule(
                                            date: date,
                                            startTime: startTime,
                                            endTime: endTime,
                                            capacity: int.parse(capacity.text),
                                            session: widget.session,
                                            hlName: state
                                                .availableSlots[index].hlName);
                                    if (res) {
                                      context.read<RescheduleCubit>().reset();
                                      showSnackBar(
                                          context: context,
                                          bkgColor: Colors.orange.shade800,
                                          message: "Wait till Confirmation");
                                    }
                                  });
                                },
                                child: Text(
                                  "Book",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          fontSize: 16, color: Colors.white),
                                )),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 8,
                      ),
                      itemCount: state.availableSlots.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    );
                  }
                  if (state.status == RescheduleStatus.searching) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state.status == RescheduleStatus.empty) {
                    return const Center(
                      child: Text(
                          "Rooms not available for that time or resources"),
                    );
                  }
                  return const SizedBox.shrink();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<DateTime?> datePicker() async {
    return await showDatePicker(
        context: context, firstDate: DateTime.now(), lastDate: DateTime(2100));
  }

  Future<TimeOfDay?> timePicker() async {
    return await showTimePicker(
        context: context, initialTime: const TimeOfDay(hour: 0, minute: 0));
  }
}
