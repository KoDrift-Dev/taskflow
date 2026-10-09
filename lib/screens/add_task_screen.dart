import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../theme.dart';
import '../widgets/chips.dart';
import '../widgets/primary_button.dart';

/// Full-screen task composer, opened from the center FAB.
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  TaskCategory _category = TaskCategory.work;
  TaskPriority _priority = TaskPriority.high;
  DateTime _date = DateTime.now();
  TimeOfDay _time = const TimeOfDay(hour: 9, minute: 0);
  String? _assignee;

  static const _members = ['Andi Pratama', 'Budi Santoso', 'Sari Wijaya'];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null) setState(() => _time = picked);
  }

  void _save() {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }
    final provider = context.read<TaskProvider>();
    provider.addTask(
      Task(
        id: 't${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        description: _descCtrl.text.trim(),
        category: _category,
        priority: _priority,
        date: DateTime(_date.year, _date.month, _date.day),
        startMinutes: _time.hour * 60 + _time.minute,
        assignee: _assignee,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Add Task'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FieldLabel(text: 'Task Title', required: true),
            TextField(
              controller: _titleCtrl,
              decoration:
                  const InputDecoration(hintText: 'Enter task title'),
            ),
            const FieldLabel(text: 'Description'),
            TextField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                  hintText: 'Add description (optional)'),
            ),
            const FieldLabel(text: 'Category'),
            DropdownButtonFormField<TaskCategory>(
              initialValue: _category,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.folder_outlined,
                    color: AppColors.grey, size: 20),
              ),
              items: TaskCategory.values
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c.label),
                      ))
                  .toList(),
              onChanged: (c) {
                if (c != null) setState(() => _category = c);
              },
            ),
            const FieldLabel(text: 'Priority'),
            Row(
              children: [
                for (var i = 0; i < TaskPriority.values.length; i++) ...[
                  PriorityPill(
                    priority: TaskPriority.values[i],
                    selected: _priority == TaskPriority.values[i],
                    onTap: () =>
                        setState(() => _priority = TaskPriority.values[i]),
                  ),
                  if (i < TaskPriority.values.length - 1)
                    const SizedBox(width: 10),
                ],
              ],
            ),
            const FieldLabel(text: 'Date & Time'),
            Row(
              children: [
                Expanded(
                  child: _PickerTile(
                    icon: Icons.calendar_month_outlined,
                    label: DateFormat('d MMM yyyy').format(_date),
                    onTap: _pickDate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PickerTile(
                    icon: Icons.schedule_outlined,
                    label: _time.format(context),
                    onTap: _pickTime,
                  ),
                ),
              ],
            ),
            const FieldLabel(text: 'Assigned to'),
            DropdownButtonFormField<String?>(
              initialValue: _assignee,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline_rounded,
                    color: AppColors.grey, size: 20),
                hintText: 'Select member (optional)',
              ),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('Select member (optional)',
                      style: TextStyle(color: AppColors.grey)),
                ),
                ..._members.map((m) => DropdownMenuItem(
                      value: m,
                      child: Text(m),
                    )),
              ],
              onChanged: (v) => setState(() => _assignee = v),
            ),
            const SizedBox(height: 30),
            PrimaryButton(
              label: 'Save',
              icon: Icons.check_rounded,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            Icon(icon, size: 19, color: AppColors.grey),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
