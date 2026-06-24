import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/features/follow_ups/presentation/bloc/follow_up_bloc.dart';
import 'package:crm_kurchudashboard/features/follow_ups/presentation/bloc/follow_up_event.dart';
import 'package:crm_kurchudashboard/features/follow_ups/presentation/bloc/follow_up_state.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/bloc/dashboard_state.dart';

class UpcomingFollowUps extends StatelessWidget {
  const UpcomingFollowUps({super.key});

  String _formatDateTime(DateTime scheduledAt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final scheduledDate = DateTime(scheduledAt.year, scheduledAt.month, scheduledAt.day);

    final hourNum = scheduledAt.hour > 12 ? scheduledAt.hour - 12 : (scheduledAt.hour == 0 ? 12 : scheduledAt.hour);
    final ampm = scheduledAt.hour >= 12 ? 'PM' : 'AM';
    final minuteStr = scheduledAt.minute.toString().padLeft(2, '0');
    final timeStr = '$hourNum:$minuteStr $ampm';

    if (scheduledDate == today) {
      return 'Today, $timeStr';
    } else if (scheduledDate == tomorrow) {
      return 'Tomorrow, $timeStr';
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final monthStr = months[scheduledAt.month - 1];
      return '${scheduledAt.day} $monthStr, $timeStr';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FollowUpBloc>()
        ..add(const FollowUpEvent.fetchFollowUps(isCompleted: false)),
      child: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, dashboardState) {
          if (dashboardState is Loading) {
            context
                .read<FollowUpBloc>()
                .add(const FollowUpEvent.fetchFollowUps(isCompleted: false));
          }
        },
        child: Container(
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
                       Icon(Iconsax.arrow_right_1, color: AppColors.textPrimary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Upcoming Follow-ups',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => context.go('/follow-ups'),
                    child:  MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text(
                        'View all',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<FollowUpBloc, FollowUpState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (message) => Center(
                        child: Text(
                          'Error: $message',
                          style:  TextStyle(
                            color: AppColors.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      loaded: (followUps) {
                        if (followUps.isEmpty) {
                          return  Center(
                            child: Text(
                              'No upcoming follow-ups',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          );
                        }

                        // Filter to show only pending ones (in case backend includes completed ones)
                        final pendingFollowUps =
                            followUps.where((f) => !f.isCompleted).toList();

                        if (pendingFollowUps.isEmpty) {
                          return  Center(
                            child: Text(
                              'No upcoming follow-ups',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          itemCount: pendingFollowUps.length,
                          separatorBuilder: (context, index) =>  Divider(
                            color: AppColors.border,
                            height: 24,
                          ),
                          itemBuilder: (context, index) {
                            final followUp = pendingFollowUps[index];
                            final leadName = followUp.lead != null
                                ? '${followUp.lead!.firstName} ${followUp.lead!.lastName}'
                                : 'Lead ID: ${followUp.leadId}';

                            return _buildFollowUpItem(
                              context,
                              name: leadName,
                              time: _formatDateTime(followUp.scheduledAt),
                              type: 'Call',
                              typeColor: AppColors.textSecondary,
                              typeBgColor: AppColors.background,
                            );
                          },
                        );
                      },
                      orElse: () => const SizedBox(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFollowUpItem(
    BuildContext context, {
    required String name,
    required String time,
    required String type,
    required Color typeColor,
    required Color typeBgColor,
  }) {
    final initials = name.isNotEmpty
        ? name
            .trim()
            .split(' ')
            .where((e) => e.isNotEmpty)
            .map((e) => e[0])
            .take(2)
            .join('')
            .toUpperCase()
        : '?';

    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.iconBgBlue,
          child: Text(
            initials,
            style:  TextStyle(
              fontSize: 12,
              color: AppColors.iconBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            name,
            style:  TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            time,
            style:  TextStyle(fontSize: 12, color: AppColors.textSecondary),
            overflow: TextOverflow.ellipsis,
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
            style: TextStyle(
              fontSize: 11,
              color: typeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
