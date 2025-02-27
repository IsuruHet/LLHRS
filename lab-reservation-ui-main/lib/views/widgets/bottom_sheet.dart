import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reserv/blocs/authentication/authentication_bloc.dart';
import 'package:reserv/models/session.dart';
import 'package:reserv/repositories/authentication_repository.dart';

void showListTileDetails(
    {required BuildContext context, required Session session}) {
  final TextStyle detailsTextStyle = Theme.of(context)
      .textTheme
      .titleSmall!
      .copyWith(fontWeight: FontWeight.bold, fontSize: 18);
  final TextStyle titleTextStyle =
      Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 18);
  final TextStyle buttonTextStyle = Theme.of(context)
      .textTheme
      .titleSmall!
      .copyWith(fontSize: 16, color: Colors.white);
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    barrierColor: Colors.black.withOpacity(0.5),
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      return Builder(builder: (context) {
        final state = context.watch<AuthenticationBloc>().state;
        bool isRoleLecturer = false;
        if (state.status == AuthenticationStatus.authenticated) {
          isRoleLecturer = state.user.role.toLowerCase() == "lecturer";
        }
        return SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.60,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        session.moduleName,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: detailsTextStyle.copyWith(fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Year",
                      style: titleTextStyle,
                    ),
                    Text(
                      session.academicYear,
                      style: detailsTextStyle,
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Time",
                      style: titleTextStyle,
                    ),
                    Text(
                      "${session.startTime} - ${session.endTime}",
                      style: detailsTextStyle,
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Room",
                      style: titleTextStyle,
                    ),
                    Text(
                      session.hlName,
                      style: detailsTextStyle,
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                isRoleLecturer
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: MaterialButton(
                              color: Colors.teal,
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              onPressed: () {
                                // Todo: add cancel logic
                              },
                              child: Text(
                                "Cancel",
                                style: buttonTextStyle,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: OutlinedButton(
                              style: ButtonStyle(
                                side: const WidgetStatePropertyAll(
                                    BorderSide(color: Colors.teal)),
                                shape: WidgetStatePropertyAll(
                                  ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                context.push("/search-available",
                                    extra: session);
                              },
                              child: Text(
                                "Reschedule",
                                style: buttonTextStyle.copyWith(
                                    color: Colors.teal),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ),
        );
      });
    },
  );
}
