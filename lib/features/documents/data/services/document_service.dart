import 'package:crm_kurchudashboard/core/services/api_client.dart';
import 'package:crm_kurchudashboard/core/constants/api_constants.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/features/documents/data/models/document_model.dart';

class DocumentService {
  ApiClient get _apiClient => getIt<ApiClient>();

  Future<List<DocumentModel>> getDocuments() async {
    try {
      final response = await _apiClient.get(ApiConstants.documents);
      final List<dynamic> rawDocs = response.data['data']['documents'] ?? [];
      return rawDocs.map((e) => DocumentModel.fromJson(e)).toList();
    } catch (e) {
      print('Exception in getDocuments: $e');
      return [];
    }
  }

  Future<DocumentModel?> createDocument(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.documents,
        data: data,
      );
      return DocumentModel.fromJson(response.data['data']['document']);
    } catch (e) {
      print('Exception in createDocument: $e');
      return null;
    }
  }

  Future<bool> deleteDocument(String id) async {
    try {
      await _apiClient.delete('${ApiConstants.documents}/$id');
      return true;
    } catch (e) {
      print('Exception in deleteDocument: $e');
      return false;
    }
  }
}
