// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodayStatsModel _$TodayStatsModelFromJson(Map<String, dynamic> json) =>
    TodayStatsModel(
      totalLeads: (json['totalLeads'] as num).toInt(),
      totalBookings: (json['totalBookings'] as num).toInt(),
    );

Map<String, dynamic> _$TodayStatsModelToJson(TodayStatsModel instance) =>
    <String, dynamic>{
      'totalLeads': instance.totalLeads,
      'totalBookings': instance.totalBookings,
    };
