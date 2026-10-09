import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../theme.dart';
import 'chips.dart';

/// A single task row card used on Home, Tasks and Calendar screens.
class TaskRow extends StatelessWidget {
  const TaskRow({super.key, required this.task, this.showDayPrefix = false});

  final Task task;
  final bool showDayPrefix;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TaskProvider>();
    return GestureDetector(
      onTap: () => context.push('/task/${task.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: cardDecoration(radius: 16),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => provider.toggleDone(task.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: task.done ? const Color(0xFF22C55E) : Colors.white,
                  border: Border.all(
                    color: task.done
                        ? const Color(0xFF22C55E)
                        : AppColors.line,
                    width: 1.6,
                  ),
                ),
                child: task.done
                    ? const Icon(Icons.check_rounded,
                        size: 15, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                      decoration:
                          task.done ? TextDecoration.lineThrough : null,
                      decorationColor: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    showDayPrefix ? task.dayLabel() : task.timeLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            CategoryChip(category: task.category),
          ],
        ),
      ),
    );
  }
}
