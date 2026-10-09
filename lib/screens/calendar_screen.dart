import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../theme.dart';
import '../widgets/primary_button.dart';
import '../widgets/task_row.dart';

/// Calendar tab: month grid + schedule for the selected day.
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _month;
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
    _selected = DateTime(now.year, now.month, now.day);
  }

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  List<DateTime?> _gridDays() {
    final first = DateTime(_month.year, _month.month, 1);
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    // Monday-first offset
    final offset = (first.weekday - 1) % 7;
    final cells = <DateTime?>[];
    for (var i = 0; i < offset; i++) {
      cells.add(null);
    }
    for (var d = 1; d <= daysInMonth; d++) {
      cells.add(DateTime(_month.year, _month.month, d));
    }
    return cells;
  }

  bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  bool _hasTasks(DateTime d, TaskProvider provider) =>
      provider.tasksForDay(d).isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final days = _gridDays();
    final schedule = provider.tasksForDay(_selected);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Calendar',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: cardDecoration(),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _monthBtn(Icons.chevron_left_rounded, -1),
                        Text(
                          DateFormat('MMMM yyyy').format(_month),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        _monthBtn(Icons.chevron_right_rounded, 1),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: _weekdays
                          .map((w) => Expanded(
                                child: Text(
                                  w,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.grey,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                      ),
                      itemCount: days.length,
                      itemBuilder: (_, i) {
                        final d = days[i];
                        if (d == null) return const SizedBox.shrink();
                        final selected = d.year == _selected.year &&
                            d.month == _selected.month &&
                            d.day == _selected.day;
                        final today = _isToday(d);
                        final has = _hasTasks(d, provider);
                        return GestureDetector(
                          onTap: () => setState(() => _selected = d),
                          child: Container(
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary
                                  : today
                                      ? AppColors.primarySoft
                                      : Colors.transparent,
                              shape: BoxShape.circle,
                              border: today && !selected
                                  ? Border.all(
                                      color: AppColors.primary, width: 1.4)
                                  : null,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  '${d.day}',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: selected || today
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: selected
                                        ? Colors.white
                                        : today
                                            ? AppColors.primary
                                            : AppColors.ink,
                                  ),
                                ),
                                if (has && !selected)
                                  Positioned(
                                    bottom: 6,
                                    child: Container(
                                      width: 4,
                                      height: 4,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const SectionHeader(title: "Today's Schedule"),
              const SizedBox(height: 12),
              if (schedule.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: cardDecoration(),
                  child: const Text(
                    'Nothing scheduled for this day.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.grey, fontSize: 13.5),
                  ),
                )
              else
                ...schedule.map((t) => TaskRow(task: t)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _monthBtn(IconData icon, int delta) {
    return GestureDetector(
      onTap: () => setState(() {
        _month = DateTime(_month.year, _month.month + delta);
      }),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.ink, size: 20),
      ),
    );
  }
}
