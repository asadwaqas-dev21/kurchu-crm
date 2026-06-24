import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/features/bookings/presentation/bloc/booking_bloc.dart';
import 'package:crm_kurchudashboard/features/bookings/presentation/bloc/booking_event.dart';
import 'package:crm_kurchudashboard/features/bookings/presentation/bloc/booking_state.dart';
import 'package:crm_kurchudashboard/features/bookings/data/models/booking_model.dart';
import 'package:crm_kurchudashboard/features/leads/data/services/lead_service.dart';
import 'package:crm_kurchudashboard/features/leads/data/models/lead_model.dart';
import 'package:crm_kurchudashboard/core/services/api_client.dart';
import 'package:crm_kurchudashboard/core/constants/api_constants.dart';

class BookingsPage extends StatelessWidget {
  const BookingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BookingBloc>()..add(const BookingEvent.fetchBookings()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bookings',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showAddBookingDialog(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.iconPurple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: const [
                          Icon(Iconsax.add, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('New Booking', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(color: AppColors.border),
                  bottom: BorderSide(color: AppColors.border),
                ),
              ),
              child: BlocBuilder<BookingBloc, BookingState>(
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
                      loaded: (bookings) {
                        if (bookings.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(48.0),
                            child: Center(child: Text('No bookings found.')),
                          );
                        }
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                child: DataTable(
                                  headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                                  columns: const [
                                    DataColumn(label: Text('Booking ID')),
                                    DataColumn(label: Text('Lead ID')),
                                    DataColumn(label: Text('Booking Date')),
                                    DataColumn(label: Text('Total Amount')),
                                    DataColumn(label: Text('Paid Amount')),
                                    DataColumn(label: Text('Status')),
                                  ],
                                  rows: bookings.map((booking) {
                                    return _buildRow(
                                      booking.id.substring(0, 8), // Short ID
                                      booking.leadId.substring(0, 8),
                                      '${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year}',
                                      'PKR ${booking.amount}',
                                      'PKR ${booking.collectedAmount}',
                                      booking.status,
                                      _getStatusColor(booking.status),
                                      _getStatusBgColor(booking.status),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          }
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

  DataRow _buildRow(String id, String leadId, String date, String total, String paid, String status, Color sColor, Color bg) {
    return DataRow(
      cells: [
        DataCell(Text(id, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(leadId)),
        DataCell(Text(date)),
        DataCell(Text(total, style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(paid)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
            child: Text(status, style: TextStyle(color: sColor, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING': return AppColors.warning;
      case 'CONFIRMED': return AppColors.success;
      case 'COMPLETED': return AppColors.iconBlue;
      case 'CANCELLED': return AppColors.error;
      default: return AppColors.textSecondary;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING': return AppColors.iconBgOrange;
      case 'CONFIRMED': return AppColors.iconBgGreen;
      case 'COMPLETED': return AppColors.iconBgBlue;
      case 'CANCELLED': return const Color(0xFFFCE7F3);
      default: return AppColors.surface;
    }
  }

  void _showAddBookingDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => const AddBookingDialog(),
    );

    if (result != null && context.mounted) {
      context.read<BookingBloc>().add(BookingEvent.addBooking(result));
    }
  }
}

class AddBookingDialog extends StatefulWidget {
  const AddBookingDialog({Key? key}) : super(key: key);

  @override
  State<AddBookingDialog> createState() => _AddBookingDialogState();
}

class _AddBookingDialogState extends State<AddBookingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _collectedAmountController = TextEditingController();

  List<LeadModel> _leads = [];
  List<Map<String, dynamic>> _services = [];
  bool _isLoading = true;
  String? _error;

  String? _selectedLeadId;
  String? _selectedServiceId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _collectedAmountController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final leadService = getIt<LeadService>();
      final apiClient = getIt<ApiClient>();

      // Fetch leads
      final leadsResult = await leadService.getLeads(limit: 100);
      
      // Fetch services
      final servicesResponse = await apiClient.get(ApiConstants.companyServices);
      final List<dynamic> rawServices = servicesResponse.data['data']['services'] ?? [];
      final services = rawServices.map((e) => Map<String, dynamic>.from(e)).toList();

      if (!mounted) return;

      setState(() {
        _leads = leadsResult.leads;
        _services = services;
        _isLoading = false;
        
        if (_leads.isNotEmpty) {
          _selectedLeadId = _leads.first.id;
        }
        if (_services.isNotEmpty) {
          _selectedServiceId = _services.first['id'];
          _amountController.text = _services.first['price']?.toString() ?? '0';
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
      return const AlertDialog(
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
        title: const Text('Error Loading Data', style: TextStyle(color: AppColors.textPrimary)),
        content: Text(_error!, style: const TextStyle(color: AppColors.error)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: AppColors.textSecondary)),
          ),
        ],
      );
    }

    if (_leads.isEmpty || _services.isEmpty) {
      return AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Add Booking', style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
          _leads.isEmpty && _services.isEmpty
              ? 'No leads and no services found in the database. Please create a lead and a company service first.'
              : _leads.isEmpty
                  ? 'No leads found. Please create a lead first.'
                  : 'No company services found. Please create a service first.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: AppColors.textSecondary)),
          ),
        ],
      );
    }

    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text('Add Booking', style: TextStyle(color: AppColors.textPrimary)),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lead Dropdown
              const Text('Lead', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                dropdownColor: AppColors.surface,
                style: const TextStyle(color: AppColors.textPrimary),
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                validator: (val) => val == null ? 'Please select a lead' : null,
              ),
              const SizedBox(height: 16),

              // Service Dropdown
              const Text('Service', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                dropdownColor: AppColors.surface,
                style: const TextStyle(color: AppColors.textPrimary),
                value: _selectedServiceId,
                items: _services.map((service) {
                  return DropdownMenuItem<String>(
                    value: service['id'],
                    child: Text('${service['name']} (PKR ${service['price']})'),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedServiceId = val;
                    // Auto-fill price
                    final selectedService = _services.firstWhere((element) => element['id'] == val);
                    _amountController.text = selectedService['price']?.toString() ?? '0';
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                validator: (val) => val == null ? 'Please select a service' : null,
              ),
              const SizedBox(height: 16),

              // Total Amount
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Total Amount',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: AppColors.textPrimary),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter total amount';
                  if (double.tryParse(val) == null) return 'Please enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Collected Amount
              TextFormField(
                controller: _collectedAmountController,
                decoration: const InputDecoration(
                  labelText: 'Collected Amount',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: AppColors.textPrimary),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val != null && val.isNotEmpty && double.tryParse(val) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.iconPurple),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final amount = double.tryParse(_amountController.text) ?? 0;
              final collectedAmount = double.tryParse(_collectedAmountController.text) ?? 0;
              
              Navigator.pop(context, {
                'leadId': _selectedLeadId,
                'serviceId': _selectedServiceId,
                'bookingDate': DateTime.now().toIso8601String(),
                'amount': amount,
                'collectedAmount': collectedAmount,
              });
            }
          },
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
