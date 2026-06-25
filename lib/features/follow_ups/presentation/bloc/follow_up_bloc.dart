import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crm_kurchudashboard/features/follow_ups/data/services/follow_up_service.dart';
import 'follow_up_event.dart';
import 'follow_up_state.dart';

class FollowUpBloc extends Bloc<FollowUpEvent, FollowUpState> {
  final FollowUpService followUpService;

  FollowUpBloc({required this.followUpService})
    : super(const FollowUpState.initial()) {
    on<FetchFollowUps>(_onFetchFollowUps);
    on<AddFollowUp>(_onAddFollowUp);
    on<UpdateFollowUp>(_onUpdateFollowUp);
  }

  Future<void> _onFetchFollowUps(
    FetchFollowUps event,
    Emitter<FollowUpState> emit,
  ) async {
    emit(const FollowUpState.loading());
    try {
      final followUps = await followUpService.getFollowUps(
        isCompleted: event.isCompleted,
      );
      emit(FollowUpState.loaded(followUps));
    } catch (e) {
      emit(FollowUpState.error(e.toString()));
    }
  }

  Future<void> _onAddFollowUp(
    AddFollowUp event,
    Emitter<FollowUpState> emit,
  ) async {
    try {
      final followUp = await followUpService.createFollowUp(event.data);
      if (followUp != null) {
        add(const FetchFollowUps());
      } else {
        emit(const FollowUpState.error('Failed to add follow-up'));
      }
    } catch (e) {
      emit(FollowUpState.error(e.toString()));
    }
  }

  Future<void> _onUpdateFollowUp(
    UpdateFollowUp event,
    Emitter<FollowUpState> emit,
  ) async {
    try {
      final followUp = await followUpService.updateFollowUp(
        event.id,
        event.data,
      );
      if (followUp != null) {
        add(const FetchFollowUps());
      } else {
        emit(const FollowUpState.error('Failed to update follow-up'));
      }
    } catch (e) {
      emit(FollowUpState.error(e.toString()));
    }
  }
}
