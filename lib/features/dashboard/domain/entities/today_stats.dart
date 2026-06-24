class TodayStats {
  final int totalLeads;
  final int totalBookings;

  TodayStats({
    required this.totalLeads,
    required this.totalBookings,
  });

  factory TodayStats.empty() {
    return TodayStats(totalLeads: 0, totalBookings: 0);
  }
}
