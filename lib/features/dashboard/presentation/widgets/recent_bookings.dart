import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/core/services/api_client.dart';
import 'package:crm_kurchudashboard/core/constants/api_constants.dart';
import 'package:crm_kurchudashboard/features/bookings/presentation/bloc/booking_bloc.dart';
import 'package:crm_kurchudashboard/features/bookings/presentation/bloc/booking_event.dart';
import 'package:crm_kurchudashboard/features/bookings/presentation/bloc/booking_state.dart';
import 'package:crm_kurchudashboard/features/bookings/data/models/booking_model.dart';
import 'package:crm_kurchudashboard/features/leads/presentation/bloc/lead_bloc.dart';
import 'package:crm_kurchudashboard/features/leads/presentation/bloc/lead_state.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/bloc/dashboard_state.dart';

class RecentBookings extends StatefulWidget {
  const RecentBookings({super.key});

  @override
  State<RecentBookings> createState() => _RecentBookingsState();
}

class _RecentBookingsState extends State<RecentBookings> {
  Map<String, String> _serviceNames = {};

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
      final apiClient = getIt<ApiClient>();
      final response = await apiClient.get(ApiConstants.companyServices);
      final List<dynamic> rawServices = response.data['data']['services'] ?? [];
      final Map<String, String> names = {};
      for (var s in rawServices) {
        if (s['id'] != null && s['name'] != null) {
          names[s['id'].toString()] = s['name'].toString();
        }
      }
      if (mounted) {
        setState(() {
          _serviceNames = names;
        });
      }
    } catch (_) {}
  }

  String _getLeadName(BuildContext context, String leadId) {
    final leadState = context.read<LeadBloc>().state;
    return leadState.maybeWhen(
      loaded: (leads, total, skip, limit) {
        try {
          final lead = leads.firstWhere((l) => l.id == leadId);
          return '${lead.firstName} ${lead.lastName}';
        } catch (_) {
          return 'Lead ${leadId.length > 8 ? leadId.substring(0, 8) : leadId}';
        }
      },
      orElse: () =>
          'Lead ${leadId.length > 8 ? leadId.substring(0, 8) : leadId}',
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return AppColors.warning;
      case 'CONFIRMED':
        return AppColors.success;
      case 'COMPLETED':
        return AppColors.iconBlue;
      case 'CANCELLED':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return AppColors.iconBgOrange;
      case 'CONFIRMED':
        return AppColors.iconBgGreen;
      case 'COMPLETED':
        return AppColors.iconBgBlue;
      case 'CANCELLED':
        return const Color(0xFFFCE7F3);
      default:
        return AppColors.surface;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardBloc, DashboardState>(
      listener: (context, dashboardState) {
        if (dashboardState is Loading) {
          context.read<BookingBloc>().add(const BookingEvent.fetchBookings());
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
              children: [
                Icon(Iconsax.timer_1, color: AppColors.textPrimary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Recent Bookings',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (message) => Center(
                      child: Text(
                        'Error loading bookings',
                        style: TextStyle(color: AppColors.error, fontSize: 12),
                      ),
                    ),
                    loaded: (bookings) {
                      if (bookings.isEmpty) {
                        return Center(
                          child: Text(
                            'No recent bookings',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        );
                      }

                      // Sort bookings by date descending (most recent first)
                      final sortedBookings = List<BookingModel>.from(
                        bookings,
                      )..sort((a, b) => b.bookingDate.compareTo(a.bookingDate));

                      // Display up to 2 bookings to fit within the 200px container limit beautifully
                      final displayedBookings = sortedBookings.take(2).toList();

                      return ListView.separated(
                        itemCount: displayedBookings.length,
                        separatorBuilder: (context, index) =>
                            Divider(color: AppColors.border, height: 24),
                        itemBuilder: (context, index) {
                          final booking = displayedBookings[index];
                          final leadName = _getLeadName(
                            context,
                            booking.leadId,
                          );
                          final serviceName =
                              _serviceNames[booking.serviceId] ??
                              'Trip Booking';

                          return _buildBookingItem(
                            context,
                            name: leadName,
                            destination: serviceName,
                            amount: 'PKR ${booking.amount.toInt()}',
                            status: booking.status,
                            statusColor: _getStatusColor(booking.status),
                            statusBgColor: _getStatusBgColor(booking.status),
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
    );
  }

  Widget _buildBookingItem(
    BuildContext context, {
    required String name,
    required String destination,
    required String amount,
    required String status,
    required Color statusColor,
    required Color statusBgColor,
  }) {
    final initials = name.isNotEmpty
        ? name
              .split(' ')
              .where((e) => e.isNotEmpty)
              .map((e) => e[0])
              .take(2)
              .join('')
              .toUpperCase()
        : 'B';

    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.iconBgPurple,
          child: Text(
            initials,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.iconPurple,
              fontWeight: FontWeight.bold,
            ),
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
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 2),
              Text(
                destination,
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
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
            style: TextStyle(
              fontSize: 11,
              color: statusColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
