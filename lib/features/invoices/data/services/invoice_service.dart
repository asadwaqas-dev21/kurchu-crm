import 'package:crm_kurchudashboard/core/services/api_client.dart';
import 'package:crm_kurchudashboard/core/constants/api_constants.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/features/invoices/data/models/invoice_model.dart';
import 'package:flutter/foundation.dart';

class InvoiceService {
  ApiClient get _apiClient => getIt<ApiClient>();
  List<InvoiceModel>? _cachedInvoices;

  Future<List<InvoiceModel>> getInvoices({bool forceRefresh = false}) async {
    if (_cachedInvoices != null && !forceRefresh) {
      return _cachedInvoices!;
    }
    try {
      final response = await _apiClient.get(ApiConstants.invoices);
      final List<dynamic> rawInvoices = response.data['data']['invoices'] ?? [];
      _cachedInvoices = rawInvoices
          .map((e) => InvoiceModel.fromJson(e))
          .toList();
      return _cachedInvoices!;
    } catch (e) {
      if (kDebugMode) {
        print('Exception in getInvoices: $e');
      }
      return _cachedInvoices ?? [];
    }
  }

  Future<InvoiceModel?> createInvoice(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post(ApiConstants.invoices, data: data);
      final newInvoice = InvoiceModel.fromJson(
        response.data['data']['invoice'],
      );
      if (_cachedInvoices != null) {
        _cachedInvoices!.insert(0, newInvoice);
      }
      return newInvoice;
    } catch (e) {
      if (kDebugMode) {
        print('Exception in createInvoice: $e');
      }
      return null;
    }
  }
}
