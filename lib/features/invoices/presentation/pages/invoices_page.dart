import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/features/invoices/data/services/invoice_service.dart';
import 'package:crm_kurchudashboard/features/invoices/data/models/invoice_model.dart';
import 'package:crm_kurchudashboard/features/bookings/data/services/booking_service.dart';
import 'package:crm_kurchudashboard/features/bookings/data/models/booking_model.dart';
import 'package:crm_kurchudashboard/features/leads/data/services/lead_service.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:crm_kurchudashboard/features/invoices/data/utils/invoice_pdf_generator.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key});

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  bool _isLoading = true;
  String? _error;
  List<InvoiceModel> _invoices = [];

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    try {
      final invoiceService = getIt<InvoiceService>();
      final invoices = await invoiceService.getInvoices();
      if (!mounted) return;
      setState(() {
        _invoices = invoices;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PAID':
        return AppColors.success;
      case 'PENDING':
        return AppColors.warning;
      case 'SENT':
        return AppColors.iconBlue;
      case 'OVERDUE':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toUpperCase()) {
      case 'PAID':
        return AppColors.iconBgGreen;
      case 'PENDING':
        return AppColors.iconBgOrange;
      case 'SENT':
        return AppColors.iconBgBlue;
      case 'OVERDUE':
        return const Color(0xFFFCE7F3);
      default:
        return AppColors.surface;
    }
  }

  void _showAddInvoiceDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => AddInvoiceDialog(currentInvoices: _invoices),
    );

    if (result != null && mounted) {
      setState(() {
        _isLoading = true;
      });
      try {
        final invoiceService = getIt<InvoiceService>();
        final newInvoice = await invoiceService.createInvoice(result);
        if (newInvoice != null) {
          _loadInvoices();
        } else {
          setState(() {
            _isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to create invoice')),
            );
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            'Error loading invoices: $_error',
            style: TextStyle(color: AppColors.error),
          ),
        ),
      );
    }

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invoices',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'View and manage all invoices.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => _showAddInvoiceDialog(context),
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
                          'New Invoice',
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
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (_invoices.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.all(48.0),
                      child: Center(
                        child: Text(
                          'No invoices found.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    );
                  }
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
                        ),
                        columns: const [
                          DataColumn(label: Text('Invoice No.')),
                          DataColumn(label: Text('Customer')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Amount')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: _invoices.map((invoice) {
                          final leadName = invoice.booking?.lead != null
                              ? '${invoice.booking!.lead!.firstName} ${invoice.booking!.lead!.lastName}'
                              : 'Customer (${invoice.bookingId.substring(0, 8)})';
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  invoice.number,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(Text(leadName)),
                              DataCell(Text(_formatDate(invoice.issuedAt))),
                              DataCell(
                                Text(
                                  'PKR ${NumberFormat.decimalPattern().format(invoice.amount.toInt())}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusBgColor(invoice.status),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    invoice.status,
                                    style: TextStyle(
                                      color: _getStatusColor(invoice.status),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        try {
                                          final pdfBytes =
                                              await InvoicePdfGenerator.generate(
                                                invoice,
                                              );
                                          await Printing.sharePdf(
                                            bytes: pdfBytes,
                                            filename:
                                                'invoice_${invoice.number}.pdf',
                                          );
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Error downloading PDF: $e',
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: Icon(
                                        Iconsax.document_download,
                                        size: 20,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: () async {
                                        try {
                                          final pdfBytes =
                                              await InvoicePdfGenerator.generate(
                                                invoice,
                                              );
                                          await Printing.layoutPdf(
                                            onLayout: (format) async =>
                                                pdfBytes,
                                            name: 'invoice_${invoice.number}',
                                          );
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Error printing PDF: $e',
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: Icon(
                                        Iconsax.printer,
                                        size: 20,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddInvoiceDialog extends StatefulWidget {
  final List<InvoiceModel> currentInvoices;
  const AddInvoiceDialog({required this.currentInvoices, super.key});

  @override
  State<AddInvoiceDialog> createState() => _AddInvoiceDialogState();
}

class _AddInvoiceDialogState extends State<AddInvoiceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  bool _isLoading = true;
  String? _error;
  List<BookingModel> _availableBookings = [];
  Map<String, String> _leadNames = {};

  String? _selectedBookingId;
  DateTime _selectedDueDate = DateTime.now().add(const Duration(days: 30));
  String _selectedStatus = 'DRAFT';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final bookingService = getIt<BookingService>();
      final leadService = getIt<LeadService>();

      final bookings = await bookingService.getBookings();
      final leadsResult = await leadService.getLeads(limit: 100);

      final leadMap = {
        for (var lead in leadsResult.leads)
          lead.id: '${lead.firstName} ${lead.lastName}',
      };

      // Filter out bookings that already have invoices
      final usedBookingIds = widget.currentInvoices
          .map((i) => i.bookingId)
          .toSet();
      final filteredBookings = bookings
          .where((b) => !usedBookingIds.contains(b.id))
          .toList();

      if (!mounted) return;

      setState(() {
        _availableBookings = filteredBookings;
        _leadNames = leadMap;
        _isLoading = false;

        if (_availableBookings.isNotEmpty) {
          _selectedBookingId = _availableBookings.first.id;
          _amountController.text = _availableBookings.first.amount.toString();
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

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.iconPurple,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDueDate) {
      setState(() {
        _selectedDueDate = picked;
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
          'Error Loading Data',
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

    if (_availableBookings.isEmpty) {
      return AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'New Invoice',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'No uninvoiced bookings found. All current bookings have invoices, or no bookings exist. Please create a booking first.',
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
        'New Invoice',
        style: TextStyle(color: AppColors.textPrimary),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking Dropdown
              Text(
                'Booking',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                dropdownColor: AppColors.surface,
                style: TextStyle(color: AppColors.textPrimary),
                initialValue: _selectedBookingId,
                items: _availableBookings.map((b) {
                  final leadName =
                      _leadNames[b.leadId] ??
                      'Lead ${b.leadId.substring(0, 8)}';
                  return DropdownMenuItem<String>(
                    value: b.id,
                    child: Text(
                      '#${b.id.substring(0, 8)} - $leadName (PKR ${b.amount.toInt()})',
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedBookingId = val;
                    final selectedBooking = _availableBookings.firstWhere(
                      (b) => b.id == val,
                    );
                    _amountController.text = selectedBooking.amount.toString();
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
                validator: (val) =>
                    val == null ? 'Please select a booking' : null,
              ),
              const SizedBox(height: 16),

              // Total Amount
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(color: AppColors.textPrimary),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter an invoice amount';
                  }
                  if (double.tryParse(val) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Status Dropdown
              Text(
                'Status',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                dropdownColor: AppColors.surface,
                style: TextStyle(color: AppColors.textPrimary),
                initialValue: _selectedStatus,
                items: const [
                  DropdownMenuItem(value: 'DRAFT', child: Text('Draft')),
                  DropdownMenuItem(value: 'SENT', child: Text('Sent')),
                  DropdownMenuItem(value: 'PAID', child: Text('Paid')),
                  DropdownMenuItem(value: 'OVERDUE', child: Text('Overdue')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedStatus = val;
                    });
                  }
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
              ),
              const SizedBox(height: 16),

              // Due Date Picker
              Text(
                'Due Date',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDueDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd MMM yyyy').format(_selectedDueDate),
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                      Icon(
                        Iconsax.calendar,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
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
              final amount = double.tryParse(_amountController.text) ?? 0;
              Navigator.pop(context, {
                'bookingId': _selectedBookingId,
                'amount': amount,
                'status': _selectedStatus,
                'dueDate': _selectedDueDate.toIso8601String(),
              });
            }
          },
          child: const Text(
            'Save',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
