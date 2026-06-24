import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/widgets/kpi_card.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/widgets/needs_attention_section.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/widgets/money_snapshot.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/widgets/upcoming_follow_ups.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/widgets/recent_bookings.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Fetch metrics on page load
    context.read<DashboardBloc>().add(const DashboardEvent.metricsFetched());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return switch (state) {
            Loading() => const Center(child: CircularProgressIndicator()),
            Loaded(
              :final metrics,
              :final alerts,
              :final todayStats,
              :final isWebSocketConnected,
            ) =>
              RefreshIndicator(
                onRefresh: () async {
                  context.read<DashboardBloc>().add(
                    const DashboardEvent.refreshRequested(),
                  );
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Welcome back, Asad',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    '👋',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                               Text(
                                'Here\'s what\'s happening with your business today.',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                 Text(
                                  'Today, 24 May 2024',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                 Icon(
                                  Iconsax.arrow_down_1,
                                  size: 20,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // KPI Cards Grid
                      LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount = constraints.maxWidth > 750
                              ? 4
                              : (constraints.maxWidth > 450 ? 2 : 1);
                          return GridView.count(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: crossAxisCount == 4 ? 1.6 : 2.0,
                            children: [
                              KpiCard(
                                title: 'Leads',
                                value: '${metrics.totalLeads}',
                                subtitle:
                                    '100 today · ${metrics.newLeadsToday} new',
                                icon: Iconsax.profile_2user,
                                iconColor: AppColors.iconBlue,
                                iconBgColor: AppColors.iconBgBlue,
                              ),
                              KpiCard(
                                title: 'Calls today',
                                value: '${metrics.callsToday}',
                                subtitle: '15 follow-ups due today',
                                icon: Iconsax.call_calling,
                                iconColor: AppColors.iconPurple,
                                iconBgColor: AppColors.iconBgPurple,
                              ),
                              KpiCard(
                                title: 'Bookings',
                                value: '${metrics.bookingsThisMonth}',
                                subtitle: '31 members · 0 today',
                                icon: Iconsax.ticket,
                                iconColor: AppColors.iconGreen,
                                iconBgColor: AppColors.iconBgGreen,
                              ),
                              KpiCard(
                                title: 'Due Payments',
                                value: 'PKR ${metrics.pendingPayments.toInt()}',
                                subtitle:
                                    'PKR ${metrics.collectedAmount.toInt()} collected',
                                icon: Iconsax.wallet,
                                iconColor: AppColors.iconOrange,
                                iconBgColor: AppColors.iconBgOrange,
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Needs Attention Section
                      const NeedsAttentionSection(),

                      const SizedBox(height: 24),

                      // Money Snapshot
                      MoneySnapshotSection(
                        bookingValue:
                            metrics.totalRevenue +
                            metrics.pendingPayments,
                        collected: metrics.collectedAmount,
                        balance: metrics.pendingPayments,
                        profit: metrics.totalProfit,
                        invoiced: metrics.invoicedAmount,
                      ),

                      const SizedBox(height: 24),

                      // Bottom area matching design
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 750) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 5, child: const UpcomingFollowUps()),
                                const SizedBox(width: 24),
                                Expanded(flex: 4, child: const RecentBookings()),
                              ],
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const UpcomingFollowUps(),
                                const SizedBox(height: 24),
                                const RecentBookings(),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            Error(:final message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: $message',
                    style:  TextStyle(color: AppColors.error),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DashboardBloc>().add(
                        const DashboardEvent.refreshRequested(),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}
