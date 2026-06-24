import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_event.freezed.dart';

@freezed
class BookingEvent with _$BookingEvent {
  const factory BookingEvent.started() = _Started;
  const factory BookingEvent.fetchBookings({String? status, String? leadId}) = FetchBookings;
  const factory BookingEvent.addBooking(Map<String, dynamic> data) = AddBooking;
}
