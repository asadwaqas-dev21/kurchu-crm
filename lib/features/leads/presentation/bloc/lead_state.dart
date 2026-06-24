import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:crm_kurchudashboard/features/leads/data/models/lead_model.dart';

part 'lead_state.freezed.dart';

@freezed
class LeadState with _$LeadState {
  const factory LeadState.initial() = _Initial;
  const factory LeadState.loading() = _Loading;
  const factory LeadState.loaded(
    List<LeadModel> leads, {
    required int total,
    required int skip,
    required int limit,
  }) = _Loaded;
  const factory LeadState.error(String message) = _Error;
}
