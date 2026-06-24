class Metrics {
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

  Metrics({
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

  factory Metrics.fromJson(Map<String, dynamic> json) {
    return Metrics(
      totalLeads: json['totalLeads'] ?? 0,
      newLeadsToday: json['newLeadsToday'] ?? 0,
      callsToday: json['callsToday'] ?? 0,
      bookingsThisMonth: json['bookingsThisMonth'] ?? 0,
      pendingPayments: (json['pendingPayments'] ?? 0).toDouble(),
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      collectedAmount: (json['collectedAmount'] ?? 0).toDouble(),
      invoicedAmount: (json['invoicedAmount'] ?? 0).toDouble(),
      totalProfit: (json['totalProfit'] ?? 0).toDouble(),
      conversionRate: json['conversionRate'] ?? '',
      averageDealValue: json['averageDealValue'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }
}
