import 'package:freezed_annotation/freezed_annotation.dart';

part 'lead_event.freezed.dart';

@freezed
class LeadEvent with _$LeadEvent {
  const factory LeadEvent.started() = _Started;
  const factory LeadEvent.fetchLeads({
    String? stage,
    String? assignedToId,
    @Default(0) int skip,
    @Default(10) int limit,
  }) = FetchLeads;
  const factory LeadEvent.addLead(Map<String, dynamic> data) = AddLead;
  const factory LeadEvent.updateLead(String id, Map<String, dynamic> data) = UpdateLead;
  const factory LeadEvent.deleteLead(String id) = DeleteLead;
}
