import 'package:flutter/material.dart';

enum NotifKind { task, system }

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    required this.icon,
    required this.color,
    required this.kind,
  });

  final String id;
  final String title;
  final String subtitle;
  final String timeAgo;
  final IconData icon;
  final Color color;
  final NotifKind kind;
}
