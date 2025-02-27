import 'package:flutter/material.dart';
import 'package:reserv/models/session.dart';
import 'package:reserv/views/widgets/bottom_sheet.dart';

class CalendarItems extends StatelessWidget {
  const CalendarItems({super.key, required this.session});
  final Session session;

  @override
  Widget build(BuildContext context) {
    final styles = Theme.of(context).textTheme.bodySmall;
    return GestureDetector(
      onTap: () {
        showListTileDetails(context: context, session: session);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withAlpha(225),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              spreadRadius: 0,
              blurRadius: 3,
              offset: Offset(0, 3),
              color: Colors.black38,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 5,
                  height: MediaQuery.of(context).size.height * 0.18,
                  decoration: const BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.08,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width *
                          0.70, // Adjust the width
                      child: Text(
                        session.moduleName,
                        style: styles!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1, // Limit the text to 2 lines
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color:
                              Theme.of(context).iconTheme.color!.withAlpha(80),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${session.startTime} - ${session.endTime}",
                          style: styles.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_city,
                          color:
                              Theme.of(context).iconTheme.color!.withAlpha(80),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          session.hlName,
                          style: styles.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.type_specimen_rounded,
                          color:
                              Theme.of(context).iconTheme.color!.withAlpha(80),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          session.moduleType,
                          style: styles.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            // Optionally, you can add an icon or other elements here
          ],
        ),
      ),
    );
  }
}
