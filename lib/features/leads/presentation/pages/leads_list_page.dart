import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';
import 'package:crm_kurchudashboard/features/leads/presentation/bloc/lead_bloc.dart';
import 'package:crm_kurchudashboard/features/leads/presentation/bloc/lead_event.dart';
import 'package:crm_kurchudashboard/features/leads/presentation/bloc/lead_state.dart';
import 'package:crm_kurchudashboard/features/leads/data/models/lead_model.dart';
import 'package:iconsax/iconsax.dart';

class LeadsListPage extends StatefulWidget {
  const LeadsListPage({super.key});

  @override
  State<LeadsListPage> createState() => _LeadsListPageState();
}

class _LeadsListPageState extends State<LeadsListPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: AppColors.background,
            body: SingleChildScrollView(
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
                            'Leads',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Manage and track all your leads.',
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
                                  itemBuilder: (context) => [
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
                                              fontWeight: _selectedStage == null
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
                                                color: _getStatusColor(stage),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              stage[0] +
                                                  stage.substring(1).toLowerCase(),
                                              style: TextStyle(
                                                fontWeight: _selectedStage == stage
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                                color: _selectedStage == stage
                                                    ? AppColors.primary
                                                    : AppColors.textPrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
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
                          const SizedBox(width: 16),
                          // Add Lead Button
                          GestureDetector(
                            onTap: () => _showAddLeadDialog(context),
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors
                                    .iconPurple, // Using purple as primary based on design
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    Iconsax.add,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Add Lead',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Data Table Section
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
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
                            final filteredLeads = _filterLeads(leads);
                            final currentPage = (skip / limit).floor() + 1;
                            final totalPages = (total / limit).ceil();
                            final showingStart = total == 0 ? 0 : skip + 1;
                            final showingEnd = (skip + limit) > total
                                ? total
                                : (skip + limit);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minWidth: constraints.maxWidth,
                                        ),
                                        child: filteredLeads.isEmpty
                                            ? Padding(
                                                padding: const EdgeInsets.all(
                                                  48.0,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    _searchQuery.isNotEmpty
                                                        ? 'No leads matching "$_searchQuery"'
                                                        : 'No leads found.',
                                                  ),
                                                ),
                                              )
                                            : DataTable(
                                                headingTextStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      AppColors.textSecondary,
                                                  fontSize: 13,
                                                ),
                                                dataTextStyle: TextStyle(
                                                  color: AppColors.textPrimary,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                dividerThickness: 1,
                                                columns: const [
                                                  DataColumn(
                                                    label: Text('Name'),
                                                  ),
                                                  DataColumn(
                                                    label: Text('Phone'),
                                                  ),
                                                  DataColumn(
                                                    label: Text('Source'),
                                                  ),
                                                  DataColumn(
                                                    label: Text('Status'),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      'Follow-up Date',
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text('Assigned To'),
                                                  ),
                                                  DataColumn(
                                                    label: Text('Actions'),
                                                  ),
                                                ],
                                                rows: filteredLeads.map((lead) {
                                                  return _buildLeadRow(
                                                    context,
                                                    lead,
                                                  );
                                                }).toList(),
                                              ),
                                      ),
                                    );
                                  },
                                ),
                                Divider(height: 1, color: AppColors.border),
                                // Pagination
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Showing $showingStart to $showingEnd of $total entries',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: skip > 0
                                                ? () {
                                                    context
                                                        .read<LeadBloc>()
                                                        .add(
                                                          LeadEvent.fetchLeads(
                                                            skip: skip - limit,
                                                            limit: limit,
                                                          ),
                                                        );
                                                  }
                                                : null,
                                            child: Opacity(
                                              opacity: skip > 0 ? 1.0 : 0.5,
                                              child: _buildPaginationButton(
                                                Iconsax.arrow_left_2,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          if (totalPages > 0)
                                            ...() {
                                              final List<Widget> pageButtons =
                                                  [];
                                              if (totalPages <= 5) {
                                                for (
                                                  int i = 1;
                                                  i <= totalPages;
                                                  i++
                                                ) {
                                                  final pageIdx = i - 1;
                                                  pageButtons.add(
                                                    GestureDetector(
                                                      onTap: () {
                                                        context
                                                            .read<LeadBloc>()
                                                            .add(
                                                              LeadEvent.fetchLeads(
                                                                skip:
                                                                    pageIdx *
                                                                    limit,
                                                                limit: limit,
                                                              ),
                                                            );
                                                      },
                                                      child:
                                                          _buildPaginationPage(
                                                            '$i',
                                                            isActive:
                                                                i ==
                                                                currentPage,
                                                          ),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                // Always show 1
                                                pageButtons.add(
                                                  GestureDetector(
                                                    onTap: () => context
                                                        .read<LeadBloc>()
                                                        .add(
                                                          LeadEvent.fetchLeads(
                                                            skip: 0,
                                                            limit: limit,
                                                          ),
                                                        ),
                                                    child: _buildPaginationPage(
                                                      '1',
                                                      isActive:
                                                          currentPage == 1,
                                                    ),
                                                  ),
                                                );

                                                if (currentPage > 3) {
                                                  pageButtons.add(
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 4,
                                                          ),
                                                      child: Text(
                                                        '...',
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .textSecondary,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }

                                                // Middle pages
                                                final start =
                                                    currentPage - 1 > 1
                                                    ? currentPage - 1
                                                    : 2;
                                                final end =
                                                    currentPage + 1 < totalPages
                                                    ? currentPage + 1
                                                    : totalPages - 1;
                                                for (
                                                  int i = start;
                                                  i <= end;
                                                  i++
                                                ) {
                                                  final pageIdx = i - 1;
                                                  pageButtons.add(
                                                    GestureDetector(
                                                      onTap: () {
                                                        context
                                                            .read<LeadBloc>()
                                                            .add(
                                                              LeadEvent.fetchLeads(
                                                                skip:
                                                                    pageIdx *
                                                                    limit,
                                                                limit: limit,
                                                              ),
                                                            );
                                                      },
                                                      child:
                                                          _buildPaginationPage(
                                                            '$i',
                                                            isActive:
                                                                i ==
                                                                currentPage,
                                                          ),
                                                    ),
                                                  );
                                                }

                                                if (currentPage <
                                                    totalPages - 2) {
                                                  pageButtons.add(
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 4,
                                                          ),
                                                      child: Text(
                                                        '...',
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .textSecondary,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }

                                                // Always show totalPages
                                                pageButtons.add(
                                                  GestureDetector(
                                                    onTap: () => context
                                                        .read<LeadBloc>()
                                                        .add(
                                                          LeadEvent.fetchLeads(
                                                            skip:
                                                                (totalPages -
                                                                    1) *
                                                                limit,
                                                            limit: limit,
                                                          ),
                                                        ),
                                                    child: _buildPaginationPage(
                                                      '$totalPages',
                                                      isActive:
                                                          currentPage ==
                                                          totalPages,
                                                    ),
                                                  ),
                                                );
                                              }
                                              return pageButtons;
                                            }(),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: (skip + limit) < total
                                                ? () {
                                                    context
                                                        .read<LeadBloc>()
                                                        .add(
                                                          LeadEvent.fetchLeads(
                                                            skip: skip + limit,
                                                            limit: limit,
                                                          ),
                                                        );
                                                  }
                                                : null,
                                            child: Opacity(
                                              opacity: (skip + limit) < total
                                                  ? 1.0
                                                  : 0.5,
                                              child: _buildPaginationButton(
                                                Iconsax.arrow_right_3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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

  DataRow _buildLeadRow(BuildContext context, LeadModel lead) {
    return DataRow(
      cells: [
        DataCell(Text('${lead.firstName} ${lead.lastName}')),
        DataCell(
          Text(
            lead.phone ?? 'N/A',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        DataCell(
          const Text(
            'Website',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusBgColor(lead.stage),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              lead.stage,
              style: TextStyle(
                color: _getStatusColor(lead.stage),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        DataCell(
          const Text(
            'Pending',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
        DataCell(
          const Text('Agent', style: TextStyle(fontWeight: FontWeight.normal)),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Iconsax.edit,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                onPressed: () => _showEditLeadDialog(context, lead),
              ),
              IconButton(
                icon: Icon(Iconsax.trash, size: 20, color: AppColors.error),
                onPressed: () => _showDeleteConfirmation(context, lead),
              ),
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

  Widget _buildPaginationButton(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(icon, size: 16, color: AppColors.textSecondary),
    );
  }

  Widget _buildPaginationPage(String page, {bool isActive = false}) {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.iconPurple : AppColors.surface,
        border: Border.all(
          color: isActive ? AppColors.iconPurple : AppColors.border,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        page,
        style: TextStyle(
          color: isActive ? Colors.white : AppColors.textSecondary,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
      ),
    );
  }

  void _showAddLeadDialog(BuildContext context) {
    final leadBloc = context.read<LeadBloc>();
    final formKey = GlobalKey<FormState>();
    String firstName = '';
    String lastName = '';
    String phone = '';
    String email = '';
    String stage = 'NEW';
    // Valid IDs from the backend database
    String sourceId = 'cmqs1yxc0000614552yrasd3s';
    String assignedToId = 'cmqs1ywv200021455ssy0r8oz';
    DateTime? followUpDate;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (statefulContext, setState) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              title: Text(
                'Add Lead',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                labelStyle: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              style: TextStyle(color: AppColors.textPrimary),
                              onSaved: (val) => firstName = val ?? '',
                              validator: (val) =>
                                  val!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                labelStyle: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              style: TextStyle(color: AppColors.textPrimary),
                              onSaved: (val) => lastName = val ?? '',
                              validator: (val) =>
                                  val!.isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                        ),
                        style: TextStyle(color: AppColors.textPrimary),
                        onSaved: (val) => phone = val ?? '',
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                        ),
                        style: TextStyle(color: AppColors.textPrimary),
                        onSaved: (val) => email = val ?? '',
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: stage,
                        decoration: InputDecoration(
                          labelText: 'Status',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                        ),
                        dropdownColor: AppColors.surface,
                        style: TextStyle(color: AppColors.textPrimary),
                        items:
                            [
                                  'NEW',
                                  'CONTACTED',
                                  'INTERESTED',
                                  'DEMO',
                                  'NEGOTIATION',
                                  'WON',
                                  'LOST',
                                ]
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) => setState(() => stage = val!),
                      ),
                      DropdownButtonFormField<String>(
                        initialValue: sourceId,
                        decoration: InputDecoration(
                          labelText: 'Source',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                        ),
                        dropdownColor: AppColors.surface,
                        style: TextStyle(color: AppColors.textPrimary),
                        items: const [
                          DropdownMenuItem(
                            value: 'cmqs1yxc0000614552yrasd3s',
                            child: Text('Website'),
                          ),
                        ],
                        onChanged: (val) => setState(() => sourceId = val!),
                      ),
                      DropdownButtonFormField<String>(
                        initialValue: assignedToId,
                        decoration: InputDecoration(
                          labelText: 'Assigned To',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                        ),
                        dropdownColor: AppColors.surface,
                        style: TextStyle(color: AppColors.textPrimary),
                        items: const [
                          DropdownMenuItem(
                            value: 'cmqs1ywv200021455ssy0r8oz',
                            child: Text('Agent'),
                          ),
                        ],
                        onChanged: (val) => setState(() => assignedToId = val!),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().add(
                              const Duration(days: 1),
                            ),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (date != null) {
                            setState(() => followUpDate = date);
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Follow-up Date',
                            labelStyle: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          child: Text(
                            followUpDate == null
                                ? 'Select Date'
                                : '${followUpDate!.day}/${followUpDate!.month}/${followUpDate!.year}',
                            style: TextStyle(
                              color: followUpDate == null
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.iconPurple,
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      leadBloc.add(
                        LeadEvent.addLead({
                          'firstName': firstName,
                          'lastName': lastName,
                          'phone': phone,
                          'email': email,
                          'stage': stage,
                          'sourceId': sourceId,
                          'assignedToId': assignedToId,
                          if (followUpDate != null)
                            'followUpDate': followUpDate!.toIso8601String(),
                        }),
                      );
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditLeadDialog(BuildContext context, LeadModel lead) {
    final leadBloc = context.read<LeadBloc>();
    final formKey = GlobalKey<FormState>();
    String firstName = lead.firstName;
    String lastName = lead.lastName;
    String phone = lead.phone ?? '';
    String email = lead.email ?? '';
    String stage = lead.stage;
    String sourceId = 'cmqs1yxc0000614552yrasd3s';
    String assignedToId = 'cmqs1ywv200021455ssy0r8oz';
    DateTime? followUpDate;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (statefulContext, setState) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              title: Text(
                'Edit Lead',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: firstName,
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                labelStyle: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              style: TextStyle(color: AppColors.textPrimary),
                              onSaved: (val) => firstName = val ?? '',
                              validator: (val) =>
                                  val!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              initialValue: lastName,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                labelStyle: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              style: TextStyle(color: AppColors.textPrimary),
                              onSaved: (val) => lastName = val ?? '',
                              validator: (val) =>
                                  val!.isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        initialValue: phone,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                        ),
                        style: TextStyle(color: AppColors.textPrimary),
                        onSaved: (val) => phone = val ?? '',
                      ),
                      TextFormField(
                        initialValue: email,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                        ),
                        style: TextStyle(color: AppColors.textPrimary),
                        onSaved: (val) => email = val ?? '',
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue:
                            [
                              'NEW',
                              'CONTACTED',
                              'INTERESTED',
                              'DEMO',
                              'NEGOTIATION',
                              'WON',
                              'LOST',
                            ].contains(stage)
                            ? stage
                            : 'NEW',
                        decoration: InputDecoration(
                          labelText: 'Status',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                        ),
                        dropdownColor: AppColors.surface,
                        style: TextStyle(color: AppColors.textPrimary),
                        items:
                            [
                                  'NEW',
                                  'CONTACTED',
                                  'INTERESTED',
                                  'DEMO',
                                  'NEGOTIATION',
                                  'WON',
                                  'LOST',
                                ]
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s),
                                  ),
                                )
                                .toList(),
                        onChanged: (val) => setState(() => stage = val!),
                      ),
                      DropdownButtonFormField<String>(
                        initialValue: sourceId,
                        decoration: InputDecoration(
                          labelText: 'Source',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                        ),
                        dropdownColor: AppColors.surface,
                        style: TextStyle(color: AppColors.textPrimary),
                        items: const [
                          DropdownMenuItem(
                            value: 'cmqs1yxc0000614552yrasd3s',
                            child: Text('Website'),
                          ),
                        ],
                        onChanged: (val) => setState(() => sourceId = val!),
                      ),
                      DropdownButtonFormField<String>(
                        initialValue: assignedToId,
                        decoration: InputDecoration(
                          labelText: 'Assigned To',
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                        ),
                        dropdownColor: AppColors.surface,
                        style: TextStyle(color: AppColors.textPrimary),
                        items: const [
                          DropdownMenuItem(
                            value: 'cmqs1ywv200021455ssy0r8oz',
                            child: Text('Agent'),
                          ),
                        ],
                        onChanged: (val) => setState(() => assignedToId = val!),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().add(
                              const Duration(days: 1),
                            ),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (date != null) {
                            setState(() => followUpDate = date);
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Follow-up Date',
                            labelStyle: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          child: Text(
                            followUpDate == null
                                ? 'Select Date'
                                : '${followUpDate!.day}/${followUpDate!.month}/${followUpDate!.year}',
                            style: TextStyle(
                              color: followUpDate == null
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.iconPurple,
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      leadBloc.add(
                        LeadEvent.updateLead(lead.id, {
                          'firstName': firstName,
                          'lastName': lastName,
                          'phone': phone,
                          'email': email,
                          'stage': stage,
                          'sourceId': sourceId,
                          'assignedToId': assignedToId,
                          if (followUpDate != null)
                            'followUpDate': followUpDate!.toIso8601String(),
                        }),
                      );
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, LeadModel lead) {
    final leadBloc = context.read<LeadBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'Delete Lead',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: Text(
            'Are you sure you want to delete ${lead.firstName} ${lead.lastName}?',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () {
                leadBloc.add(LeadEvent.deleteLead(lead.id));
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
