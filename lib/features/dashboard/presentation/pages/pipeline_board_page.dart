// ignore_for_file: deprecated_member_use

import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';
import 'package:crm_kurchudashboard/features/leads/presentation/bloc/lead_bloc.dart';
import 'package:crm_kurchudashboard/features/leads/presentation/bloc/lead_event.dart';
import 'package:crm_kurchudashboard/features/leads/presentation/bloc/lead_state.dart';
import 'package:crm_kurchudashboard/features/leads/data/models/lead_model.dart';

class PipelineBoardPage extends StatefulWidget {
  const PipelineBoardPage({super.key});

  @override
  State<PipelineBoardPage> createState() => _PipelineBoardPageState();
}

class _PipelineBoardPageState extends State<PipelineBoardPage> {
  String _searchQuery = '';
  String? _selectedStage;
  final _searchController = TextEditingController();

  static const _stages = [
    'NEW',
    'CONTACTED',
    'INTERESTED',
    'DEMO',
    'NEGOTIATION',
    'WON',
    'LOST',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LeadModel> _filterLeads(List<LeadModel> leads) {
    var filtered = leads;

    // Stage filter
    if (_selectedStage != null) {
      filtered = filtered
          .where((l) => l.stage.toUpperCase() == _selectedStage)
          .toList();
    }

    // Search filter
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered.where((lead) {
        final name = '${lead.firstName} ${lead.lastName}'.toLowerCase();
        final phone = (lead.phone ?? '').toLowerCase();
        final email = (lead.email ?? '').toLowerCase();
        final company = (lead.company ?? '').toLowerCase();
        final stage = lead.stage.toLowerCase();
        return name.contains(q) ||
            phone.contains(q) ||
            email.contains(q) ||
            company.contains(q) ||
            stage.contains(q);
      }).toList();
    }

    return filtered;
  }

