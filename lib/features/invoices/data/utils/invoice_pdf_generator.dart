import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:crm_kurchudashboard/features/invoices/data/models/invoice_model.dart';
import 'package:intl/intl.dart';

class InvoicePdfGenerator {
  static Future<Uint8List> generate(InvoiceModel invoice) async {
    final pdf = pw.Document();

    final dateFormater = DateFormat('dd MMM yyyy');
    final currencyFormatter = NumberFormat.decimalPattern();

    final booking = invoice.booking;
    final lead = booking?.lead;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // Header: Company details and Invoice label
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'KURCHU CRM',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex(
                          '#7C3AED',
                        ), // AppColors.iconPurple
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Kurchu Demo Company',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text('123 Business Street, Lahore'),
                    pw.Text('info@kurchucrm.com'),
                    pw.Text('+92-300-1234567'),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('#1E293B'),
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Invoice No: ${invoice.number}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text('Date: ${dateFormater.format(invoice.issuedAt)}'),
                    pw.Text(
                      'Due Date: ${dateFormater.format(invoice.dueDate)}',
                    ),
                    pw.Text(
                      'Status: ${invoice.status}',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: invoice.status.toUpperCase() == 'PAID'
                            ? PdfColor.fromHex('#10B981')
                            : PdfColor.fromHex('#F59E0B'),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 32),
            pw.Divider(color: PdfColor.fromHex('#E2E8F0')),
            pw.SizedBox(height: 24),

            // Bill To details
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'BILL TO:',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('#64748B'),
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      lead != null
                          ? '${lead.firstName} ${lead.lastName}'
                          : 'Valued Customer',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('#1E293B'),
                      ),
                    ),
                    if (lead?.email != null) pw.Text(lead!.email),
                    pw.Text(
                      'Booking ID: #${invoice.bookingId.substring(0, 8)}',
                    ),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 32),

            // Invoice Items Table
            pw.Table(
              border: const pw.TableBorder(
                horizontalInside: pw.BorderSide(
                  color: PdfColors.grey200,
                  width: 0.5,
                ),
                bottom: pw.BorderSide(color: PdfColors.grey300, width: 1),
              ),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Description',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#1E293B'),
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Booking ID',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#1E293B'),
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'Amount',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#1E293B'),
                        ),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('CRM System Service / Setup Fee'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text('#${invoice.bookingId.substring(0, 8)}'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'PKR ${currencyFormatter.format(invoice.amount.toInt())}',
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 32),

            // Summary section on the right side
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Container(
                      width: 250,
                      child: pw.Column(
                        children: [
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'Subtotal:',
                                style: const pw.TextStyle(
                                  color: PdfColors.grey700,
                                ),
                              ),
                              pw.Text(
                                'PKR ${currencyFormatter.format(invoice.amount.toInt())}',
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 8),
                          pw.Divider(color: PdfColors.grey200),
                          pw.SizedBox(height: 8),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'Total:',
                                style: pw.TextStyle(
                                  fontSize: 16,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColor.fromHex('#1E293B'),
                                ),
                              ),
                              pw.Text(
                                'PKR ${currencyFormatter.format(invoice.amount.toInt())}',
                                style: pw.TextStyle(
                                  fontSize: 16,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColor.fromHex('#7C3AED'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 64),
            pw.Center(
              child: pw.Text(
                'Thank you for your business!',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontStyle: pw.FontStyle.italic,
                  color: PdfColors.grey500,
                ),
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }
}
