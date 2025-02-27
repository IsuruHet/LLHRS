import 'package:flutter/material.dart';
import 'package:reserv/models/session.dart';

class PostponedTile extends StatelessWidget {
  const PostponedTile({super.key, required this.session});
  final Session session;

  List<String> date() {
    return session.date.split("-");
  }

  @override
  Widget build(BuildContext context) {
    final styles = Theme.of(context).textTheme.bodySmall;
    final dateArray = date();
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).cardColor,
        boxShadow: const <BoxShadow>[
          BoxShadow(
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 5),
            color: Colors.black38,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.04,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    dateArray[0],
                    style: styles!
                        .copyWith(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    dateArray[1],
                    style: styles.copyWith(
                        fontSize: 24, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    dateArray[2],
                    style: styles.copyWith(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                height: 100,
                child: VerticalDivider(
                  thickness: 3,
                  color: Colors.teal[300],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.moduleName,
                      style: styles.copyWith(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
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
                          style: styles.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color:
                              Theme.of(context).iconTheme.color!.withAlpha(80),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "${session.startTime} - ${session.endTime}",
                          style: styles.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.school,
                          color:
                              Theme.of(context).iconTheme.color!.withAlpha(80),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          session.academicYear,
                          style: styles.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
