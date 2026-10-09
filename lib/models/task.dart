import 'package:flutter/material.dart';
import '../theme.dart';

enum TaskCategory { work, design, general, research }

enum TaskPriority { low, medium, high }

extension TaskCategoryX on TaskCategory {
  String get label => switch (this) {
        TaskCategory.work => 'Work',
        TaskCategory.design => 'Design',
        TaskCategory.general => 'General',
        TaskCategory.research => 'Research',
      };

  Color get color => switch (this) {
        TaskCategory.work => AppColors.work,
        TaskCategory.design => AppColors.design,
        TaskCategory.general => AppColors.general,
        TaskCategory.research => AppColors.research,
      };

  Color get bg => switch (this) {
        TaskCategory.work => AppColors.workBg,
        TaskCategory.design => AppColors.designBg,
        TaskCategory.general => AppColors.generalBg,
        TaskCategory.research => AppColors.researchBg,
      };

  static TaskCategory fromName(String name) => TaskCategory.values.firstWhere(
        (c) => c.name == name,
        orElse: () => TaskCategory.work,
      );
}

extension TaskPriorityX on TaskPriority {
  String get label => switch (this) {
        TaskPriority.low => 'Low',
        TaskPriority.medium => 'Medium',
        TaskPriority.high => 'High',
      };

  Color get color => switch (this) {
        TaskPriority.low => AppColors.low,
        TaskPriority.medium => AppColors.medium,
        TaskPriority.high => AppColors.high,
      };

  Color get bg => switch (this) {
        TaskPriority.low => AppColors.lowBg,
        TaskPriority.medium => AppColors.mediumBg,
        TaskPriority.high => AppColors.highBg,
      };

  IconData get icon => switch (this) {
        TaskPriority.low => Icons.arrow_downward_rounded,
        TaskPriority.medium => Icons.arrow_forward_rounded,
        TaskPriority.high => Icons.local_fire_department_rounded,
      };

  static TaskPriority fromName(String name) => TaskPriority.values.firstWhere(
        (p) => p.name == name,
        orElse: () => TaskPriority.medium,
      );
}

class CheckItem {
  CheckItem({required this.title, this.done = false});

  String title;
  bool done;

  Map<String, dynamic> toJson() => {'title': title, 'done': done};

  factory CheckItem.fromJson(Map<String, dynamic> json) => CheckItem(
        title: json['title'] as String? ?? '',
        done: json['done'] as bool? ?? false,
      );
}

class Task {
  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.category = TaskCategory.work,
    this.priority = TaskPriority.medium,
    required this.date,
    this.startMinutes,
    this.endMinutes,
    this.assignee,
    this.projectId,
    this.done = false,
    List<CheckItem>? checklist,
  }) : checklist = checklist ?? [];

  final String id;
  String title;
  String description;
  TaskCategory category;
  TaskPriority priority;
  DateTime date;
  int? startMinutes;
  int? endMinutes;
  String? assignee;
  String? projectId;
  bool done;
  List<CheckItem> checklist;

  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String get timeLabel {
    String fmt(int m) =>
        '${(m ~/ 60).toString().padLeft(2, '0')}:${(m % 60).toString().padLeft(2, '0')}';
    if (startMinutes == null) return '';
    if (endMinutes == null) return fmt(startMinutes!);
    return '${fmt(startMinutes!)} - ${fmt(endMinutes!)}';
  }

  /// "Today · 09:00" style subtitle used in lists.
  String dayLabel() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final diff = day.difference(today).inDays;
    final prefix = diff == 0
        ? 'Today'
        : diff == 1
            ? 'Tomorrow'
            : diff == -1
                ? 'Yesterday'
                : '${date.day}/${date.month}/${date.year}';
    return timeLabel.isEmpty ? prefix : '$prefix · ${fmtShort(startMinutes!)}';
  }

  static String fmtShort(int m) =>
      '${(m ~/ 60).toString().padLeft(2, '0')}:${(m % 60).toString().padLeft(2, '0')}';

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category.name,
        'priority': priority.name,
        'date': date.toIso8601String(),
        'startMinutes': startMinutes,
        'endMinutes': endMinutes,
        'assignee': assignee,
        'projectId': projectId,
        'done': done,
        'checklist': checklist.map((c) => c.toJson()).toList(),
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as String? ?? UniqueKey().toString(),
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        category:
            TaskCategoryX.fromName(json['category'] as String? ?? 'work'),
        priority:
            TaskPriorityX.fromName(json['priority'] as String? ?? 'medium'),
        date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
        startMinutes: json['startMinutes'] as int?,
        endMinutes: json['endMinutes'] as int?,
        assignee: json['assignee'] as String?,
        projectId: json['projectId'] as String?,
        done: json['done'] as bool? ?? false,
        checklist: ((json['checklist'] as List?) ?? [])
            .map((e) => CheckItem.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );
}
