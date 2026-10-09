import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../theme.dart';
import '../widgets/task_row.dart';

enum _Tab { all, pending, done }

/// Tasks tab: search, status tabs, filterable task list.
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key, this.priorityFilter});

  /// When set (via ?priority=high), only matching pending tasks are shown.
  final TaskPriority? priorityFilter;

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  _Tab _tab = _Tab.all;
  String _query = '';
  TaskCategory? _categoryFilter;

  List<Task> _filtered(List<Task> tasks) {
    var list = tasks;
    if (widget.priorityFilter != null) {
      list = list
          .where((t) =>
              !t.done && t.priority == widget.priorityFilter)
          .toList();
    } else {
      switch (_tab) {
        case _Tab.pending:
          list = list.where((t) => !t.done).toList();
          break;
        case _Tab.done:
          list = list.where((t) => t.done).toList();
          break;
        case _Tab.all:
          break;
      }
    }
    if (_categoryFilter != null) {
      list = list.where((t) => t.category == _categoryFilter).toList();
    }
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list.where((t) => t.title.toLowerCase().contains(q)).toList();
    }
    list.sort((a, b) {
      final d = a.date.compareTo(b.date);
      if (d != 0) return d;
      return (a.startMinutes ?? 1440).compareTo(b.startMinutes ?? 1440);
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final tasks = _filtered(provider.tasks);
    final isPriorityView = widget.priorityFilter != null;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      isPriorityView ? 'High Priority' : 'Tasks',
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  _iconBtn(Icons.search_rounded, () => _showSearch(context)),
                  const SizedBox(width: 10),
                  _iconBtn(Icons.tune_rounded, () => _showFilter(context)),
                ],
              ),
            ),
            if (!isPriorityView) ...[
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _Tabs(
                  tab: _tab,
                  onChanged: (t) => setState(() => _tab = t),
                ),
              ),
            ],
            if (_categoryFilter != null) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => setState(() => _categoryFilter = null),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _categoryFilter!.label,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.close_rounded,
                              size: 14, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Expanded(
              child: tasks.isEmpty
                  ? const Center(
                      child: Text(
                        'No tasks found.',
                        style:
                            TextStyle(color: AppColors.grey, fontSize: 14),
                      ),
                    )
                  : ListView.builder(
                      padding:
                          const EdgeInsets.fromLTRB(20, 4, 20, 24),
                      itemCount: tasks.length,
                      itemBuilder: (_, i) =>
                          TaskRow(task: tasks[i], showDayPrefix: true),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: cardDecoration(radius: 14),
        child: Icon(icon, color: AppColors.ink, size: 21),
      ),
    );
  }

  void _showSearch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Search tasks',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Type to search...',
                prefixIcon: Icon(Icons.search_rounded),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Filter by category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _filterChip(ctx, null, 'All'),
                for (final c in TaskCategory.values)
                  _filterChip(ctx, c, c.label),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(BuildContext ctx, TaskCategory? value, String label) {
    final selected = _categoryFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() => _categoryFilter = value);
        Navigator.of(ctx).pop();
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
              color: selected ? AppColors.primary : AppColors.line),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.ink,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.tab, required this.onChanged});

  final _Tab tab;
  final ValueChanged<_Tab> onChanged;

  @override
  Widget build(BuildContext context) {
    const labels = ['All', 'Pending', 'Done'];
    const values = [_Tab.all, _Tab.pending, _Tab.done];
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
                    color: tab == values[i]
                        ? AppColors.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    labels[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: tab == values[i]
                          ? Colors.white
                          : AppColors.grey,
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
