import 'package:crm_kurchudashboard/core/services/api_client.dart';
import 'package:crm_kurchudashboard/core/constants/api_constants.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/features/leads/data/models/lead_model.dart';
import 'package:flutter/foundation.dart';

class LeadService {
  ApiClient get _apiClient => getIt<ApiClient>();

  Future<({List<LeadModel> leads, int total, int skip, int limit})> getLeads({
    String? stage,
    String? assignedToId,
    int? skip,
    int? limit,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (stage != null) queryParameters['stage'] = stage;
      if (assignedToId != null) queryParameters['assignedToId'] = assignedToId;
      if (skip != null) queryParameters['skip'] = skip;
      if (limit != null) queryParameters['limit'] = limit;

      final response = await _apiClient.get(
        ApiConstants.leads,
        queryParameters: queryParameters,
      );

      final List<dynamic> rawLeads = response.data['data']['leads'];
      final List<LeadModel> leads = rawLeads
          .map((e) => LeadModel.fromJson(e))
          .toList();

      final pagination = response.data['data']['pagination'];
      int total = leads.length;
      int responseSkip = skip ?? 0;
      int responseLimit = limit ?? 10;
      if (pagination != null) {
        total = pagination['total'] ?? total;
        responseSkip = pagination['skip'] ?? responseSkip;
        responseLimit = pagination['limit'] ?? responseLimit;
      }

      return (
        leads: leads,
        total: total,
        skip: responseSkip,
        limit: responseLimit,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Exception in getLeads: $e');
      }
      return (
        leads: <LeadModel>[],
        total: 0,
        skip: skip ?? 0,
        limit: limit ?? 10,
      );
    }
  }

  Future<LeadModel?> createLead(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post(ApiConstants.leads, data: data);

      return LeadModel.fromJson(response.data['data']['lead']);
    } catch (e) {
      if (kDebugMode) {
        print('Exception in createLead: $e');
      }
      return null;
    }
  }

  Future<LeadModel?> updateLead(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put(
        '${ApiConstants.leads}/$id',
        data: data,
      );

      return LeadModel.fromJson(response.data['data']['lead']);
    } catch (e) {
      if (kDebugMode) {
        print('Exception in updateLead: $e');
      }
      return null;
    }
  }

  Future<bool> deleteLead(String id) async {
    try {
      await _apiClient.delete('${ApiConstants.leads}/$id');
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Exception in deleteLead: $e');
      }
      return false;
    }
  }
}
