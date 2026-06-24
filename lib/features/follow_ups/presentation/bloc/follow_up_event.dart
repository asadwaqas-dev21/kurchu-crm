import 'package:freezed_annotation/freezed_annotation.dart';

part 'follow_up_event.freezed.dart';

@freezed
class FollowUpEvent with _$FollowUpEvent {
  const factory FollowUpEvent.started() = _Started;
  const factory FollowUpEvent.fetchFollowUps({bool? isCompleted}) = FetchFollowUps;
  const factory FollowUpEvent.addFollowUp(Map<String, dynamic> data) = AddFollowUp;
}
