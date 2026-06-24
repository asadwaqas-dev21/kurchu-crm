import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crm_kurchudashboard/features/leads/data/services/lead_service.dart';
import 'lead_event.dart';
import 'lead_state.dart';

class LeadBloc extends Bloc<LeadEvent, LeadState> {
  final LeadService leadService;

  LeadBloc({required this.leadService}) : super(const LeadState.initial()) {
    on<FetchLeads>(_onFetchLeads);
    on<AddLead>(_onAddLead);
    on<UpdateLead>(_onUpdateLead);
    on<DeleteLead>(_onDeleteLead);
  }

  Future<void> _onFetchLeads(FetchLeads event, Emitter<LeadState> emit) async {
    emit(const LeadState.loading());
    try {
      final result = await leadService.getLeads(
        stage: event.stage,
        assignedToId: event.assignedToId,
        skip: event.skip,
        limit: event.limit,
      );
      emit(LeadState.loaded(
        result.leads,
        total: result.total,
        skip: result.skip,
        limit: result.limit,
      ));
    } catch (e) {
      emit(LeadState.error(e.toString()));
    }
  }

  Future<void> _onAddLead(AddLead event, Emitter<LeadState> emit) async {
    try {
      final lead = await leadService.createLead(event.data);
      if (lead != null) {
        final currentSkip = state.maybeWhen(
          loaded: (_, total, skip, limit) => skip,
          orElse: () => 0,
        );
        final currentLimit = state.maybeWhen(
          loaded: (_, total, skip, limit) => limit,
          orElse: () => 10,
        );
        add(FetchLeads(skip: currentSkip, limit: currentLimit));
      } else {
        emit(const LeadState.error('Failed to add lead'));
      }
    } catch (e) {
      emit(LeadState.error(e.toString()));
    }
  }

  Future<void> _onUpdateLead(UpdateLead event, Emitter<LeadState> emit) async {
    try {
      final lead = await leadService.updateLead(event.id, event.data);
      if (lead != null) {
        final currentSkip = state.maybeWhen(
          loaded: (_, total, skip, limit) => skip,
          orElse: () => 0,
        );
        final currentLimit = state.maybeWhen(
          loaded: (_, total, skip, limit) => limit,
          orElse: () => 10,
        );
        add(FetchLeads(skip: currentSkip, limit: currentLimit));
      } else {
        emit(const LeadState.error('Failed to update lead'));
      }
    } catch (e) {
      emit(LeadState.error(e.toString()));
    }
  }

  Future<void> _onDeleteLead(DeleteLead event, Emitter<LeadState> emit) async {
    try {
      final success = await leadService.deleteLead(event.id);
      if (success) {
        final currentSkip = state.maybeWhen(
          loaded: (_, total, skip, limit) => skip,
          orElse: () => 0,
        );
        final currentLimit = state.maybeWhen(
          loaded: (_, total, skip, limit) => limit,
          orElse: () => 10,
        );
        add(FetchLeads(skip: currentSkip, limit: currentLimit));
      } else {
        emit(const LeadState.error('Failed to delete lead'));
      }
    } catch (e) {
      emit(LeadState.error(e.toString()));
    }
  }
}
