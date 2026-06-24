import 'package:json_annotation/json_annotation.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/entities/today_stats.dart';

part 'today_stats_model.g.dart';

@JsonSerializable()
class TodayStatsModel {
  final int totalLeads;
  final int totalBookings;

  TodayStatsModel({
    required this.totalLeads,
    required this.totalBookings,
  });

  factory TodayStatsModel.fromJson(Map<String, dynamic> json) =>
      _$TodayStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$TodayStatsModelToJson(this);

  TodayStats toEntity() {
    return TodayStats(
      totalLeads: totalLeads,
      totalBookings: totalBookings,
    );
  }
}
