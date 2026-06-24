import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';

class RecentBookings extends StatelessWidget {
  const RecentBookings({Key? key}) : super(key: key);

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
            children: [
              const Icon(Iconsax.timer_1, color: AppColors.textPrimary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Recent Bookings',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                _buildBookingItem(
                  context,
                  name: 'Kunal Patel',
                  destination: 'Manali Trip',
                  amount: 'PKR 25,000',
                  status: 'Confirmed',
                  statusColor: AppColors.success,
                  statusBgColor: AppColors.iconBgGreen,
                ),
                const Divider(color: AppColors.border, height: 24),
                _buildBookingItem(
                  context,
                  name: 'Ankita Singh',
                  destination: 'Goa Getaway',
                  amount: 'PKR 10,000',
                  status: 'Pending',
                  statusColor: AppColors.warning,
                  statusBgColor: AppColors.iconBgOrange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingItem(BuildContext context, {required String name, required String destination, required String amount, required String status, required Color statusColor, required Color statusBgColor}) {
    final initials = name.split(' ').map((e) => e[0]).take(2).join('');
    
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.iconBgPurple,
          child: Text(
            initials,
            style: const TextStyle(fontSize: 12, color: AppColors.iconPurple, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                destination,
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statusBgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
