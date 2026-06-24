import 'package:json_annotation/json_annotation.dart';

part 'booking_model.g.dart';

@JsonSerializable()
class BookingModel {
  final String id;
  final String leadId;
  final String serviceId;
  final String status;
  final DateTime bookingDate;
  final DateTime? completionDate;
  final double amount;
  final double collectedAmount;
  final double pendingAmount;
  final String companyId;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.leadId,
    required this.serviceId,
    required this.status,
    required this.bookingDate,
    this.completionDate,
    required this.amount,
    required this.collectedAmount,
    required this.pendingAmount,
    required this.companyId,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookingModelToJson(this);
}
