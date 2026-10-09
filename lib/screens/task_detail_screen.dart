import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../theme.dart';
import '../widgets/chips.dart';
import '../widgets/primary_button.dart';

/// Full task detail: meta rows, checklist, mark-as-done action.
class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final task = provider.byId(taskId);

    if (task == null) {
      return Scaffold(
        appBar: AppBar(leading: const BackButton()),
        body: const Center(child: Text('Task not found.')),
      );
    }

    final checklist = task.checklist;
    final checked = checklist.where((c) => c.done).length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(
          task.title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () => _showOptions(context, provider),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryChip(category: task.category),
                  const SizedBox(height: 14),
                  if (task.description.isNotEmpty)
                    Text(
                      task.description,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: AppColors.ink,
                      ),
                    ),
                  const SizedBox(height: 18),
                  _metaRow(
                    Icons.calendar_month_outlined,
                    DateFormat('EEE, d MMM yyyy').format(task.date) +
                        (task.timeLabel.isNotEmpty
                            ? ' · ${task.timeLabel}'
                            : ''),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department_outlined,
                          size: 19, color: AppColors.grey),
                      const SizedBox(width: 12),
                      const Text(
                        'Priority: ',
                        style:
                            TextStyle(fontSize: 13.5, color: AppColors.grey),
                      ),
                      PriorityBadge(priority: task.priority),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _metaRow(
                    Icons.person_outline_rounded,
                    task.assignee == null
                        ? 'Assigned to: Unassigned'
                        : 'Assigned to',
                    trailing: task.assignee == null
                        ? const SizedBox.shrink()
                        : Row(
                            children: [
                              const CircleAvatar(
                                radius: 13,
                                backgroundColor: AppColors.primarySoft,
                                child: Icon(Icons.person_rounded,
                                    size: 15, color: AppColors.primary),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                task.assignee!,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink,
                                ),
                              ),
                            ],
                          ),
                  ),
                  if (checklist.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Checklist',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        Text(
                          '$checked/${checklist.length} done',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(
                      checklist.length,
                      (i) => _ChecklistRow(
                        taskId: task.id,
                        index: i,
                        title: checklist[i].title,
                        done: checklist[i].done,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            child: PrimaryButton(
              label: task.done ? 'Completed' : 'Mark as Done',
              icon: Icons.check_rounded,
              onPressed: task.done
                  ? null
                  : () {
                      provider.toggleDone(task.id);
                      context.pop();
                    },
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaRow(IconData icon, String text,
      {Widget trailing = const SizedBox.shrink()}) {
    return Row(
      children: [
        Icon(icon, size: 19, color: AppColors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13.5, color: AppColors.ink),
          ),
        ),
        trailing,
      ],
    );
  }

  void _showOptions(BuildContext context, TaskProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded,
                    color: AppColors.danger),
                title: const Text('Delete task',
                    style: TextStyle(color: AppColors.danger)),
                onTap: () {
                  provider.deleteTask(taskId);
                  Navigator.of(ctx).pop();
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({
    required this.taskId,
    required this.index,
    required this.title,
    required this.done,
  });

  final String taskId;
  final int index;
  final String title;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TaskProvider>();
    return GestureDetector(
      onTap: () => provider.toggleChecklistItem(taskId, index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: cardDecoration(radius: 14),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: done ? const Color(0xFF22C55E) : Colors.white,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color:
                      done ? const Color(0xFF22C55E) : AppColors.line,
                  width: 1.6,
                ),
              ),
              child: done
                  ? const Icon(Icons.check_rounded,
                      size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: done ? AppColors.grey : AppColors.ink,
                  decoration: done ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}
