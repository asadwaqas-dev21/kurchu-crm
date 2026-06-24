import 'package:crm_kurchudashboard/core/services/api_client.dart';
import 'package:crm_kurchudashboard/core/constants/api_constants.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/features/itineraries/data/models/itinerary_model.dart';

class ItineraryService {
  ApiClient get _apiClient => getIt<ApiClient>();

  Future<List<ItineraryModel>> getItineraries({String? leadId, String? bookingId}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (leadId != null) queryParameters['leadId'] = leadId;
      if (bookingId != null) queryParameters['bookingId'] = bookingId;

      final response = await _apiClient.get(
        ApiConstants.itineraries,
        queryParameters: queryParameters,
      );

      final List<dynamic> rawItineraries = response.data['data']['itineraries'];
      return rawItineraries.map((e) => ItineraryModel.fromJson(e)).toList();
    } catch (e) {
      print('Exception in getItineraries: $e');
      return [];
    }
  }

  Future<ItineraryModel?> createItinerary(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.itineraries,
        data: data,
      );

      return ItineraryModel.fromJson(response.data['data']['itinerary']);
    } catch (e) {
      print('Exception in createItinerary: $e');
      return null;
    }
  }
}
