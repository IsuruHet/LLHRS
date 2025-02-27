import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reserv/blocs/authentication/authentication_bloc.dart';
import 'package:reserv/models/session.dart';
import 'package:reserv/repositories/authentication_repository.dart';
import 'package:reserv/views/about_us/about_us.dart';
import 'package:reserv/views/available_reschedules/reschedule_available_check.dart';
import 'package:reserv/views/onboarding/onboard.dart';
import 'package:reserv/views/privacy/privacy_policy.dart';
import 'package:reserv/views/profile/profile_page.dart';
import 'package:reserv/views/home/home_page.dart';
import 'package:reserv/views/notification/notifications_page.dart';
import 'package:reserv/views/register_page/register_page.dart';
import 'package:reserv/views/sign_in/sign_in_page.dart';
import 'package:reserv/views/startup_page/welcome_page.dart';

final router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: "/register",
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: "/",
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: "/notifications",
      builder: (context, state) => NotificationsPage(),
    ),
    GoRoute(
      path: "/signup",
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: "/profile",
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: "/welcome",
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: "/search-available",
      builder: (context, state) => RescheduleAvailableCheck(
        session: state.extra as Session,
      ),
    ),
    GoRoute(
      path: "/aboutus",
      builder: (context, state) => const AboutUs(),
    ),
    GoRoute(
      path: "/privacy",
      builder: (context, state) => const PrivacyPolicy(),
    ),
  ],
);

final startupRoutes = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const OnboardTour(),
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) {
    final states = context.watch<AuthenticationBloc>().state;

    if (states.status == AuthenticationStatus.unauthenticated) {
      return '/';
    } else {
      return null;
    }
  },
);
