import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/features/leads/presentation/bloc/lead_bloc.dart';
import 'package:crm_kurchudashboard/features/leads/presentation/bloc/lead_event.dart';
import 'package:crm_kurchudashboard/features/leads/presentation/bloc/lead_state.dart';
import 'package:crm_kurchudashboard/features/leads/data/models/lead_model.dart';
import 'package:iconsax/iconsax.dart';

class LeadsListPage extends StatelessWidget {
  const LeadsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LeadBloc>()..add(const LeadEvent.fetchLeads()),
      child: Builder(
        builder: (context) {
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
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
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
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Search leads...',
                          hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                          prefixIcon: Icon(Iconsax.search_normal, color: AppColors.textSecondary, size: 20),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Filter Button
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: const [
                          Icon(Iconsax.filter, size: 20, color: AppColors.textSecondary),
                          SizedBox(width: 8),
                          Text('Filters', style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Add Lead Button
                    GestureDetector(
                      onTap: () => _showAddLeadDialog(context),
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.iconPurple, // Using purple as primary based on design
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: const [
                            Icon(Iconsax.add, size: 20, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Add Lead', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
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
                      child: Center(child: Text('Error: $message', style: const TextStyle(color: AppColors.error))),
                    ),
                    loaded: (leads, total, skip, limit) {
                      final currentPage = (skip / limit).floor() + 1;
                      final totalPages = (total / limit).ceil();
                      final showingStart = total == 0 ? 0 : skip + 1;
                      final showingEnd = (skip + limit) > total ? total : (skip + limit);

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
                                  child: leads.isEmpty
                                      ? const Padding(
                                          padding: EdgeInsets.all(48.0),
                                          child: Center(child: Text('No leads found.')),
                                        )
                                      : DataTable(
                                          headingTextStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textSecondary,
                                            fontSize: 13,
                                          ),
                                          dataTextStyle: const TextStyle(
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
                                            DataColumn(label: Text('Assigned To')),
                                            DataColumn(label: Text('Actions')),
                                          ],
                                          rows: leads.map((lead) {
                                            return _buildLeadRow(context, lead);
                                          }).toList(),
                                        ),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          // Pagination
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Showing $showingStart to $showingEnd of $total entries',
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: skip > 0
                                          ? () {
                                              context.read<LeadBloc>().add(
                                                    LeadEvent.fetchLeads(
                                                      skip: skip - limit,
                                                      limit: limit,
                                                    ),
                                                  );
                                            }
                                          : null,
                                      child: Opacity(
                                        opacity: skip > 0 ? 1.0 : 0.5,
                                        child: _buildPaginationButton(Iconsax.arrow_left_2),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (totalPages > 0)
                                      ...() {
                                        final List<Widget> pageButtons = [];
                                        if (totalPages <= 5) {
                                          for (int i = 1; i <= totalPages; i++) {
                                            final pageIdx = i - 1;
                                            pageButtons.add(
                                              GestureDetector(
                                                onTap: () {
                                                  context.read<LeadBloc>().add(
                                                        LeadEvent.fetchLeads(
                                                          skip: pageIdx * limit,
                                                          limit: limit,
                                                        ),
                                                      );
                                                },
                                                child: _buildPaginationPage(
                                                  '$i',
                                                  isActive: i == currentPage,
                                                ),
                                              ),
                                            );
                                          }
                                        } else {
                                          // Always show 1
                                          pageButtons.add(
                                            GestureDetector(
                                              onTap: () => context.read<LeadBloc>().add(LeadEvent.fetchLeads(skip: 0, limit: limit)),
                                              child: _buildPaginationPage('1', isActive: currentPage == 1),
                                            ),
                                          );

                                          if (currentPage > 3) {
                                            pageButtons.add(const Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 4),
                                              child: Text('...', style: TextStyle(color: AppColors.textSecondary)),
                                            ));
                                          }

                                          // Middle pages
                                          final start = currentPage - 1 > 1 ? currentPage - 1 : 2;
                                          final end = currentPage + 1 < totalPages ? currentPage + 1 : totalPages - 1;
                                          for (int i = start; i <= end; i++) {
                                            final pageIdx = i - 1;
                                            pageButtons.add(
                                              GestureDetector(
                                                onTap: () {
                                                  context.read<LeadBloc>().add(
                                                        LeadEvent.fetchLeads(
                                                          skip: pageIdx * limit,
                                                          limit: limit,
                                                        ),
                                                      );
                                                },
                                                child: _buildPaginationPage(
                                                  '$i',
                                                  isActive: i == currentPage,
                                                ),
                                              ),
                                            );
                                          }

                                          if (currentPage < totalPages - 2) {
                                            pageButtons.add(const Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 4),
                                              child: Text('...', style: TextStyle(color: AppColors.textSecondary)),
                                            ));
                                          }

                                          // Always show totalPages
                                          pageButtons.add(
                                            GestureDetector(
                                              onTap: () => context.read<LeadBloc>().add(LeadEvent.fetchLeads(skip: (totalPages - 1) * limit, limit: limit)),
                                              child: _buildPaginationPage('$totalPages', isActive: currentPage == totalPages),
                                            ),
                                          );
                                        }
                                        return pageButtons;
                                      }(),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: (skip + limit) < total
                                          ? () {
                                              context.read<LeadBloc>().add(
                                                    LeadEvent.fetchLeads(
                                                      skip: skip + limit,
                                                      limit: limit,
                                                    ),
                                                  );
                                            }
                                          : null,
                                      child: Opacity(
                                        opacity: (skip + limit) < total ? 1.0 : 0.5,
                                        child: _buildPaginationButton(Iconsax.arrow_right_3),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
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
        },
      ),
    );
  }

