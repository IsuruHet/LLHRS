import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({super.key});
  final Set<String> _selected = {"All"};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Column(
        children: [
          // Row(
          //   children: [
          //     SegmentedButton(

          //         onSelectionChanged: (p0) {},
          //         segments: const [
          //           ButtonSegment(value: "All", label: Text("All")),
          //           ButtonSegment(value: "Requests", label: Text("Requests")),
          //           ButtonSegment(value: "Slots", label: Text("Slots")),
          //         ],
          //         selected: _selected),
          //   ],
          // ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              OutlinedButton(
                onPressed: () {},
                child: Text("All"),
              ),
              const SizedBox(
                width: 10,
              ),
              OutlinedButton(
                onPressed: () {},
                child: Text("Requests"),
              ),
              const SizedBox(
                width: 10,
              ),
              OutlinedButton(
                onPressed: () {},
                child: Text("Slots"),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return notificationListTile();
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: Color(0xFFC0BEBE),
                    height: 1,
                  );
                },
                itemCount: 10),
          ),
        ],
      ),
    );
  }
}

Widget notificationListTile() {
  return ListTile(
    title: const Text("data"),
    trailing: PopupMenuButton(
      itemBuilder: (context) {
        return [
          const PopupMenuItem(child: Text("Read")),
          const PopupMenuItem(child: Text("Delete")),
        ];
      },
    ),
  );
}
