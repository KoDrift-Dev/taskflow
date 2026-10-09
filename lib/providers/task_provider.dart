import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_notification.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../theme.dart';

const String _storageKey = 'taskflow_tasks_v1';

/// Central store: tasks CRUD, projects, notifications, persistence.
class TaskProvider extends ChangeNotifier {
  TaskProvider() {
    _seed();
  }

  final List<Task> _tasks = [];
  final List<AppNotification> _notifications = [];

  static const List<Project> projects = [
    Project(
        id: 'app-dev',
        name: 'App Development',
        color: Color(0xFF2F6BFF),
        icon: Icons.folder_rounded),
    Project(
        id: 'ui-ux',
        name: 'UI/UX Design',
        color: Color(0xFFF59E0B),
        icon: Icons.palette_rounded),
    Project(
        id: 'marketing',
        name: 'Marketing',
        color: Color(0xFF8B5CF6),
        icon: Icons.campaign_rounded),
    Project(
        id: 'operations',
        name: 'Operations',
        color: Color(0xFF22C55E),
        icon: Icons.inventory_2_rounded),
  ];

  // ---------- persistence ----------

  Future<void> load() async {
    final prefs = SharedPreferencesAsync();
    final raw = await prefs.getString(_storageKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final list = (jsonDecode(raw) as List)
            .map((e) => Task.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
        _tasks
          ..clear()
          ..addAll(list);
        notifyListeners();
      } catch (_) {
        // Corrupt cache: keep seed data.
      }
    }
  }

  Future<void> _save() async {
    final prefs = SharedPreferencesAsync();
    await prefs.setString(
      _storageKey,
      jsonEncode(_tasks.map((t) => t.toJson()).toList()),
    );
  }

  // ---------- seed ----------

