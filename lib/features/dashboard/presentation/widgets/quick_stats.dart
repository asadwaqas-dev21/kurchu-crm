import 'package:flutter/material.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/today_stats.dart';

class QuickStats extends StatelessWidget {
  final TodayStats todayStats;

  const QuickStats({super.key, required this.todayStats});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quick Stats', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total Leads', todayStats.totalLeads.toString()),
                _buildStatItem(
                  'Total Bookings',
                  todayStats.totalBookings.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
