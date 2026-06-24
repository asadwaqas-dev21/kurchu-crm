import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';
import 'package:intl/intl.dart';

class MoneySnapshotSection extends StatelessWidget {
  final double bookingValue;
  final double collected;
  final double balance;
  final double profit;
  final double invoiced;

  const MoneySnapshotSection({
    required this.bookingValue,
    required this.collected,
    required this.balance,
    required this.profit,
    required this.invoiced,
    super.key,
  });

  String _formatCurrency(double amount) {
    final format = NumberFormat.currency(
      locale: 'en_PK',
      symbol: 'PKR ',
      decimalDigits: 0,
    );
    return format.format(amount);
  }

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
          Text(
            'Money snapshot',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildValueColumn(
                'Booking value',
                _formatCurrency(bookingValue),
                AppColors.textPrimary,
              ),
              _buildValueColumn(
                'Collected',
                _formatCurrency(collected),
                AppColors.success,
              ),
              _buildValueColumn(
                'Balance to collect',
                _formatCurrency(balance),
                AppColors.error,
              ),
              _buildValueColumn(
                'Bookings profit',
                _formatCurrency(profit),
                AppColors.success,
                showTrendingIcon: true,
              ),
              _buildValueColumn(
                'Invoiced revenue',
                _formatCurrency(invoiced),
                AppColors.textPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueColumn(
    String label,
    String value,
    Color valueColor, {
    bool showTrendingIcon = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (showTrendingIcon) ...[
              Icon(Iconsax.trend_up, color: valueColor, size: 18),
              const SizedBox(width: 4),
            ],
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
