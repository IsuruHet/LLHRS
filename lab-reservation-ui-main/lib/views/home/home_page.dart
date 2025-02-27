import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv/blocs/internet/internet_cubit.dart';
import 'package:reserv/blocs/notification/notification_cubit.dart';
import 'package:reserv/views/home_page/home.dart';
import 'package:reserv/views/postponed/postponed_page.dart';
import 'package:reserv/views/scheduling/shedule_page.dart';
import 'package:reserv/views/settings/setting_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  final List<Widget> _pages = [
    NavigatorPage(
        navigatorKey: GlobalKey<NavigatorState>(), child: const Home()),
    NavigatorPage(
        navigatorKey: GlobalKey<NavigatorState>(),
        child: const PostponedPage()),
    NavigatorPage(
        navigatorKey: GlobalKey<NavigatorState>(), child: const SchedulePage()),
    NavigatorPage(
        navigatorKey: GlobalKey<NavigatorState>(), child: const SettingsPage()),
  ];

  final List<NavigationDestination> _navList = [
    const NavigationDestination(
      icon: Icon(Icons.home, color: Colors.white),
      label: "Home",
    ),
    const NavigationDestination(
      icon: Icon(Icons.schedule, color: Colors.white),
      label: "Postpone",
    ),
    const NavigationDestination(
      icon: Icon(Icons.calendar_month, color: Colors.white),
      label: "Calendar",
    ),
    const NavigationDestination(
      icon: Icon(Icons.settings, color: Colors.white),
      label: "Settings",
    ),
  ];

  @override
  void initState() {
    context.read<NotificationCubit>().onTokenRefresh();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    final isFirstRouteInCurrentTab =
        !await _navigatorKeys[currentPageIndex].currentState!.maybePop();
    if (isFirstRouteInCurrentTab) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternetCubit, InternetState>(
      builder: (context, state) {
        if (state.status == InternetStatus.disconnected) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off,
                    color: Colors.red,
                    size: 40,
                  ),
                  Text(
                    "No Internet Connection",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Please check your internet connection and try again",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        }
        return PopScope(
          onPopInvoked: (bool isPopInvoked) {
            _onWillPop();
          },
          child: Scaffold(
            bottomNavigationBar: NavigationBarTheme(
              data: const NavigationBarThemeData(
                labelTextStyle: WidgetStatePropertyAll(
                  TextStyle(color: Colors.white),
                ),
              ),
              child: NavigationBar(
                height: 60,
                onDestinationSelected: (value) {
                  setState(() {
                    currentPageIndex = value;
                  });
                },
                destinations: _navList,
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                animationDuration: const Duration(milliseconds: 300),
                selectedIndex: currentPageIndex,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              ),
            ),
            body: IndexedStack(
              index: currentPageIndex,
              children: _pages.map((page) {
                return NavigatorPage(
                  navigatorKey: _navigatorKeys[_pages.indexOf(page)],
                  child: page,
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class NavigatorPage extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  const NavigatorPage(
      {super.key, required this.navigatorKey, required this.child});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => child,
        );
      },
    );
  }
}
