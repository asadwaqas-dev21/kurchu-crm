import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/widgets/kpi_card.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/core/services/api_client.dart';
import 'package:crm_kurchudashboard/core/constants/api_constants.dart';
import 'package:crm_kurchudashboard/features/bookings/data/services/booking_service.dart';
import 'package:crm_kurchudashboard/features/leads/data/services/lead_service.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({Key? key}) : super(key: key);

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  bool _isLoading = true;
  String? _error;

  double _totalBookingValue = 0;
  double _totalCollected = 0;
  double _balanceToCollect = 0;
  double _totalProfit = 0;

  List<String> _chartLabels = [];
  List<double> _chartData = [];

  List<Map<String, dynamic>> _duePayments = [];

  @override
  void initState() {
    super.initState();
    _loadFinanceData();
  }

  Future<void> _loadFinanceData() async {
    try {
      final apiClient = getIt<ApiClient>();
      final bookingService = getIt<BookingService>();
      final leadService = getIt<LeadService>();

      // 1. Load Metrics
      final metricsResponse = await apiClient.get(ApiConstants.dashboardMetrics);
      final metrics = metricsResponse.data['data'] ?? {};
      
      final double collected = (metrics['collectedAmount'] ?? 0).toDouble();
      final double pending = (metrics['pendingPayments'] ?? 0).toDouble();
      final double profit = (metrics['totalProfit'] ?? 0).toDouble();
      
      // 2. Load Bookings
      final bookings = await bookingService.getBookings();
      
      // 3. Load Leads to match names
      final leadsResult = await leadService.getLeads(limit: 100);
      final leadMap = {for (var lead in leadsResult.leads) lead.id: '${lead.firstName} ${lead.lastName}'};

      // 4. Load Chart Data
      final chartResponse = await apiClient.get(
        ApiConstants.dashboardChartData,
        queryParameters: {'type': 'revenue', 'period': 'month'},
      );
      final chartData = chartResponse.data['data'] ?? {};
      final List<dynamic> labels = chartData['labels'] ?? [];
      final List<dynamic> datasets = chartData['datasets'] ?? [];
      final List<dynamic> rawData = (datasets.isNotEmpty) ? (datasets[0]['data'] ?? []) : [];

      // Calculate due payments from bookings with pendingAmount > 0
      final List<Map<String, dynamic>> dues = [];
      for (var booking in bookings) {
        if (booking.pendingAmount > 0) {
          final leadName = leadMap[booking.leadId] ?? 'Lead ${booking.leadId.substring(0, 8)}';
          dues.add({
            'name': leadName,
            'amount': 'PKR ${booking.pendingAmount.toInt()}',
          });
        }
      }

      if (!mounted) return;

      setState(() {
        _totalCollected = collected;
        _balanceToCollect = pending;
        _totalBookingValue = collected + pending;
        _totalProfit = profit;

        _chartLabels = labels.map((e) => e.toString()).toList();
        _chartData = rawData.map((e) => (e as num).toDouble()).toList();

        _duePayments = dues;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text('Error loading finance data: $_error', style: const TextStyle(color: AppColors.error)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Finance Overview',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Track all your financial transactions.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            
            // KPI Cards
            LayoutBuilder(builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 750 ? 4 : 2;
              return GridView.count(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: crossAxisCount == 4 ? 1.6 : 2.0,
                children: [
                  KpiCard(
                    title: 'Total Booking Value',
                    value: 'PKR ${_totalBookingValue.toInt()}',
                    subtitle: 'Total bookings',
                    icon: Iconsax.wallet,
                    iconColor: AppColors.iconBlue,
                    iconBgColor: AppColors.iconBgBlue,
                  ),
                  KpiCard(
                    title: 'Total Collected',
                    value: 'PKR ${_totalCollected.toInt()}',
                    subtitle: 'This month',
                    icon: Iconsax.tick_circle,
                    iconColor: AppColors.iconGreen,
                    iconBgColor: AppColors.iconBgGreen,
                  ),
                  KpiCard(
                    title: 'Balance to Collect',
                    value: 'PKR ${_balanceToCollect.toInt()}',
                    subtitle: 'Pending',
                    icon: Iconsax.clock,
                    iconColor: AppColors.error,
                    iconBgColor: const Color(0xFFFCE7F3),
                  ),
                  KpiCard(
                    title: 'Total Profit',
                    value: 'PKR ${_totalProfit.toInt()}',
                    subtitle: '+15% vs last month',
                    icon: Iconsax.trend_up,
                    iconColor: AppColors.success,
                    iconBgColor: AppColors.iconBgGreen,
                  ),
                ],
              );
            }),
            const SizedBox(height: 24),
            
            // Charts & Lists Area
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 750) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildChartContainer()),
                      const SizedBox(width: 24),
                      Expanded(flex: 1, child: _buildDuePaymentsContainer()),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildChartContainer(),
                      const SizedBox(height: 24),
                      _buildDuePaymentsContainer(),
                    ],
                  );
                }
              }
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChartContainer() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Collection Trend', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
          Expanded(
            child: _buildCollectionTrendChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildDuePaymentsContainer() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Due Payments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          Expanded(
            child: _duePayments.isEmpty
                ? const Center(child: Text('No due payments.', style: TextStyle(color: AppColors.textSecondary)))
                : ListView.separated(
                    itemCount: _duePayments.length,
                    separatorBuilder: (context, index) => const Divider(color: AppColors.border, height: 16),
                    itemBuilder: (context, index) {
                      final item = _duePayments[index];
                      return _buildDuePaymentItem(item['name'], item['amount']);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionTrendChart() {
    if (_chartData.isEmpty) {
      return const Center(child: Text('No collection trend data available.', style: TextStyle(color: AppColors.textSecondary)));
    }

    final double maxVal = _chartData.reduce((curr, next) => curr > next ? curr : next);
    final double maxBarHeight = 160.0;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(_chartData.length, (index) {
          final double value = _chartData[index];
          final String label = _chartLabels[index];
          final double barHeight = maxVal > 0 ? (value / maxVal) * maxBarHeight : 0;

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'PKR ${value >= 1000 ? "${(value / 1000).toStringAsFixed(1)}k" : value.toInt()}',
                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                width: 28,
                height: barHeight == 0 ? 4 : barHeight,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.iconBlue, Color(0xFF0EA5E9)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDuePaymentItem(String name, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.iconBgOrange,
                child: const Icon(Iconsax.user, size: 16, color: AppColors.iconOrange),
              ),
              const SizedBox(width: 12),
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
            ],
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.error)),
        ],
      ),
    );
  }
}