  void _seed() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));
    final plus2 = today.add(const Duration(days: 2));

    _tasks.addAll([
      Task(
        id: 't1',
        title: 'Write weekly report',
        description: 'Summarize this week\'s progress for the team sync.',
        category: TaskCategory.work,
        priority: TaskPriority.high,
        date: today,
        startMinutes: 540,
        endMinutes: 600,
        projectId: 'app-dev',
        done: true,
      ),
      Task(
        id: 't2',
        title: 'Team meeting',
        description: 'Weekly sync with the product team.',
        category: TaskCategory.work,
        priority: TaskPriority.medium,
        date: today,
        startMinutes: 660,
        endMinutes: 720,
        projectId: 'operations',
      ),
      Task(
        id: 't3',
        title: 'UI app design',
        description:
            'Create the app UI design based on the wireframe that has been prepared.',
        category: TaskCategory.design,
        priority: TaskPriority.high,
        date: today,
        startMinutes: 780,
        endMinutes: 900,
        assignee: 'Budi Santoso',
        projectId: 'ui-ux',
        checklist: [
          CheckItem(title: 'Create wireframe', done: true),
          CheckItem(title: 'Design main page', done: true),
          CheckItem(title: 'Design report page'),
          CheckItem(title: 'Review with team'),
        ],
      ),
      Task(
        id: 't4',
        title: 'Buy office supplies',
        description: 'Restock stationery and printer paper.',
        category: TaskCategory.general,
        priority: TaskPriority.low,
        date: today,
        startMinutes: 960,
        endMinutes: 1020,
        projectId: 'operations',
      ),
      Task(
        id: 't5',
        title: 'Code review',
        description: 'Review pull requests from the mobile team.',
        category: TaskCategory.work,
        priority: TaskPriority.medium,
        date: tomorrow,
        startMinutes: 600,
        endMinutes: 660,
        projectId: 'app-dev',
        done: true,
      ),
      Task(
        id: 't6',
        title: 'Research new features',
        description: 'Explore competitor features for Q3 roadmap.',
        category: TaskCategory.research,
        priority: TaskPriority.medium,
        date: tomorrow,
        startMinutes: 840,
        endMinutes: 900,
        projectId: 'app-dev',
      ),
      Task(
        id: 't7',
        title: 'Design landing page',
        description: 'Homepage concept for the new campaign.',
        category: TaskCategory.design,
        priority: TaskPriority.medium,
        date: yesterday,
        startMinutes: 600,
        endMinutes: 720,
        projectId: 'ui-ux',
        done: true,
      ),
      Task(
        id: 't8',
        title: 'Update documentation',
        description: 'Refresh API docs for the v2 release.',
        category: TaskCategory.general,
        priority: TaskPriority.low,
        date: tomorrow,
        startMinutes: 960,
        endMinutes: 1020,
        projectId: 'operations',
      ),
      Task(
        id: 't9',
        title: 'Fix login bug',
        description: 'Resolve the session timeout issue on Android.',
        category: TaskCategory.work,
        priority: TaskPriority.high,
        date: yesterday,
        startMinutes: 840,
        endMinutes: 960,
        projectId: 'app-dev',
        done: true,
      ),
      Task(
        id: 't10',
        title: 'Prepare presentation',
        description: 'Slides for the stakeholder review.',
        category: TaskCategory.work,
        priority: TaskPriority.medium,
        date: plus2,
        startMinutes: 600,
        endMinutes: 720,
        projectId: 'marketing',
      ),
      Task(
        id: 't11',
        title: 'Review pull requests',
        description: 'Backend PRs awaiting approval.',
        category: TaskCategory.work,
        priority: TaskPriority.low,
        date: yesterday,
        startMinutes: 1020,
        endMinutes: 1080,
        projectId: 'app-dev',
        done: true,
      ),
      Task(
        id: 't12',
        title: 'Client feedback call',
        description: 'Walkthrough of the latest prototype.',
        category: TaskCategory.general,
        priority: TaskPriority.medium,
        date: plus2,
        startMinutes: 840,
        endMinutes: 900,
        projectId: 'marketing',
      ),
    ]);

    _notifications.addAll(const [
      AppNotification(
        id: 'n1',
        title: 'Task completed',
        subtitle: 'UI app design is complete',
        timeAgo: '10m',
        icon: Icons.check_circle_rounded,
        color: Color(0xFF22C55E),
        kind: NotifKind.task,
      ),
      AppNotification(
        id: 'n2',
        title: 'Task assigned',
        subtitle: 'You were assigned to Team meeting',
        timeAgo: '1h',
        icon: Icons.person_rounded,
        color: AppColors.primary,
        kind: NotifKind.task,
      ),
      AppNotification(
        id: 'n3',
        title: 'Reminder',
        subtitle: 'Team meeting starts in 15 minutes',
        timeAgo: '2h',
        icon: Icons.notifications_rounded,
        color: Color(0xFF8B5CF6),
        kind: NotifKind.task,
      ),
      AppNotification(
        id: 'n4',
        title: 'Task cancelled',
        subtitle: 'Buy office supplies was cancelled',
        timeAgo: '3h',
        icon: Icons.cancel_rounded,
        color: Color(0xFFEF4444),
        kind: NotifKind.task,
      ),
      AppNotification(
        id: 'n5',
        title: 'Project update',
        subtitle: 'App Development project status updated',
        timeAgo: '5h',
        icon: Icons.folder_rounded,
        color: AppColors.primary,
        kind: NotifKind.system,
      ),
    ]);
  }

  // ---------- reads ----------

  List<Task> get tasks => List.unmodifiable(_tasks);

  int get totalCount => _tasks.length;
  int get doneCount => _tasks.where((t) => t.done).length;
  int get pendingCount => totalCount - doneCount;

  List<AppNotification> get notifications =>
      List.unmodifiable(_notifications);

  Task? byId(String id) {
    for (final t in _tasks) {
      if (t.id == id) return t;
    }
    return null;
  }

  List<Task> tasksForDay(DateTime day) {
    final list = _tasks.where((t) {
      return t.date.year == day.year &&
          t.date.month == day.month &&
          t.date.day == day.day;
    }).toList()
      ..sort((a, b) => (a.startMinutes ?? 1440).compareTo(b.startMinutes ?? 1440));
    return list;
  }

  List<Task> get todaysTasks => tasksForDay(DateTime.now());

  int projectTotal(String projectId) =>
      _tasks.where((t) => t.projectId == projectId).length;

  int projectDone(String projectId) =>
      _tasks.where((t) => t.projectId == projectId && t.done).length;

  // ---------- mutations ----------

  void addTask(Task task) {
    _tasks.add(task);
    _save();
    notifyListeners();
  }

  void toggleDone(String id) {
    final task = byId(id);
    if (task == null) return;
    task.done = !task.done;
    _save();
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    _save();
    notifyListeners();
  }

  void updateTask(Task updated) {
    final i = _tasks.indexWhere((t) => t.id == updated.id);
    if (i == -1) return;
    _tasks[i] = updated;
    _save();
    notifyListeners();
  }

  void toggleChecklistItem(String taskId, int index) {
    final task = byId(taskId);
    if (task == null || index >= task.checklist.length) return;
    final item = task.checklist[index];
    item.done = !item.done;
    _save();
    notifyListeners();
  }
}
