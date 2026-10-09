import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../theme.dart';

/// Profile tab: user card, stats, settings menu, logout.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            children: [
              // User card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: cardDecoration(),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.primarySoft,
                      child: Icon(Icons.person_rounded,
                          size: 34, color: AppColors.primary),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Andi Pratama',
                            style: TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'andi@example.com',
                            style: TextStyle(
                                fontSize: 13, color: AppColors.grey),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/info/account'),
                      child: const Icon(Icons.edit_outlined,
                          color: AppColors.grey, size: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Stats
              Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: cardDecoration(),
                child: Row(
                  children: [
                    _stat('${provider.totalCount}', 'Total Tasks'),
                    _divider(),
                    _stat('${provider.doneCount}', 'Done'),
                    _divider(),
                    _stat('${provider.pendingCount}', 'Pending'),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Menu
              Container(
                decoration: cardDecoration(),
                child: Column(
                  children: [
                    _MenuRow(
                      icon: Icons.person_outline_rounded,
                      label: 'Account Info',
                      onTap: () => context.push('/info/account'),
                    ),
                    _MenuRow(
                      icon: Icons.notifications_outlined,
                      label: 'Notifications',
                      badge: '2',
                      onTap: () => context.push('/notifications'),
                    ),
                    _MenuRow(
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      onTap: () => context.push('/info/settings'),
                    ),
                    _MenuRow(
                      icon: Icons.help_outline_rounded,
                      label: 'Help & FAQ',
                      onTap: () => context.push('/info/help'),
                    ),
                    _MenuRow(
                      icon: Icons.info_outline_rounded,
                      label: 'About App',
                      showDivider: false,
                      onTap: () => context.push('/info/about'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Logout
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => _confirmLogout(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(
                        color: AppColors.danger, width: 1.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded, size: 19),
                      SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style:
                const TextStyle(fontSize: 12, color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 36, color: AppColors.line);
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout?'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/login');
            },
            child: const Text('Logout',
                style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? badge;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          title: Text(
            label,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: const BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.grey, size: 22),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, indent: 68, color: AppColors.line),
      ],
    );
  }
}
