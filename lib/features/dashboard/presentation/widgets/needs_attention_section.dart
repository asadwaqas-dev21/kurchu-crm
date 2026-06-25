import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';

class NeedsAttentionSection extends StatelessWidget {
  const NeedsAttentionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.warning_2, color: AppColors.warning, size: 20),
              const SizedBox(width: 8),
              Text(
                'Needs attention',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAttentionChip(
                  icon: Iconsax.calendar_remove,
                  iconColor: AppColors.error,
                  iconBgColor: const Color(0xFFFCE7F3), // Light pink
                  count: '3',
                  label: 'Bus not booked',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAttentionChip(
                  icon: Iconsax.sms,
                  iconColor: AppColors.warning,
                  iconBgColor: AppColors.iconBgOrange,
                  count: '2',
                  label: 'Confirmation not sent',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAttentionChip(
                  icon: Iconsax.notification_status,
                  iconColor: AppColors.error,
                  iconBgColor: const Color(0xFFFCE7F3),
                  count: '5',
                  label: 'Follow-ups overdue',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttentionChip({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String count,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
