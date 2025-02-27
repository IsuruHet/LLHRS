import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reserv/blocs/notification/notification_cubit.dart';
import 'package:reserv/blocs/theme/theme_cubit.dart';
import 'package:reserv/views/widgets/dialog_box.dart';
import 'package:reserv/views/widgets/setting_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    TextStyle? titleStyle = Theme.of(context).textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        );
    TextStyle? subtitleStyle = Theme.of(context).textTheme.labelSmall!.copyWith(
          fontSize: 13,
        );
    Color iconColor = Colors.teal; //  0xFF5E00F5

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CategoryTitle(title: "General"),
              SettingTile(
                leading: Icon(
                  Icons.person_2,
                  color: iconColor,
                ),
                title: Text(
                  "Profile Infomation",
                  style: titleStyle,
                ),
                onTap: () => context.push("/profile"),
              ),
              // Notifications on off setting
              Gap(),
              Builder(builder: (context) {
                final state = context.watch<NotificationCubit>().state;
                bool notificationButtonVal = true;
                if (state is NotificationToggleState) {
                  notificationButtonVal = state.notificatioStatus;
                }
                if (state is NotificationInitial) {
                  notificationButtonVal = state.notificatioStatus;
                }
                return SettingTile(
                  onTap: () {
                    context
                        .read<NotificationCubit>()
                        .toggleNotification(!notificationButtonVal);
                  },
                  leading: Icon(
                    Icons.notifications_active,
                    color: iconColor,
                  ),
                  title: Text(
                    "App Notifications",
                    style: titleStyle,
                  ),
                  subtitle: Text(
                    "Allow the app to send notification about upcoming sessions",
                    style: subtitleStyle,
                  ),
                  trailing: Switch(
                    value: notificationButtonVal,
                    onChanged: (value) {
                      context
                          .read<NotificationCubit>()
                          .toggleNotification(value);
                    },
                  ),
                );
              }),

              Gap(),
              Builder(
                builder: (context) {
                  final state = context.watch<ThemeCubit>().state;
                  bool themeButtonVal = false;
                  if (state is ThemeToggleState) {
                    themeButtonVal = state.isDark;
                  }
                  if (state is ThemeInitial) {
                    themeButtonVal = state.isDark;
                  }
                  return SettingTile(
                    onTap: () {
                      context.read<ThemeCubit>().toggleTheme(!themeButtonVal);
                    },
                    leading: Icon(
                      Icons.brightness_4,
                      color: iconColor,
                    ),
                    title: Text(
                      "Theme",
                      style: titleStyle,
                    ),
                    subtitle: Text(
                      themeButtonVal ? "Dark" : "Light",
                      style: subtitleStyle,
                    ),
                    trailing: Switch(
                      value: themeButtonVal,
                      onChanged: (value) {
                        context.read<ThemeCubit>().toggleTheme(value);
                      },
                    ),
                  );
                },
              ),
              // about setting
              CategoryTitle(title: "About App"),
              SettingTile(
                onTap: () {
                  context.push("/privacy");
                },
                leading: Icon(
                  Icons.lock,
                  color: iconColor,
                ),
                title: Text(
                  "Privacy Policy",
                  style: titleStyle,
                ),
              ),
              Gap(),
              SettingTile(
                onTap: () => context.push("/aboutus"),
                leading: Icon(
                  Icons.info,
                  color: iconColor,
                ),
                title: Text(
                  "About Us",
                  style: titleStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget CategoryTitle({required String title}) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Text(
            title,
            style: const TextStyle(color: Color(0xFFE85566), fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget Gap() {
    return const SizedBox(
      height: 15,
    );
  }
}
