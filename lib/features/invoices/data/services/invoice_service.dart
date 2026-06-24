import 'package:crm_kurchudashboard/core/services/api_client.dart';
import 'package:crm_kurchudashboard/core/constants/api_constants.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/features/invoices/data/models/invoice_model.dart';

class InvoiceService {
  ApiClient get _apiClient => getIt<ApiClient>();

  Future<List<InvoiceModel>> getInvoices() async {
    try {
      final response = await _apiClient.get(ApiConstants.invoices);
      final List<dynamic> rawInvoices = response.data['data']['invoices'] ?? [];
      return rawInvoices.map((e) => InvoiceModel.fromJson(e)).toList();
    } catch (e) {
      print('Exception in getInvoices: $e');
      return [];
    }
  }

  Future<InvoiceModel?> createInvoice(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.invoices,
        data: data,
      );
      return InvoiceModel.fromJson(response.data['data']['invoice']);
    } catch (e) {
      print('Exception in createInvoice: $e');
      return null;
    }
  }
}
