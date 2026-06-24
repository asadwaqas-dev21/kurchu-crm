import 'package:json_annotation/json_annotation.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/metrics.dart';

part 'metrics_model.g.dart';

@JsonSerializable()
class MetricsModel {
  final int totalLeads;
  final int newLeadsToday;
  final int callsToday;
  final int bookingsThisMonth;
  final double pendingPayments;
  final double totalRevenue;
  final double collectedAmount;
  final double invoicedAmount;
  final double totalProfit;
  final String conversionRate;
  final String averageDealValue;
  final String timestamp;

  MetricsModel({
    required this.totalLeads,
    required this.newLeadsToday,
    required this.callsToday,
    required this.bookingsThisMonth,
    required this.pendingPayments,
    required this.totalRevenue,
    required this.collectedAmount,
    required this.invoicedAmount,
    required this.totalProfit,
    required this.conversionRate,
    required this.averageDealValue,
    required this.timestamp,
  });

  factory MetricsModel.fromJson(Map<String, dynamic> json) =>
      _$MetricsModelFromJson(json);

  Map<String, dynamic> toJson() => _$MetricsModelToJson(this);

  Metrics toEntity() {
    return Metrics(
      totalLeads: totalLeads,
      newLeadsToday: newLeadsToday,
      callsToday: callsToday,
      bookingsThisMonth: bookingsThisMonth,
      pendingPayments: pendingPayments,
      totalRevenue: totalRevenue,
      collectedAmount: collectedAmount,
      invoicedAmount: invoicedAmount,
      totalProfit: totalProfit,
      conversionRate: conversionRate,
      averageDealValue: averageDealValue,
      timestamp: timestamp,
    );
  }
}
