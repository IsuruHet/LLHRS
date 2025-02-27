import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:reserv/services/session_service.dart';
import 'package:reserv/views/widgets/postponed_tile.dart';

class PostponedPage extends StatefulWidget {
  const PostponedPage({super.key});

  @override
  State<PostponedPage> createState() => _PostponedPageState();
}

class _PostponedPageState extends State<PostponedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Postpone"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            context.read<SessionService>().getRescheduleSessions();
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: FutureBuilder(
            future: context.read<SessionService>().getRescheduleSessions(),
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
                      return PostponedTile(
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
                            height: MediaQuery.of(context).size.height * 0.3),
                        const Icon(
                          Icons.warning,
                          size: 36,
                          color: Colors.amber,
                        ),
                        const Text("No reschedules."),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3),
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
                      size: 36,
                    ),
                    Text("Please check your internet conncetion")
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
