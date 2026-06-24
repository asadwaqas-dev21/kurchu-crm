// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
  id: json['id'] as String,
  leadId: json['leadId'] as String,
  serviceId: json['serviceId'] as String,
  status: json['status'] as String,
  bookingDate: DateTime.parse(json['bookingDate'] as String),
  completionDate: json['completionDate'] == null
      ? null
      : DateTime.parse(json['completionDate'] as String),
  amount: (json['amount'] as num).toDouble(),
  collectedAmount: (json['collectedAmount'] as num).toDouble(),
  pendingAmount: (json['pendingAmount'] as num).toDouble(),
  companyId: json['companyId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'leadId': instance.leadId,
      'serviceId': instance.serviceId,
      'status': instance.status,
      'bookingDate': instance.bookingDate.toIso8601String(),
      'completionDate': instance.completionDate?.toIso8601String(),
      'amount': instance.amount,
      'collectedAmount': instance.collectedAmount,
      'pendingAmount': instance.pendingAmount,
      'companyId': instance.companyId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
