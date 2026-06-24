import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crm_kurchudashboard/features/itineraries/data/services/itinerary_service.dart';
import 'itinerary_event.dart';
import 'itinerary_state.dart';

class ItineraryBloc extends Bloc<ItineraryEvent, ItineraryState> {
  final ItineraryService itineraryService;

  ItineraryBloc({required this.itineraryService}) : super(const ItineraryState.initial()) {
    on<FetchItineraries>(_onFetchItineraries);
    on<AddItinerary>(_onAddItinerary);
  }

  Future<void> _onFetchItineraries(FetchItineraries event, Emitter<ItineraryState> emit) async {
    emit(const ItineraryState.loading());
    try {
      final itineraries = await itineraryService.getItineraries(
        leadId: event.leadId,
        bookingId: event.bookingId,
      );
      emit(ItineraryState.loaded(itineraries));
    } catch (e) {
      emit(ItineraryState.error(e.toString()));
    }
  }

  Future<void> _onAddItinerary(AddItinerary event, Emitter<ItineraryState> emit) async {
    try {
      final itinerary = await itineraryService.createItinerary(event.data);
      if (itinerary != null) {
        add(const FetchItineraries());
      } else {
        emit(const ItineraryState.error('Failed to add itinerary'));
      }
    } catch (e) {
      emit(ItineraryState.error(e.toString()));
    }
  }
}
