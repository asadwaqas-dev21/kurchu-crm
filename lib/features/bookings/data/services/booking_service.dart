import 'package:crm_kurchudashboard/core/services/api_client.dart';
import 'package:crm_kurchudashboard/core/constants/api_constants.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/features/bookings/data/models/booking_model.dart';

class BookingService {
  ApiClient get _apiClient => getIt<ApiClient>();

  Future<List<BookingModel>> getBookings({String? status, String? leadId}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (status != null) queryParameters['status'] = status;
      if (leadId != null) queryParameters['leadId'] = leadId;

      final response = await _apiClient.get(
        ApiConstants.bookings,
        queryParameters: queryParameters,
      );

      final List<dynamic> rawBookings = response.data['data']['bookings'];
      return rawBookings.map((e) => BookingModel.fromJson(e)).toList();
    } catch (e) {
      print('Exception in getBookings: $e');
      return [];
    }
  }

  Future<BookingModel?> createBooking(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.bookings,
        data: data,
      );

      return BookingModel.fromJson(response.data['data']['booking']);
    } catch (e) {
      print('Exception in createBooking: $e');
      return null;
    }
  }
}
