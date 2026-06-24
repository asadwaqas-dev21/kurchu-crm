// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_up_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeadSummaryModel _$LeadSummaryModelFromJson(Map<String, dynamic> json) =>
    LeadSummaryModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      company: json['company'] as String?,
    );

Map<String, dynamic> _$LeadSummaryModelToJson(LeadSummaryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'company': instance.company,
    };

FollowUpModel _$FollowUpModelFromJson(Map<String, dynamic> json) =>
    FollowUpModel(
      id: json['id'] as String,
      leadId: json['leadId'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      callNotes: json['callNotes'] as String?,
      isCompleted: json['isCompleted'] as bool,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      lead: json['lead'] == null
          ? null
          : LeadSummaryModel.fromJson(json['lead'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FollowUpModelToJson(FollowUpModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'leadId': instance.leadId,
      'scheduledAt': instance.scheduledAt.toIso8601String(),
      'callNotes': instance.callNotes,
      'isCompleted': instance.isCompleted,
      'completedAt': instance.completedAt?.toIso8601String(),
      'lead': instance.lead,
    };
