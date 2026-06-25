import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/features/itineraries/presentation/bloc/itinerary_bloc.dart';
import 'package:crm_kurchudashboard/features/itineraries/presentation/bloc/itinerary_event.dart';
import 'package:crm_kurchudashboard/features/itineraries/presentation/bloc/itinerary_state.dart';
import 'package:crm_kurchudashboard/features/leads/data/services/lead_service.dart';
import 'package:crm_kurchudashboard/features/leads/data/models/lead_model.dart';

class ItinerariesPage extends StatelessWidget {
  const ItinerariesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ItineraryBloc>()..add(const ItineraryEvent.fetchItineraries()),
      child: Builder(
        builder: (context) {
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
                        'Itineraries',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      GestureDetector(
                        onTap: () => _showAddItineraryDialog(context),
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
                                'Create Itinerary',
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
                  BlocBuilder<ItineraryBloc, ItineraryState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (message) => Center(
                          child: Text(
                            'Error: $message',
                            style: TextStyle(color: AppColors.error),
                          ),
                        ),
                        loaded: (itineraries) {
                          if (itineraries.isEmpty) {
                            return const Center(
                              child: Text('No itineraries found.'),
                            );
                          }
                          return GridView.count(
                            crossAxisCount: 3,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: itineraries.map((itinerary) {
                              final duration = itinerary.endDate
                                  .difference(itinerary.startDate)
                                  .inDays;
                              return _buildItineraryCard(
                                itinerary.title,
                                '$duration Nights / ${duration + 1} Days',
                                'N/A', // We can map price if needed
                              );
                            }).toList(),
                          );
                        },
                        orElse: () => const SizedBox(),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItineraryCard(String title, String duration, String price) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.iconBgBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(Iconsax.map, size: 40, color: AppColors.iconBlue),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            duration,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const Spacer(),
          Text(
            price,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.iconGreen,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddItineraryDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => const AddItineraryDialog(),
    );

    if (result != null && context.mounted) {
      context.read<ItineraryBloc>().add(ItineraryEvent.addItinerary(result));
    }
  }
}

class AddItineraryDialog extends StatefulWidget {
  const AddItineraryDialog({super.key});

  @override
  State<AddItineraryDialog> createState() => _AddItineraryDialogState();
}

class _AddItineraryDialogState extends State<AddItineraryDialog> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';

  List<LeadModel> _leads = [];
  bool _isLoading = true;
  String? _error;
  String? _selectedLeadId;

  @override
  void initState() {
    super.initState();
    _loadLeads();
  }

  Future<void> _loadLeads() async {
    try {
      final leadService = getIt<LeadService>();
      final leadsResult = await leadService.getLeads(limit: 100);

      if (!mounted) return;
      setState(() {
        _leads = leadsResult.leads;
        _isLoading = false;
        if (_leads.isNotEmpty) {
          _selectedLeadId = _leads.first.id;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return AlertDialog(
        backgroundColor: AppColors.surface,
        content: SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_error != null) {
      return AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Error Loading Leads',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(_error!, style: TextStyle(color: AppColors.error)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      );
    }

    if (_leads.isEmpty) {
      return AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Add Itinerary',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'No leads found in the database. Please create a lead first.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      );
    }

    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(
        'Add Itinerary',
        style: TextStyle(color: AppColors.textPrimary),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lead Dropdown
              Text(
                'Lead',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                dropdownColor: AppColors.surface,
                style: TextStyle(color: AppColors.textPrimary),
                value: _selectedLeadId,
                items: _leads.map((lead) {
                  return DropdownMenuItem<String>(
                    value: lead.id,
                    child: Text('${lead.firstName} ${lead.lastName}'),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedLeadId = val;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                validator: (val) => val == null ? 'Please select a lead' : null,
              ),
              const SizedBox(height: 16),

              // Title
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(color: AppColors.textPrimary),
                onSaved: (val) => _title = val ?? '',
                validator: (val) =>
                    (val == null || val.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(color: AppColors.textPrimary),
                onSaved: (val) => _description = val ?? '',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
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
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();

              Navigator.pop(context, {
                'leadId': _selectedLeadId,
                'title': _title,
                'description': _description,
                'startDate': DateTime.now().toIso8601String(),
                'endDate': DateTime.now()
                    .add(const Duration(days: 3))
                    .toIso8601String(),
              });
            }
          },
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
