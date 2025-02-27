// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv/blocs/authentication/authentication_bloc.dart';
import 'package:reserv/models/session.dart';
import 'package:reserv/repositories/authentication_repository.dart';
import 'package:reserv/views/widgets/bottom_sheet.dart';

class SessionListTile extends StatelessWidget {
  const SessionListTile({super.key, required this.session});
  final Session session;

  @override
  Widget build(BuildContext context) {
    final styles = Theme.of(context).textTheme.bodySmall;
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        bool isRoleLecturer = false;
        if (state.status == AuthenticationStatus.authenticated) {
          isRoleLecturer = state.user.role.toLowerCase() == "lecturer";
        }
        return GestureDetector(
          onTap: () {
            showListTileDetails(context: context, session: session);
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.90,
            margin: EdgeInsets.symmetric(horizontal: 8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Theme.of(context).cardColor,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 5),
                      color: Colors.black38),
                ]),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      height: 100,
                      width: 5,
                      decoration: const BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.moduleName,
                            style: styles!.copyWith(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_city,
                                color: Theme.of(context)
                                    .iconTheme
                                    .color!
                                    .withAlpha(80),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                session.hlName,
                                style: styles.copyWith(fontSize: 18),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.schedule,
                                  color: Theme.of(context)
                                      .iconTheme
                                      .color!
                                      .withAlpha(80)),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${session.startTime} - ${session.endTime}",
                                style: styles.copyWith(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          isRoleLecturer
                              ? Row(
                                  children: [
                                    Icon(Icons.school,
                                        color: Theme.of(context)
                                            .iconTheme
                                            .color!
                                            .withAlpha(80)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      session.academicYear,
                                      style: styles.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    )
                  ],
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                // isRoleLecturer
                //     ? MaterialButton(
                //         onPressed: () {
                //           showListTileDetails(context: context, session: session);
                //         },
                //         color: Colors.teal,
                //         minWidth: MediaQuery.of(context).size.width,
                //         shape: ContinuousRectangleBorder(
                //             borderRadius: BorderRadius.circular(15)),
                //         child: Text(
                //           "Check",
                //           style: styles.copyWith(
                //               fontSize: 20,
                //               fontWeight: FontWeight.w500,
                //               color: Colors.white),
                //         ),
                //       )
                //     : const SizedBox.shrink()
              ],
            ),
          ),
        );
      },
    );
  }
}
