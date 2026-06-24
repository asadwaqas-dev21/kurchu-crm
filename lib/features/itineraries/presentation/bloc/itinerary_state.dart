import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:crm_kurchudashboard/features/itineraries/data/models/itinerary_model.dart';

part 'itinerary_state.freezed.dart';

@freezed
class ItineraryState with _$ItineraryState {
  const factory ItineraryState.initial() = _Initial;
  const factory ItineraryState.loading() = _Loading;
  const factory ItineraryState.loaded(List<ItineraryModel> itineraries) = _Loaded;
  const factory ItineraryState.error(String message) = _Error;
}
