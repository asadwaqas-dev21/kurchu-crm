import 'package:crm_kurchudashboard/core/services/api_client.dart';
import 'package:crm_kurchudashboard/core/constants/api_constants.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/features/follow_ups/data/models/follow_up_model.dart';

class FollowUpService {
  ApiClient get _apiClient => getIt<ApiClient>();

  Future<List<FollowUpModel>> getFollowUps({bool? isCompleted}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (isCompleted != null) queryParameters['isCompleted'] = isCompleted;

      final response = await _apiClient.get(
        ApiConstants.followUps,
        queryParameters: queryParameters,
      );

      final List<dynamic> raw = response.data['data']['followUps'];
      return raw.map((e) => FollowUpModel.fromJson(e)).toList();
    } catch (e) {
      print('Exception in getFollowUps: $e');
      return [];
    }
  }

  Future<FollowUpModel?> createFollowUp(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.followUps,
        data: data,
      );

      return FollowUpModel.fromJson(response.data['data']['followUp']);
    } catch (e) {
      print('Exception in createFollowUp: $e');
      return null;
    }
  }

  Future<FollowUpModel?> updateFollowUp(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put(
        '${ApiConstants.followUps}/$id',
        data: data,
      );

      return FollowUpModel.fromJson(response.data['data']['followUp']);
    } catch (e) {
      print('Exception in updateFollowUp: $e');
      return null;
    }
  }
}
