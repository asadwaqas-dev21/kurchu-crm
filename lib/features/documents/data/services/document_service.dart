import 'package:crm_kurchudashboard/core/services/api_client.dart';
import 'package:crm_kurchudashboard/core/constants/api_constants.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/features/documents/data/models/document_model.dart';
import 'package:flutter/foundation.dart';

class DocumentService {
  ApiClient get _apiClient => getIt<ApiClient>();
  List<DocumentModel>? _cachedDocuments;

  List<DocumentModel>? get cachedDocuments => _cachedDocuments;

  void clearCache() {
    _cachedDocuments = null;
  }

  Future<List<DocumentModel>> getDocuments({bool forceRefresh = false}) async {
    if (_cachedDocuments != null && !forceRefresh) {
      return _cachedDocuments!;
    }
    try {
      final response = await _apiClient.get(ApiConstants.documents);
      final List<dynamic> rawDocs = response.data['data']['documents'] ?? [];
      _cachedDocuments = rawDocs.map((e) => DocumentModel.fromJson(e)).toList();
      return _cachedDocuments!;
    } catch (e) {
      if (kDebugMode) {
        print('Exception in getDocuments: $e');
      }
      return _cachedDocuments ?? [];
    }
  }

  Future<DocumentModel?> createDocument(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.documents,
        data: data,
      );
      final newDoc = DocumentModel.fromJson(response.data['data']['document']);
      if (_cachedDocuments != null) {
        _cachedDocuments!.insert(0, newDoc);
      }
      return newDoc;
    } catch (e) {
      if (kDebugMode) {
        print('Exception in createDocument: $e');
      }
      return null;
    }
  }

  Future<bool> deleteDocument(String id) async {
    try {
      await _apiClient.delete('${ApiConstants.documents}/$id');
      if (_cachedDocuments != null) {
        _cachedDocuments!.removeWhere((element) => element.id == id);
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Exception in deleteDocument: $e');
      }
      return false;
    }
  }
}
