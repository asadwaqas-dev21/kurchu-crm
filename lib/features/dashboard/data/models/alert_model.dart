import 'package:json_annotation/json_annotation.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/alert.dart';

part 'alert_model.g.dart';

enum AlertType {
  @JsonValue('NEW_LEAD')
  newLead,
  @JsonValue('FOLLOW_UP_OVERDUE')
  followUpOverdue,
  @JsonValue('PAYMENT_DUE')
  paymentDue,
  @JsonValue('BOOKING_COMPLETED')
  bookingCompleted,
  @JsonValue('INVOICE_SENT')
  invoiceSent,
}

enum AlertSeverity {
  @JsonValue('INFO')
  info,
  @JsonValue('WARNING')
  warning,
  @JsonValue('ERROR')
  error,
  @JsonValue('CRITICAL')
  critical,
}

@JsonSerializable()
class AlertModel {
  final String id;
  final AlertType type;
  final String title;
  final String message;
  final AlertSeverity severity;
  final bool isRead;
  final String? readAt;
  final String createdAt;

  AlertModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.severity,
    required this.isRead,
    this.readAt,
    required this.createdAt,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) =>
      _$AlertModelFromJson(json);

  Map<String, dynamic> toJson() => _$AlertModelToJson(this);

  Alert toEntity() {
    return Alert(
      id: id,
      type: type.toString().split('.').last,
      title: title,
      message: message,
      severity: severity.toString().split('.').last,
      isRead: isRead,
      readAt: readAt,
      createdAt: createdAt,
    );
  }
}
