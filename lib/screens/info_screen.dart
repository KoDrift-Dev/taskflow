import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';

/// Generic detail page behind Profile menu rows (account, settings, help, about).
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key, required this.pageKey});

  final String pageKey;

  static const _content = {
    'account': (
      title: 'Account Info',
      body: 'Andi Pratama\nandi@example.com\n\n'
          'Member since January 2025.\nPlan: Free — upgrade anytime to unlock unlimited projects and team workspaces.',
    ),
    'settings': (
      title: 'Settings',
      body: 'Notifications: On\n'
          'Reminder lead time: 15 minutes\n'
          'Week starts on: Monday\n'
          'Theme: System default\n\n'
          'Changes apply instantly across all your devices.',
    ),
    'help': (
      title: 'Help & FAQ',
      body: 'How do I add a task?\n'
          'Tap the + button in the bottom bar, fill in the details and hit Save.\n\n'
          'How do priorities work?\n'
          'Low, Medium and High help you sort what matters most. Use the High Priority shortcut on Home to see urgent items.\n\n'
          'Is my data backed up?\n'
          'Tasks are stored on this device. Sign in to sync them everywhere.',
    ),
    'about': (
      title: 'About App',
      body: 'TaskFlow 1.0.0\n\n'
          'Manage tasks, achieve goals, be more productive every day.\n\n'
          'Crafted with care by the TaskFlow team.',
    ),
  };

  @override
  Widget build(BuildContext context) {
    final data = _content[pageKey] ??
        (title: 'Info', body: 'Nothing to show here yet.');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(data.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: cardDecoration(),
          child: Text(
            data.body,
            style: const TextStyle(
              fontSize: 14,
              height: 1.75,
              color: AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}
