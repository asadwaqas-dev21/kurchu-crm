// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lead_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeadModel _$LeadModelFromJson(Map<String, dynamic> json) => LeadModel(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  company: json['company'] as String?,
  stage: json['stage'] as String,
  sourceId: json['sourceId'] as String,
  assignedToId: json['assignedToId'] as String,
  companyId: json['companyId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$LeadModelToJson(LeadModel instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'phone': instance.phone,
  'company': instance.company,
  'stage': instance.stage,
  'sourceId': instance.sourceId,
  'assignedToId': instance.assignedToId,
  'companyId': instance.companyId,
  'createdAt': instance.createdAt.toIso8601String(),
};
