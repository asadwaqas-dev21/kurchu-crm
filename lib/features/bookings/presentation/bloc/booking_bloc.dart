import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crm_kurchudashboard/features/bookings/data/services/booking_service.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingService bookingService;

  BookingBloc({required this.bookingService}) : super(const BookingState.initial()) {
    on<FetchBookings>(_onFetchBookings);
    on<AddBooking>(_onAddBooking);
  }

  Future<void> _onFetchBookings(FetchBookings event, Emitter<BookingState> emit) async {
    emit(const BookingState.loading());
    try {
      final bookings = await bookingService.getBookings(
        status: event.status,
        leadId: event.leadId,
      );
      emit(BookingState.loaded(bookings));
    } catch (e) {
      emit(BookingState.error(e.toString()));
    }
  }

  Future<void> _onAddBooking(AddBooking event, Emitter<BookingState> emit) async {
    try {
      final booking = await bookingService.createBooking(event.data);
      if (booking != null) {
        add(const FetchBookings());
      } else {
        emit(const BookingState.error('Failed to add booking'));
      }
    } catch (e) {
      emit(BookingState.error(e.toString()));
    }
  }
}