  DataRow _buildLeadRow(BuildContext context, LeadModel lead) {
    return DataRow(
      cells: [
        DataCell(Text('${lead.firstName} ${lead.lastName}')),
        DataCell(Text(lead.phone ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.normal, color: AppColors.textSecondary))),
        DataCell(const Text('Website', style: TextStyle(fontWeight: FontWeight.normal))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusBgColor(lead.stage),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              lead.stage,
              style: TextStyle(color: _getStatusColor(lead.stage), fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        DataCell(const Text('Pending', style: TextStyle(fontWeight: FontWeight.normal))),
        DataCell(const Text('Agent', style: TextStyle(fontWeight: FontWeight.normal))),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Iconsax.edit, size: 20, color: AppColors.textSecondary),
                onPressed: () => _showEditLeadDialog(context, lead),
              ),
              IconButton(
                icon: const Icon(Iconsax.trash, size: 20, color: AppColors.error),
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
      case 'NEW': return AppColors.iconBlue;
      case 'CONTACTED': return AppColors.iconGreen;
      case 'INTERESTED': return AppColors.iconOrange;
      case 'DEMO': return AppColors.iconPurple;
      case 'NEGOTIATION': return const Color(0xFFE11D48);
      case 'WON': return AppColors.success;
      case 'LOST': return AppColors.error;
      default: return AppColors.textSecondary;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toUpperCase()) {
      case 'NEW': return AppColors.iconBgBlue;
      case 'CONTACTED': return AppColors.iconBgGreen;
      case 'INTERESTED': return AppColors.iconBgOrange;
      case 'DEMO': return AppColors.iconBgPurple;
      case 'NEGOTIATION': return const Color(0xFFFCE7F3);
      case 'WON': return AppColors.iconBgGreen;
      case 'LOST': return const Color(0xFFFCE7F3);
      default: return AppColors.surface;
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
        border: Border.all(color: isActive ? AppColors.iconPurple : AppColors.border),
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
    final _formKey = GlobalKey<FormState>();
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
              title: const Text('Add Lead', style: TextStyle(color: AppColors.textPrimary)),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(labelText: 'First Name', labelStyle: TextStyle(color: AppColors.textSecondary)),
                              style: const TextStyle(color: AppColors.textPrimary),
                              onSaved: (val) => firstName = val ?? '',
                              validator: (val) => val!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(labelText: 'Last Name', labelStyle: TextStyle(color: AppColors.textSecondary)),
                              style: const TextStyle(color: AppColors.textPrimary),
                              onSaved: (val) => lastName = val ?? '',
                              validator: (val) => val!.isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Phone', labelStyle: TextStyle(color: AppColors.textSecondary)),
                        style: const TextStyle(color: AppColors.textPrimary),
                        onSaved: (val) => phone = val ?? '',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: AppColors.textSecondary)),
                        style: const TextStyle(color: AppColors.textPrimary),
                        onSaved: (val) => email = val ?? '',
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: stage,
                        decoration: const InputDecoration(labelText: 'Status', labelStyle: TextStyle(color: AppColors.textSecondary)),
                        dropdownColor: AppColors.surface,
                        style: const TextStyle(color: AppColors.textPrimary),
                        items: ['NEW', 'CONTACTED', 'INTERESTED', 'DEMO', 'NEGOTIATION', 'WON', 'LOST']
                            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (val) => setState(() => stage = val!),
                      ),
                      DropdownButtonFormField<String>(
                        value: sourceId,
                        decoration: const InputDecoration(labelText: 'Source', labelStyle: TextStyle(color: AppColors.textSecondary)),
                        dropdownColor: AppColors.surface,
                        style: const TextStyle(color: AppColors.textPrimary),
                        items: const [
                          DropdownMenuItem(value: 'cmqs1yxc0000614552yrasd3s', child: Text('Website')),
                        ],
                        onChanged: (val) => setState(() => sourceId = val!),
                      ),
                      DropdownButtonFormField<String>(
                        value: assignedToId,
                        decoration: const InputDecoration(labelText: 'Assigned To', labelStyle: TextStyle(color: AppColors.textSecondary)),
                        dropdownColor: AppColors.surface,
                        style: const TextStyle(color: AppColors.textPrimary),
                        items: const [
                          DropdownMenuItem(value: 'cmqs1ywv200021455ssy0r8oz', child: Text('Agent')),
                        ],
                        onChanged: (val) => setState(() => assignedToId = val!),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().add(const Duration(days: 1)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setState(() => followUpDate = date);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Follow-up Date',
                            labelStyle: TextStyle(color: AppColors.textSecondary),
                          ),
                          child: Text(
                            followUpDate == null ? 'Select Date' : '${followUpDate!.day}/${followUpDate!.month}/${followUpDate!.year}',
                            style: TextStyle(color: followUpDate == null ? AppColors.textSecondary : AppColors.textPrimary),
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
                  child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.iconPurple),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      context.read<LeadBloc>().add(LeadEvent.addLead({
                        'firstName': firstName,
                        'lastName': lastName,
                        'phone': phone,
                        'email': email,
                        'stage': stage,
                        'sourceId': sourceId,
                        'assignedToId': assignedToId,
                        if (followUpDate != null) 'followUpDate': followUpDate!.toIso8601String(),
                      }));
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: const Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          }
        );
      },
    );
  }

  void _showEditLeadDialog(BuildContext context, LeadModel lead) {
    final _formKey = GlobalKey<FormState>();
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
              title: const Text('Edit Lead', style: TextStyle(color: AppColors.textPrimary)),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: firstName,
                              decoration: const InputDecoration(labelText: 'First Name', labelStyle: TextStyle(color: AppColors.textSecondary)),
                              style: const TextStyle(color: AppColors.textPrimary),
                              onSaved: (val) => firstName = val ?? '',
                              validator: (val) => val!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              initialValue: lastName,
                              decoration: const InputDecoration(labelText: 'Last Name', labelStyle: TextStyle(color: AppColors.textSecondary)),
                              style: const TextStyle(color: AppColors.textPrimary),
                              onSaved: (val) => lastName = val ?? '',
                              validator: (val) => val!.isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        initialValue: phone,
                        decoration: const InputDecoration(labelText: 'Phone', labelStyle: TextStyle(color: AppColors.textSecondary)),
                        style: const TextStyle(color: AppColors.textPrimary),
                        onSaved: (val) => phone = val ?? '',
                      ),
                      TextFormField(
                        initialValue: email,
                        decoration: const InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: AppColors.textSecondary)),
                        style: const TextStyle(color: AppColors.textPrimary),
                        onSaved: (val) => email = val ?? '',
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: ['NEW', 'CONTACTED', 'INTERESTED', 'DEMO', 'NEGOTIATION', 'WON', 'LOST'].contains(stage) ? stage : 'NEW',
                        decoration: const InputDecoration(labelText: 'Status', labelStyle: TextStyle(color: AppColors.textSecondary)),
                        dropdownColor: AppColors.surface,
                        style: const TextStyle(color: AppColors.textPrimary),
                        items: ['NEW', 'CONTACTED', 'INTERESTED', 'DEMO', 'NEGOTIATION', 'WON', 'LOST']
                            .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (val) => setState(() => stage = val!),
                      ),
                      DropdownButtonFormField<String>(
                        value: sourceId,
                        decoration: const InputDecoration(labelText: 'Source', labelStyle: TextStyle(color: AppColors.textSecondary)),
                        dropdownColor: AppColors.surface,
                        style: const TextStyle(color: AppColors.textPrimary),
                        items: const [
                          DropdownMenuItem(value: 'cmqs1yxc0000614552yrasd3s', child: Text('Website')),
                        ],
                        onChanged: (val) => setState(() => sourceId = val!),
                      ),
                      DropdownButtonFormField<String>(
                        value: assignedToId,
                        decoration: const InputDecoration(labelText: 'Assigned To', labelStyle: TextStyle(color: AppColors.textSecondary)),
                        dropdownColor: AppColors.surface,
                        style: const TextStyle(color: AppColors.textPrimary),
                        items: const [
                          DropdownMenuItem(value: 'cmqs1ywv200021455ssy0r8oz', child: Text('Agent')),
                        ],
                        onChanged: (val) => setState(() => assignedToId = val!),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().add(const Duration(days: 1)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setState(() => followUpDate = date);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Follow-up Date',
                            labelStyle: TextStyle(color: AppColors.textSecondary),
                          ),
                          child: Text(
                            followUpDate == null ? 'Select Date' : '${followUpDate!.day}/${followUpDate!.month}/${followUpDate!.year}',
                            style: TextStyle(color: followUpDate == null ? AppColors.textSecondary : AppColors.textPrimary),
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
                  child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.iconPurple),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      context.read<LeadBloc>().add(LeadEvent.updateLead(lead.id, {
                        'firstName': firstName,
                        'lastName': lastName,
                        'phone': phone,
                        'email': email,
                        'stage': stage,
                        'sourceId': sourceId,
                        'assignedToId': assignedToId,
                        if (followUpDate != null) 'followUpDate': followUpDate!.toIso8601String(),
                      }));
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: const Text('Update', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          }
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, LeadModel lead) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Delete Lead', style: TextStyle(color: AppColors.textPrimary)),
          content: Text('Are you sure you want to delete ${lead.firstName} ${lead.lastName}?', style: const TextStyle(color: AppColors.textSecondary)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () {
                context.read<LeadBloc>().add(LeadEvent.deleteLead(lead.id));
                Navigator.pop(dialogContext);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
