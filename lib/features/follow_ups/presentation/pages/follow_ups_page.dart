import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/features/follow_ups/presentation/bloc/follow_up_bloc.dart';
import 'package:crm_kurchudashboard/features/follow_ups/presentation/bloc/follow_up_event.dart';
import 'package:crm_kurchudashboard/features/follow_ups/presentation/bloc/follow_up_state.dart';
import 'package:crm_kurchudashboard/features/follow_ups/data/models/follow_up_model.dart';
import 'package:crm_kurchudashboard/features/leads/data/services/lead_service.dart';
import 'package:crm_kurchudashboard/features/leads/data/models/lead_model.dart';

class FollowUpsPage extends StatefulWidget {
  const FollowUpsPage({super.key});

  @override
  State<FollowUpsPage> createState() => _FollowUpsPageState();
}

class _FollowUpsPageState extends State<FollowUpsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Follow-ups',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      GestureDetector(
                        onTap: () => _showAddFollowUpDialog(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.iconPurple,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: const [
                              Icon(Iconsax.add, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Add Follow-up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        TabBar(
                          controller: _tabController,
                          labelColor: AppColors.iconPurple,
                          unselectedLabelColor: AppColors.textSecondary,
                          indicatorColor: AppColors.iconPurple,
                          tabs: const [
                            Tab(text: 'Today'),
                            Tab(text: 'Overdue'),
                            Tab(text: 'Upcoming'),
                          ],
                        ),
                        SizedBox(
                          height: 500,
                          child: BlocBuilder<FollowUpBloc, FollowUpState>(
                            builder: (context, state) {
                              return state.maybeWhen(
                                loading: () => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                error: (message) => Center(
                                  child: Text(
                                    'Error: $message',
                                    style: TextStyle(color: AppColors.error),
                                  ),
                                ),
                                loaded: (followUps) {
                                  final now = DateTime.now();
                                  final today = DateTime(
                                    now.year,
                                    now.month,
                                    now.day,
                                  );

                                  final todayFollowUps = followUps
                                      .where(
                                        (f) =>
                                            f.scheduledAt.isAfter(today) &&
                                            f.scheduledAt.isBefore(
                                              today.add(
                                                const Duration(days: 1),
                                              ),
                                            ),
                                      )
                                      .toList();

                                  final overdueFollowUps = followUps
                                      .where(
                                        (f) =>
                                            f.scheduledAt.isBefore(today) &&
                                            !f.isCompleted,
                                      )
                                      .toList();

                                  final upcomingFollowUps = followUps
                                      .where(
                                        (f) => f.scheduledAt.isAfter(
                                          today.add(const Duration(days: 1)),
                                        ),
                                      )
                                      .toList();

                                  return TabBarView(
                                    controller: _tabController,
                                    children: [
                                      _buildFollowUpList(todayFollowUps),
                                      _buildFollowUpList(overdueFollowUps),
                                      _buildFollowUpList(upcomingFollowUps),
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
                ],
              ),
            ),
          );
  }

  Widget _buildFollowUpList(List<FollowUpModel> followUps) {
    if (followUps.isEmpty) {
      return const Center(child: Text('No follow-ups found.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: followUps.length,
      separatorBuilder: (context, index) => Divider(color: AppColors.border),
      itemBuilder: (context, index) {
        final followUp = followUps[index];
        final timeStr =
            '${followUp.scheduledAt.hour.toString().padLeft(2, '0')}:${followUp.scheduledAt.minute.toString().padLeft(2, '0')}';
        final leadName = followUp.lead != null
            ? '${followUp.lead!.firstName} ${followUp.lead!.lastName}'
            : 'Lead ID: ${followUp.leadId}';
        return _buildFollowUpItem(leadName, timeStr, true);
      },
    );
  }

  Widget _buildFollowUpItem(String name, String time, bool isCall) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isCall
                ? AppColors.iconBgBlue
                : AppColors.iconBgPurple,
            child: Icon(
              isCall ? Iconsax.call : Iconsax.user,
              color: isCall ? AppColors.iconBlue : AppColors.iconPurple,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(time, style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(width: 24),
          Row(
            children: [
              IconButton(
                icon: Icon(Iconsax.call, color: AppColors.iconGreen, size: 20),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Iconsax.message,
                  color: AppColors.iconBlue,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddFollowUpDialog(BuildContext context) {
    final followUpBloc = context.read<FollowUpBloc>();
    final formKey = GlobalKey<FormState>();
    String? selectedLeadId;
    String type = 'CALL';
    String status = 'PENDING';
    String notes = '';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'Add Follow-up',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content:
              FutureBuilder<
                ({List<LeadModel> leads, int total, int skip, int limit})
              >(
                future: getIt<LeadService>().getLeads(limit: 100),
                builder: (futureContext, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.leads.isEmpty) {
                    return SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          'No leads found. Please create a lead first.',
                          style: TextStyle(color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  final leads = snapshot.data!.leads;

                  return StatefulBuilder(
                    builder: (statefulContext, setState) {
                      if (selectedLeadId == null ||
                          !leads.any((l) => l.id == selectedLeadId)) {
                        selectedLeadId = leads.first.id;
                      }

                      return Form(
                        key: formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DropdownButtonFormField<String>(
                                initialValue: selectedLeadId,
                                decoration: InputDecoration(
                                  labelText: 'Select Lead',
                                  labelStyle: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                dropdownColor: AppColors.surface,
                                style: TextStyle(color: AppColors.textPrimary),
                                items: leads.map((l) {
                                  return DropdownMenuItem(
                                    value: l.id,
                                    child: Text('${l.firstName} ${l.lastName}'),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => selectedLeadId = val);
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Notes',
                                  labelStyle: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                style: TextStyle(color: AppColors.textPrimary),
                                onSaved: (val) => notes = val ?? '',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
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
                if (selectedLeadId == null) return;
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  followUpBloc.add(
                    FollowUpEvent.addFollowUp({
                      'leadId': selectedLeadId,
                      'type': type,
                      'scheduledAt': DateTime.now()
                          .add(const Duration(days: 1))
                          .toUtc()
                          .toIso8601String(),
                      'status': status,
                      'notes': notes,
                    }),
                  );
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
