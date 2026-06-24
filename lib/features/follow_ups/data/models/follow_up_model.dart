import 'package:json_annotation/json_annotation.dart';

part 'follow_up_model.g.dart';

@JsonSerializable()
class LeadSummaryModel {
  final String id;
  final String firstName;
  final String lastName;
  final String? company;

  LeadSummaryModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.company,
  });

  factory LeadSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$LeadSummaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$LeadSummaryModelToJson(this);
}

@JsonSerializable()
class FollowUpModel {
  final String id;
  final String leadId;
  final DateTime scheduledAt;
  final String? callNotes;
  final bool isCompleted;
  final DateTime? completedAt;
  final LeadSummaryModel? lead;

  FollowUpModel({
    required this.id,
    required this.leadId,
    required this.scheduledAt,
    this.callNotes,
    required this.isCompleted,
    this.completedAt,
    this.lead,
  });

  factory FollowUpModel.fromJson(Map<String, dynamic> json) =>
      _$FollowUpModelFromJson(json);
  Map<String, dynamic> toJson() => _$FollowUpModelToJson(this);
}
