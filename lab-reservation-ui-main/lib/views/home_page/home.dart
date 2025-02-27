import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:reserv/services/session_service.dart';
import 'package:reserv/views/widgets/session_list_tile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       context.push("/notifications");
        //     },
        //     icon: const Badge(
        //       isLabelVisible: true,
        //       label: Text("4"),
        //       child: Icon(
        //         Icons.notifications,
        //         color: Colors.white,
        //       ),
        //     ),
        //   )
        // ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Today's Schedule",
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: FutureBuilder(
                future: context.read<SessionService>().getTodaySessions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitThreeBounce(
                        color: Theme.of(context).progressIndicatorTheme.color,
                        size: 30.0,
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      return ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                        itemBuilder: (context, index) {
                          return SessionListTile(
                            session: snapshot.data![index],
                          );
                        },
                        itemCount: snapshot.data!.length,
                      );
                    }
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.3),
                            const Icon(
                              Icons.warning,
                              size: 36,
                              color: Colors.amber,
                            ),
                            const Text("No schedules for today."),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.3),
                          ],
                        ),
                      ),
                    );
                  }
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wifi_off,
                          color: Colors.red,
                          size: 35,
                        ),
                        Text("Please check your internet conncetion")
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      )),
    );
  }
}
