import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reserv/blocs/authentication/authentication_bloc.dart';
import 'package:reserv/blocs/sessions_prefs/sessions_preference_cubit.dart';
import 'package:reserv/configs/sessions_details.dart';
import 'package:reserv/repositories/authentication_repository.dart';
import 'package:reserv/views/widgets/popup.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  List<FocusArea> getFocusAreas(String degree) {
    switch (degree.toLowerCase()) {
      case 'it':
        return ict.focusArea;
      case 'et':
        return egt.focusArea;
      case 'bt':
        return bst.focusArea;
      default:
        return ict.focusArea;
    }
  }

  @override
  Widget build(BuildContext context) {
    final styles = Theme.of(context).textTheme.bodySmall;

    final email = TextEditingController();
    final id = TextEditingController();
    final role = TextEditingController();
    final year = TextEditingController();
    String name = '';

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      if (state.status == AuthenticationStatus.authenticated) {
        email.text = state.user.email;
        id.text = state.user.id;
        role.text = state.user.role;
        year.text = state.user.academicYear;
        name = "${state.user.firstName} ${state.user.lastName}";
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        child: Icon(
                          Icons.person_2_rounded,
                          size: 50,
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Icon(Icons.edit),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    name,
                    style: styles!.copyWith(fontSize: 22),
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  dataField(context, controller: id, icon: Icons.person),
                  const SizedBox(
                    height: 8,
                  ),
                  dataField(context, controller: email, icon: Icons.email),
                  const SizedBox(
                    height: 8,
                  ),
                  dataField(context, controller: role, icon: Icons.badge),
                  const SizedBox(
                    height: 8,
                  ),
                  dataField(context, controller: year, icon: Icons.school),
                  const SizedBox(
                    height: 28,
                  ),
                  Builder(builder: (context) {
                    final dropDownState =
                        context.watch<SessionsPreferenceCubit>().state;

                    return state.user.role.toLowerCase() != "lecturer"
                        ? DropdownButton(
                            isExpanded: true,
                            items: getFocusAreas(state.user.degree)
                                .map(
                                  (value) => DropdownMenuItem<FocusArea>(
                                    value: value,
                                    child: Text(
                                      value.areaName,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            hint: Text(dropDownState.area.areaName),
                            onChanged: (value) {
                              if (value != null) {
                                context
                                    .read<SessionsPreferenceCubit>()
                                    .toggleForcusAreaStatus(value);
                              }
                            },
                          )
                        : const SizedBox.shrink();
                  }),
                  const SizedBox(
                    height: 16,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      showYesNoPopup(context, message: "Do you want to log out",
                          onYesClick: () {
                        context
                            .read<AuthenticationBloc>()
                            .add(AuthenticationLogoutPressed());
                      });
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Sign out"),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget dataField(
    BuildContext context, {
    required TextEditingController controller,
    required IconData icon,
  }) {
    final boxDecoration = InputDecoration(
      fillColor: Colors.teal,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 30,
            color: Colors.teal,
          ),
          const SizedBox(
            width: 16,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: TextField(
              controller: controller,
              readOnly: true,
              decoration: boxDecoration,
            ),
          ),
        ],
      ),
    );
  }
}
