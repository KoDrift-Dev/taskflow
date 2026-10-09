import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../theme.dart';
import '../widgets/primary_button.dart';
import '../widgets/task_row.dart';

/// Home tab: greeting, stats card, quick actions, today's tasks.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final todays = provider.todaysTasks.take(4).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting row
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, Andi',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Let's get things done today!",
                          style: TextStyle(
                              fontSize: 13.5, color: AppColors.grey),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/notifications'),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: cardDecoration(radius: 14),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(Icons.notifications_outlined,
                              color: AppColors.ink, size: 22),
                          Positioned(
                            right: 11,
                            top: 11,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.danger,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Stats card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B78FF), Color(0xFF2F6BFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x402F6BFF),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Tasks',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${provider.totalCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _statChip(
                                Icons.check_rounded,
                                '${provider.doneCount} done',
                              ),
                              const SizedBox(width: 8),
                              _statChip(
                                Icons.schedule_rounded,
                                '${provider.pendingCount} pending',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_rounded,
                          color: Colors.white, size: 34),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Quick actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _QuickAction(
                    label: 'All Tasks',
                    icon: Icons.view_list_rounded,
                    bg: AppColors.primarySoft,
                    fg: AppColors.primary,
                    onTap: () => context.go('/tasks'),
                  ),
                  _QuickAction(
                    label: 'High Priority',
                    icon: Icons.local_fire_department_rounded,
                    bg: AppColors.highBg,
                    fg: AppColors.high,
                    onTap: () => context.go('/tasks?priority=high'),
                  ),
                  _QuickAction(
                    label: 'Calendar',
                    icon: Icons.calendar_month_rounded,
                    bg: AppColors.primarySoft,
                    fg: AppColors.primary,
                    onTap: () => context.go('/calendar'),
                  ),
                  _QuickAction(
                    label: 'Projects',
                    icon: Icons.folder_rounded,
                    bg: const Color(0xFFE7F8EE),
                    fg: const Color(0xFF22C55E),
                    onTap: () => context.push('/projects'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SectionHeader(
                title: "Today's Tasks",
                onSeeAll: () => context.go('/tasks'),
              ),
              const SizedBox(height: 12),
              if (todays.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: cardDecoration(),
                  child: const Text(
                    'No tasks scheduled for today.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.grey, fontSize: 13.5),
                  ),
                )
              else
                ...todays.map((t) => TaskRow(task: t)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 11.5,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.label,
    required this.icon,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: fg, size: 26),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 72,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
