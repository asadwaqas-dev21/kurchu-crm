import 'package:freezed_annotation/freezed_annotation.dart';

part 'itinerary_event.freezed.dart';

@freezed
class ItineraryEvent with _$ItineraryEvent {
  const factory ItineraryEvent.started() = _Started;
  const factory ItineraryEvent.fetchItineraries({String? leadId, String? bookingId}) = FetchItineraries;
  const factory ItineraryEvent.addItinerary(Map<String, dynamic> data) = AddItinerary;
}
