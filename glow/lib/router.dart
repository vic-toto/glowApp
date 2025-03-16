import 'package:go_router/go_router.dart';
import 'package:template/main.dart';
import 'package:template/src/views/splash_view.dart';
import 'package:template/src/views/calendar/calendar_view.dart';
import 'package:template/src/views/dashboard/dashboard_view.dart';
import 'package:template/src/views/resources/resources_view.dart';
import 'package:template/src/views/investors/investors_view.dart';
import 'package:template/src/views/founders/founders_view.dart';
import 'package:template/src/views/auth/login_view.dart';
import 'package:template/src/views/auth/signup_view.dart';
import 'package:template/src/views/contact/contact_view.dart';
import 'package:template/src/views/profile/edit_profile_view.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => NoTransitionPage(
        child: const SplashView(),
      ),
      redirect: (context, state) => '/login',
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => NoTransitionPage(
        child: const LoginView(),
      ),
    ),
    GoRoute(
      path: '/signup',
      pageBuilder: (context, state) => NoTransitionPage(
        child: const SignUpView(),
      ),
    ),
    GoRoute(
      path: '/dashboard',
      pageBuilder: (context, state) => NoTransitionPage(
        child: const DashboardView(),
      ),
    ),
    GoRoute(
      path: '/calendar',
      pageBuilder: (context, state) => NoTransitionPage(
        child: const CalendarView(),
      ),
    ),
    GoRoute(
      path: '/resources',
      pageBuilder: (context, state) => NoTransitionPage(
        child: const ResourcesView(),
      ),
    ),
    GoRoute(
      path: '/investors',
      pageBuilder: (context, state) => NoTransitionPage(
        child: const InvestorsView(),
      ),
    ),
    GoRoute(
      path: '/founders',
      pageBuilder: (context, state) => NoTransitionPage(
        child: const FoundersView(),
      ),
    ),
    GoRoute(
      path: '/contact',
      pageBuilder: (context, state) => NoTransitionPage(
        child: const ContactView(),
      ),
    ),
    GoRoute(
      path: '/edit-profile',
      pageBuilder: (context, state) => NoTransitionPage(
        child: const EditProfileView(),
      ),
    ),
  ],
);