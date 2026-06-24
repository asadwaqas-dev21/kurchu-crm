import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';

class UpcomingFollowUps extends StatelessWidget {
  const UpcomingFollowUps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Iconsax.arrow_right_1, color: AppColors.textPrimary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Upcoming Follow-ups',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Text(
                'View all',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildFollowUpItem(
                  context,
                  name: 'Rohit Sharma',
                  time: 'Today, 11:00 AM',
                  type: 'Call',
                  typeColor: AppColors.textSecondary,
                  typeBgColor: AppColors.background,
                ),
                const Divider(color: AppColors.border, height: 24),
                _buildFollowUpItem(
                  context,
                  name: 'Neha Verma',
                  time: 'Today, 12:30 PM',
                  type: 'Meeting',
                  typeColor: AppColors.textSecondary,
                  typeBgColor: AppColors.background,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowUpItem(BuildContext context, {required String name, required String time, required String type, required Color typeColor, required Color typeBgColor}) {
    final initials = name.split(' ').map((e) => e[0]).take(2).join('');
    
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.iconBgBlue,
          child: Text(
            initials,
            style: const TextStyle(fontSize: 12, color: AppColors.iconBlue, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            time,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: typeBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            type,
            style: TextStyle(fontSize: 11, color: typeColor, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
