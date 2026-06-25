import 'dart:async';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/core/services/api_client.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/bloc/dashboard_state.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _searchKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  Timer? _debounceTimer;

  bool _isLoadingSearch = false;
  List<dynamic> _leadResults = [];
  List<dynamic> _bookingResults = [];
  List<dynamic> _invoiceResults = [];

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onSearchFocusChanged);
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onSearchFocusChanged);
    _searchController.removeListener(_onSearchTextChanged);
    _searchFocusNode.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    _hideSearchOverlay();
    super.dispose();
  }

  void _onSearchFocusChanged() {
    if (_searchFocusNode.hasFocus) {
      if (_searchController.text.isNotEmpty) {
        _showSearchOverlay();
      }
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && !_searchFocusNode.hasFocus) {
          _hideSearchOverlay();
        }
      });
    }
  }

  void _onSearchTextChanged() {
    final query = _searchController.text;
    if (query.isEmpty) {
      _hideSearchOverlay();
      setState(() {
        _leadResults = [];
        _bookingResults = [];
        _invoiceResults = [];
      });
      return;
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (!mounted) return;
    setState(() {
      _isLoadingSearch = true;
    });
    _showSearchOverlay();

    try {
      final response = await getIt<ApiClient>().get(
        '/search',
        queryParameters: {'q': query},
      );

      if (mounted) {
        final data = response.data['data'] ?? {};
        setState(() {
          _leadResults = data['leads'] ?? [];
          _bookingResults = data['bookings'] ?? [];
          _invoiceResults = data['invoices'] ?? [];
          _isLoadingSearch = false;
        });
        _overlayEntry?.markNeedsBuild();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingSearch = false;
        });
      }
    }
  }

  void _showSearchOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry?.markNeedsBuild();
    }
  }

  void _hideSearchOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox? searchRenderBox =
        _searchKey.currentContext?.findRenderObject() as RenderBox?;
    final size = searchRenderBox?.size ?? const Size(400, 40);

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4),
          child: Material(
            elevation: 8.0,
            borderRadius: BorderRadius.circular(8),
            color: AppColors.surface,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: const BoxConstraints(maxHeight: 350),
              child: _isLoadingSearch
                  ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : _buildSearchResultsList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResultsList() {
    final hasLeads = _leadResults.isNotEmpty;
    final hasBookings = _bookingResults.isNotEmpty;
    final hasInvoices = _invoiceResults.isNotEmpty;

    if (!hasLeads && !hasBookings && !hasInvoices) {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'No results found',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        if (hasLeads) ...[
          _buildCategoryHeader('LEADS'),
          ..._leadResults.map((lead) {
            final name = '${lead['firstName'] ?? ''} ${lead['lastName'] ?? ''}';
            return _buildResultItem(
              icon: Iconsax.profile_2user,
              iconColor: AppColors.iconBlue,
              title: name,
              subtitle: lead['email'] ?? lead['phone'] ?? '',
              onTap: () {
                _hideSearchOverlay();
                _searchController.clear();
                context.go('/leads');
              },
            );
          }),
        ],
        if (hasBookings) ...[
          _buildCategoryHeader('BOOKINGS'),
          ..._bookingResults.map((booking) {
            final leadName = booking['lead'] != null
                ? '${booking['lead']['firstName'] ?? ''} ${booking['lead']['lastName'] ?? ''}'
                : 'Booking ID: ${booking['id']}';
            final destination = booking['service'] != null
                ? booking['service']['name'] ?? ''
                : 'Travel Booking';
            return _buildResultItem(
              icon: Iconsax.ticket,
              iconColor: AppColors.iconGreen,
              title: '$destination - $leadName',
              subtitle:
                  'Status: ${booking['status']} · PKR ${booking['amount']}',
              onTap: () {
                _hideSearchOverlay();
                _searchController.clear();
                context.go('/bookings');
              },
            );
          }),
        ],
        if (hasInvoices) ...[
          _buildCategoryHeader('INVOICES'),
          ..._invoiceResults.map((invoice) {
            final leadName =
                invoice['booking'] != null && invoice['booking']['lead'] != null
                ? '${invoice['booking']['lead']['firstName'] ?? ''} ${invoice['booking']['lead']['lastName'] ?? ''}'
                : 'Invoice';
            return _buildResultItem(
              icon: Iconsax.wallet,
              iconColor: AppColors.iconOrange,
              title: 'Invoice #${invoice['number']}',
              subtitle:
                  'Client: $leadName · Status: ${invoice['status']} · PKR ${invoice['amount']}',
              onTap: () {
                _hideSearchOverlay();
                _searchController.clear();
                context.go('/invoices');
              },
            );
          }),
        ],
      ],
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildResultItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 14,
        backgroundColor: iconColor.withValues(alpha: 0.1),
        child: Icon(icon, size: 14, color: iconColor),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
      ),
      dense: true,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final alerts = state is Loaded ? state.alerts : [];
        final unreadCount = alerts.where((a) => !a.isRead).length;

        final topAlerts = alerts.take(3).toList();

        return Container(
          height: 70,
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              if (MediaQuery.of(context).size.width < 1024)
                IconButton(
                  icon: const Icon(Iconsax.menu_1),
                  onPressed: () {
                    // Handle drawer open
                  },
                ),

              // Search Bar
              Expanded(
                child: CompositedTransformTarget(
                  key: _searchKey,
                  link: _layerLink,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Icon(
                          Iconsax.search_normal,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search leads, bookings, phone...',
                              hintStyle: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 24),

              // Dynamic Notification Chips (from loaded Alerts)
              if (topAlerts.isNotEmpty)
                ...topAlerts.expand(
                  (alert) => [
                    _buildNotificationChip(
                      '${alert.severity == 'ERROR' || alert.severity == 'CRITICAL' ? '⚠️ ' : ''}${alert.title}',
                      alert.severity == 'ERROR' || alert.severity == 'CRITICAL',
                    ),
                    const SizedBox(width: 8),
                  ],
                ),

              const SizedBox(width: 16),

              // Total Alerts Count Indicator
              if (alerts.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+${alerts.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              const SizedBox(width: 16),

              // Notification Bell with unread badge count
              Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Iconsax.notification,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () {
                      // Navigate to dashboard/notifications if needed
                    },
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$unreadCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),

              IconButton(
                icon: Icon(
                  AppColors.isDarkMode ? Iconsax.sun_1 : Iconsax.moon,
                  color: AppColors.textPrimary,
                ),
                onPressed: () {
                  AppColors.themeModeNotifier.value = AppColors.isDarkMode
                      ? ThemeMode.light
                      : ThemeMode.dark;
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationChip(String text, bool isCritical) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isCritical ? AppColors.iconBgOrange : AppColors.iconBgPurple,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isCritical ? AppColors.warning : AppColors.iconPurple)
              .withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCritical ? Iconsax.warning_2 : Iconsax.notification,
            size: 14,
            color: isCritical ? AppColors.warning : AppColors.iconPurple,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isCritical ? AppColors.warning : AppColors.iconPurple,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
