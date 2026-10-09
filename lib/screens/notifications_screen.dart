import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/app_notification.dart';
import '../providers/task_provider.dart';
import '../theme.dart';

enum _NotifTab { all, tasks, system }

/// Notifications: tabbed list of task and system updates.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  _NotifTab _tab = _NotifTab.all;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final items = provider.notifications.where((n) {
      switch (_tab) {
        case _NotifTab.all:
          return true;
        case _NotifTab.tasks:
          return n.kind == NotifKind.task;
        case _NotifTab.system:
          return n.kind == NotifKind.system;
      }
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Notifications'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: _Tabs(
              tab: _tab,
              onChanged: (t) => setState(() => _tab = t),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text(
                      'No notifications.',
                      style: TextStyle(color: AppColors.grey, fontSize: 14),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    itemCount: items.length,
                    itemBuilder: (_, i) => _NotifRow(item: items[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _NotifRow extends StatelessWidget {
  const _NotifRow({required this.item});

  final AppNotification item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: cardDecoration(radius: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(item.icon, color: item.color, size: 22),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                      fontSize: 12.5, color: AppColors.grey, height: 1.4),
                ),
              ],
            ),
          ),
          Text(
            item.timeAgo,
            style:
                const TextStyle(fontSize: 11.5, color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.tab, required this.onChanged});

  final _NotifTab tab;
  final ValueChanged<_NotifTab> onChanged;

  @override
  Widget build(BuildContext context) {
    const labels = ['All', 'Tasks', 'System'];
    const values = [_NotifTab.all, _NotifTab.tasks, _NotifTab.system];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          for (var i = 0; i < values.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(values[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color:
                        tab == values[i] ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: tab == values[i] ? Colors.white : AppColors.grey,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
