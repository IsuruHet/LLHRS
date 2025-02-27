import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv/blocs/authentication/authentication_bloc.dart';
import 'package:reserv/blocs/internet/internet_cubit.dart';
import 'package:reserv/blocs/login/login_bloc.dart';
import 'package:reserv/blocs/notification/notification_cubit.dart';
import 'package:reserv/blocs/register/register_bloc.dart';
import 'package:reserv/blocs/reschedule/reschedule_cubit.dart';
import 'package:reserv/blocs/sessions_prefs/sessions_preference_cubit.dart';
import 'package:reserv/blocs/theme/theme_cubit.dart';
import 'package:reserv/configs/sessions_details.dart';
import 'package:reserv/firebase_options.dart';
import 'package:reserv/helpers/notification_helper.dart';
import 'package:reserv/helpers/sessions_prefs.dart';
import 'package:reserv/helpers/theme_helper.dart';
import 'package:reserv/repositories/authentication_repository.dart';
import 'package:reserv/repositories/notificatio_repo.dart';
import 'package:reserv/repositories/rechedule_repo.dart';
import 'package:reserv/repositories/theme_repo.dart';
import 'package:reserv/repositories/user_repo.dart';
import 'package:reserv/routes/routes.dart';
import 'package:reserv/services/api_service.dart';
import 'package:reserv/services/session_service.dart';
import 'package:reserv/utils/themes.dart';
import 'package:reserv/views/startup_page/startup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // theme and notification helpers
  final bool initThemeStatus = await ThemeHelper.getinitialThemePreferece();
  final bool initNotificatioStatus =
      await NotificationHelper.getinitialNotificationStatus();
  // get token
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");
  ApiService instance = ApiService.instance;
  instance.configurationDio(
      baseUrl: "https://llhrs-backend-render.onrender.com", token: token);

  // get focus area
  final area = await SessionsPrefs.getinitialSessionPrefStatus();
  // run app
  runApp(MainApp(
    initThemeStatus: initThemeStatus,
    initNotificatioStatus: initNotificatioStatus,
    area: area,
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({
    super.key,
    required this.initThemeStatus,
    required this.initNotificatioStatus,
    required this.area,
  });
  final bool initThemeStatus;
  final bool initNotificatioStatus;
  final FocusArea area;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void dispose() {
    BlocProvider.of<InternetCubit>(context).cancelSubscription();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider(
          create: (context) =>
              ThemeRepository(initThemeStatus: widget.initThemeStatus),
        ),
        RepositoryProvider(
          create: (context) => NotificationRepository(
              notificatioStatus: widget.initNotificatioStatus),
        ),
        RepositoryProvider(create: (context) => AuthenticationRepository()),
        RepositoryProvider(create: (context) => UserRepository()),
        RepositoryProvider(create: (context) => SessionService()),
        RepositoryProvider(create: (context) => RecheduleRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                ThemeCubit(themeRepository: context.read<ThemeRepository>()),
          ),
          BlocProvider(
            create: (context) => NotificationCubit(
                notificationRepository: context.read<NotificationRepository>()),
          ),
          BlocProvider(
            create: (context) => AuthenticationBloc(
              authenticationRepository:
                  context.read<AuthenticationRepository>(),
              userRepository: context.read<UserRepository>(),
            )..add(AuthenticationSubscriptionRequested()),
          ),
          BlocProvider(
            create: (context) => LoginBloc(
              authenticationRepository:
                  context.read<AuthenticationRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => RegisterBloc(
              authenticationRepository:
                  context.read<AuthenticationRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => SessionsPreferenceCubit(area: widget.area),
          ),
          BlocProvider(
            create: (context) =>
                RescheduleCubit(context.read<RecheduleRepository>()),
          ),
          BlocProvider(
            create: (context) => InternetCubit()..subcribeToInternet(),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            bool themeStatus = false;
            if (state is ThemeInitial) {
              themeStatus = state.isDark;
            }
            if (state is ThemeToggleState) {
              themeStatus = state.isDark;
            }
            return BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state.status == AuthenticationStatus.authenticated) {
                  return MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    routerConfig: router,
                    theme: themeStatus ? darkTheme : lightTheme,
                  );
                }
                if (state.status == AuthenticationStatus.unauthenticated) {
                  return MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    routerConfig: startupRoutes,
                    theme: themeStatus ? darkTheme : lightTheme,
                  );
                }
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: themeStatus ? darkTheme : lightTheme,
                  home: const StartupPage(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
