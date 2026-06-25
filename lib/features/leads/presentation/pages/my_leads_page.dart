import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';
import 'package:crm_kurchudashboard/features/leads/presentation/bloc/lead_bloc.dart';
import 'package:crm_kurchudashboard/features/leads/presentation/bloc/lead_state.dart';

class MyLeadsPage extends StatelessWidget {
  const MyLeadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Leads',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Manage leads currently assigned to you.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 250,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            Icon(
                              Iconsax.search_normal,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search my leads...',
                                  hintStyle: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Data Table Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(color: AppColors.border),
                  bottom: BorderSide(color: AppColors.border),
                ),
              ),
              child: BlocBuilder<LeadBloc, LeadState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loading: () => const Padding(
                        padding: EdgeInsets.all(48.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (message) => Padding(
                        padding: const EdgeInsets.all(48.0),
                        child: Center(
                          child: Text(
                            'Error: $message',
                            style: TextStyle(color: AppColors.error),
                          ),
                        ),
                      ),
                      loaded: (leads, total, skip, limit) {
                        if (leads.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(48.0),
                            child: Center(child: Text('No leads found.')),
                          );
                        }
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: constraints.maxWidth,
                                ),
                                child: DataTable(
                                  headingTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                  dataTextStyle: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  dividerThickness: 1,
                                  columns: const [
                                    DataColumn(label: Text('Name')),
                                    DataColumn(label: Text('Phone')),
                                    DataColumn(label: Text('Source')),
                                    DataColumn(label: Text('Status')),
                                    DataColumn(label: Text('Follow-up Date')),
                                    DataColumn(label: Text('Action')),
                                  ],
                                  rows: leads.map((lead) {
                                    return _buildLeadRow(
                                      '${lead.firstName} ${lead.lastName}',
                                      lead.phone ?? 'N/A',
                                      'Website',
                                      lead.stage,
                                      _getStatusColor(lead.stage),
                                      _getStatusBgColor(lead.stage),
                                      'Today, 11:00 AM',
                                    );
                                  }).toList(),
                                ),
                              ),
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

  DataRow _buildLeadRow(
    String name,
    String phone,
    String source,
    String status,
    Color statusColor,
    Color statusBgColor,
    String date,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(name)),
        DataCell(
          Text(
            phone,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        DataCell(
          Text(source, style: const TextStyle(fontWeight: FontWeight.normal)),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        DataCell(Text(date, style: TextStyle(fontWeight: FontWeight.normal))),
        DataCell(
          Row(
            children: [
              Icon(Iconsax.call, size: 20, color: AppColors.iconGreen),
              SizedBox(width: 16),
              Icon(Iconsax.message, size: 20, color: AppColors.iconBlue),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'NEW':
        return AppColors.iconBlue;
      case 'CONTACTED':
        return AppColors.iconGreen;
      case 'INTERESTED':
        return AppColors.iconOrange;
      case 'DEMO':
        return AppColors.iconPurple;
      case 'NEGOTIATION':
        return const Color(0xFFE11D48);
      case 'WON':
        return AppColors.success;
      case 'LOST':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toUpperCase()) {
      case 'NEW':
        return AppColors.iconBgBlue;
      case 'CONTACTED':
        return AppColors.iconBgGreen;
      case 'INTERESTED':
        return AppColors.iconBgOrange;
      case 'DEMO':
        return AppColors.iconBgPurple;
      case 'NEGOTIATION':
        return const Color(0xFFFCE7F3);
      case 'WON':
        return AppColors.iconBgGreen;
      case 'LOST':
        return const Color(0xFFFCE7F3);
      default:
        return AppColors.surface;
    }
  }
}