  String _getMonthName(int month) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<LeadBloc, LeadState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(
              child: Text(
                'Error: $message',
                style: TextStyle(color: AppColors.error),
              ),
            ),
            loaded: (leads, total, skip, limit) {
              // Filter leads by search query
              final filtered = _filterLeads(leads);
              // Group leads by stage
              final newLeads = filtered
                  .where((l) => l.stage.toUpperCase() == 'NEW')
                  .toList();
              final contactedLeads = filtered
                  .where((l) => l.stage.toUpperCase() == 'CONTACTED')
                  .toList();
              final interestedLeads = filtered
                  .where((l) => l.stage.toUpperCase() == 'INTERESTED')
                  .toList();
              final demoLeads = filtered
                  .where((l) => l.stage.toUpperCase() == 'DEMO')
                  .toList();
              final negotiationLeads = filtered
                  .where((l) => l.stage.toUpperCase() == 'NEGOTIATION')
                  .toList();
              final wonLeads = filtered
                  .where((l) => l.stage.toUpperCase() == 'WON')
                  .toList();
              final lostLeads = filtered
                  .where((l) => l.stage.toUpperCase() == 'LOST')
                  .toList();

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pipeline',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Track your leads in pipeline stages.',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // Search Bar
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
                                      controller: _searchController,
                                      onChanged: (value) {
                                        setState(() {
                                          _searchQuery = value;
                                        });
                                      },
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textPrimary,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Search leads...',
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
                            const SizedBox(width: 16),
                            // Filter Button
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: _selectedStage != null
                                    ? AppColors.primary.withValues(alpha: 0.08)
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _selectedStage != null
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  PopupMenuButton<String?>(
                                    onSelected: (value) {
                                      setState(() {
                                        _selectedStage = value;
                                      });
                                    },
                                    offset: const Offset(0, 44),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    color: AppColors.surface,
                                    itemBuilder: (context) {
                                      Color stageColor(String stage) {
                                        switch (stage) {
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

                                      return [
                                        PopupMenuItem<String?>(
                                          value: null,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Iconsax.layer,
                                                size: 18,
                                                color: _selectedStage == null
                                                    ? AppColors.primary
                                                    : AppColors.textSecondary,
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                'All Stages',
                                                style: TextStyle(
                                                  fontWeight:
                                                      _selectedStage == null
                                                      ? FontWeight.w600
                                                      : FontWeight.w400,
                                                  color: _selectedStage == null
                                                      ? AppColors.primary
                                                      : AppColors.textPrimary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuDivider(),
                                        ..._stages.map(
                                          (stage) => PopupMenuItem<String?>(
                                            value: stage,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    color: stageColor(stage),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  stage[0] +
                                                      stage
                                                          .substring(1)
                                                          .toLowerCase(),
                                                  style: TextStyle(
                                                    fontWeight:
                                                        _selectedStage == stage
                                                        ? FontWeight.w600
                                                        : FontWeight.w400,
                                                    color:
                                                        _selectedStage == stage
                                                        ? AppColors.primary
                                                        : AppColors.textPrimary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ];
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 16,
                                        right: _selectedStage != null ? 8 : 16,
                                        top: 8,
                                        bottom: 8,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Iconsax.filter,
                                            size: 20,
                                            color: _selectedStage != null
                                                ? AppColors.primary
                                                : AppColors.textSecondary,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            _selectedStage != null
                                                ? _selectedStage![0] +
                                                      _selectedStage!
                                                          .substring(1)
                                                          .toLowerCase()
                                                : 'Filters',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: _selectedStage != null
                                                  ? AppColors.primary
                                                  : AppColors.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (_selectedStage != null)
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        setState(() {
                                          _selectedStage = null;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 16,
                                          left: 4,
                                          top: 8,
                                          bottom: 8,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          size: 16,
                                          color: AppColors.primary,
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
                    const SizedBox(height: 24),

                    // Kanban Board
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 180,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildKanbanColumn(
                              context,
                              'New (${newLeads.length})',
                              'NEW',
                              AppColors.iconBlue,
                              AppColors.iconBgBlue,
                              newLeads,
                            ),
                            const SizedBox(width: 16),
                            _buildKanbanColumn(
                              context,
                              'Contacted (${contactedLeads.length})',
                              'CONTACTED',
                              AppColors.iconGreen,
                              AppColors.iconBgGreen,
                              contactedLeads,
                            ),
                            const SizedBox(width: 16),
                            _buildKanbanColumn(
                              context,
                              'Interested (${interestedLeads.length})',
                              'INTERESTED',
                              AppColors.iconOrange,
                              AppColors.iconBgOrange,
                              interestedLeads,
                            ),
                            const SizedBox(width: 16),
                            _buildKanbanColumn(
                              context,
                              'Demo (${demoLeads.length})',
                              'DEMO',
                              AppColors.iconPurple,
                              AppColors.iconBgPurple,
                              demoLeads,
                            ),
                            const SizedBox(width: 16),
                            _buildKanbanColumn(
                              context,
                              'Negotiation (${negotiationLeads.length})',
                              'NEGOTIATION',
                              const Color(0xFFE11D48),
                              const Color(0xFFFCE7F3),
                              negotiationLeads,
                            ),
                            const SizedBox(width: 16),
                            _buildKanbanColumn(
                              context,
                              'Won (${wonLeads.length})',
                              'WON',
                              AppColors.success,
                              AppColors.iconBgGreen,
                              wonLeads,
                            ),
                            const SizedBox(width: 16),
                            _buildKanbanColumn(
                              context,
                              'Lost (${lostLeads.length})',
                              'LOST',
                              AppColors.error,
                              const Color(0xFFFCE7F3),
                              lostLeads,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            orElse: () => const SizedBox(),
          );
        },
      ),
    );
  }

  Widget _buildKanbanColumn(
    BuildContext context,
    String title,
    String stageKey,
    Color color,
    Color bgColor,
    List<LeadModel> leads,
  ) {
    return DragTarget<LeadModel>(
      onAccept: (lead) {
        if (lead.stage.toUpperCase() != stageKey) {
          context.read<LeadBloc>().add(
            LeadEvent.updateLead(lead.id, {'stage': stageKey}),
          );
        }
      },
      builder: (context, candidateData, rejectedData) {
        final isOver = candidateData.isNotEmpty;
        return Container(
          width: 280,
          decoration: BoxDecoration(
            color: isOver ? bgColor.withValues(alpha: 0.3) : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isOver ? color : AppColors.border,
              width: isOver ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Column Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Icon(
                      Iconsax.more,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: AppColors.border),
              // Cards
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    ...leads.map((lead) => _buildLeadCard(context, lead)),
                    const SizedBox(height: 8),
                    // Add Lead Button
                    InkWell(
                      onTap: () => context.go('/leads'),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.add,
                              color: AppColors.iconBlue,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Add Lead',
                              style: TextStyle(
                                color: AppColors.iconBlue,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLeadCard(BuildContext context, LeadModel lead) {
    final name = '${lead.firstName} ${lead.lastName}';
    final city = lead.company ?? 'Individual';
    final date = '${lead.createdAt.day} ${_getMonthName(lead.createdAt.month)}';

    final cardChild = Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                city,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              Text(
                date,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );

    return Draggable<LeadModel>(
      data: lead,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 250,
          child: Opacity(opacity: 0.8, child: cardChild),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: cardChild),
      child: cardChild,
    );
  }
}
