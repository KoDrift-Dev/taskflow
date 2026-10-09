import 'package:go_router/go_router.dart';

import 'models/task.dart';
import 'screens/add_task_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/home_screen.dart';
import 'screens/info_screen.dart';
import 'screens/login_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/projects_screen.dart';
import 'screens/task_detail_screen.dart';
import 'screens/tasks_screen.dart';
import 'widgets/main_scaffold.dart';

/// App navigation:
///
/// /onboarding -> /login -> /(home|tasks|calendar|profile) [bottom tabs]
/// overlays: /add, /task/:id, /projects, /notifications, /info/:key
final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/tasks',
              builder: (context, state) {
                final raw = state.uri.queryParameters['priority'];
                final priority = raw == 'high' ? TaskPriority.high : null;
                return TasksScreen(priorityFilter: priority);
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/calendar',
              builder: (context, state) => const CalendarScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/add',
      builder: (context, state) => const AddTaskScreen(),
    ),
    GoRoute(
      path: '/task/:id',
      builder: (context, state) =>
          TaskDetailScreen(taskId: state.pathParameters['id'] ?? ''),
    ),
    GoRoute(
      path: '/projects',
      builder: (context, state) => const ProjectsScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/info/:key',
      builder: (context, state) =>
          InfoScreen(pageKey: state.pathParameters['key'] ?? ''),
    ),
  ],
);
