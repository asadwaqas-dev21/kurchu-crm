// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlertModel _$AlertModelFromJson(Map<String, dynamic> json) => AlertModel(
  id: json['id'] as String,
  type: $enumDecode(_$AlertTypeEnumMap, json['type']),
  title: json['title'] as String,
  message: json['message'] as String,
  severity: $enumDecode(_$AlertSeverityEnumMap, json['severity']),
  isRead: json['isRead'] as bool,
  readAt: json['readAt'] as String?,
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$AlertModelToJson(AlertModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$AlertTypeEnumMap[instance.type]!,
      'title': instance.title,
      'message': instance.message,
      'severity': _$AlertSeverityEnumMap[instance.severity]!,
      'isRead': instance.isRead,
      'readAt': instance.readAt,
      'createdAt': instance.createdAt,
    };

const _$AlertTypeEnumMap = {
  AlertType.newLead: 'NEW_LEAD',
  AlertType.followUpOverdue: 'FOLLOW_UP_OVERDUE',
  AlertType.paymentDue: 'PAYMENT_DUE',
  AlertType.bookingCompleted: 'BOOKING_COMPLETED',
  AlertType.invoiceSent: 'INVOICE_SENT',
};

const _$AlertSeverityEnumMap = {
  AlertSeverity.info: 'INFO',
  AlertSeverity.warning: 'WARNING',
  AlertSeverity.error: 'ERROR',
  AlertSeverity.critical: 'CRITICAL',
};
