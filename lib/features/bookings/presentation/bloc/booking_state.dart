import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:crm_kurchudashboard/features/bookings/data/models/booking_model.dart';

part 'booking_state.freezed.dart';

@freezed
class BookingState with _$BookingState {
  const factory BookingState.initial() = _Initial;
  const factory BookingState.loading() = _Loading;
  const factory BookingState.loaded(List<BookingModel> bookings) = _Loaded;
  const factory BookingState.error(String message) = _Error;
}
