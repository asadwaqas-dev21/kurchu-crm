import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:crm_kurchudashboard/features/follow_ups/data/models/follow_up_model.dart';

part 'follow_up_state.freezed.dart';

@freezed
class FollowUpState with _$FollowUpState {
  const factory FollowUpState.initial() = _Initial;
  const factory FollowUpState.loading() = _Loading;
  const factory FollowUpState.loaded(List<FollowUpModel> followUps) = _Loaded;
  const factory FollowUpState.error(String message) = _Error;
}
