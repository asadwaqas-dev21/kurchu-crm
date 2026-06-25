// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metrics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetricsModel _$MetricsModelFromJson(Map<String, dynamic> json) => MetricsModel(
  totalLeads: (json['totalLeads'] as num).toInt(),
  newLeadsToday: (json['newLeadsToday'] as num).toInt(),
  callsToday: (json['callsToday'] as num).toInt(),
  bookingsThisMonth: (json['bookingsThisMonth'] as num).toInt(),
  pendingPayments: (json['pendingPayments'] as num).toDouble(),
  totalRevenue: (json['totalRevenue'] as num).toDouble(),
  collectedAmount: (json['collectedAmount'] as num).toDouble(),
  invoicedAmount: (json['invoicedAmount'] as num).toDouble(),
  totalProfit: (json['totalProfit'] as num).toDouble(),
  conversionRate: json['conversionRate'] as String,
  averageDealValue: json['averageDealValue'] as String,
  timestamp: json['timestamp'] as String,
);

Map<String, dynamic> _$MetricsModelToJson(MetricsModel instance) =>
    <String, dynamic>{
      'totalLeads': instance.totalLeads,
      'newLeadsToday': instance.newLeadsToday,
      'callsToday': instance.callsToday,
      'bookingsThisMonth': instance.bookingsThisMonth,
      'pendingPayments': instance.pendingPayments,
      'totalRevenue': instance.totalRevenue,
      'collectedAmount': instance.collectedAmount,
      'invoicedAmount': instance.invoicedAmount,
      'totalProfit': instance.totalProfit,
      'conversionRate': instance.conversionRate,
      'averageDealValue': instance.averageDealValue,
      'timestamp': instance.timestamp,
    };
