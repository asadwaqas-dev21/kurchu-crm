import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/core/services/auth_service.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo Area
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/appicon.png',
                    width: 32,
                    height: 32,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'KURCHU CRM',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('OVERVIEW'),
                  _buildNavItem(
                    context,
                    icon: Iconsax.category,
                    label: 'Dashboard',
                    isActive: GoRouterState.of(context).uri.toString() == '/',
                    onTap: () => context.go('/'),
                  ),
                  _buildNavItem(
                    context,
                    icon: Iconsax.profile_2user,
                    label: 'My Leads',
                    isActive: GoRouterState.of(
                      context,
                    ).uri.toString().startsWith('/my-leads'),
                    onTap: () => context.go('/my-leads'),
                  ),

                  const SizedBox(height: 24),
                  _buildSectionHeader('SALES'),
                  _buildNavItem(
                    context,
                    icon: Iconsax.profile_2user,
                    label: 'Leads',
                    isActive: GoRouterState.of(
                      context,
                    ).uri.toString().startsWith('/leads'),
                    onTap: () => context.go('/leads'),
                  ),
                  _buildNavItem(
                    context,
                    icon: Iconsax.kanban,
                    label: 'Pipeline',
                    isActive: GoRouterState.of(
                      context,
                    ).uri.toString().startsWith('/pipeline'),
                    onTap: () => context.go('/pipeline'),
                  ),
                  _buildNavItem(
                    context,
                    icon: Iconsax.call_calling,
                    label: 'Follow-ups',
                    isActive: GoRouterState.of(
                      context,
                    ).uri.toString().startsWith('/follow-ups'),
                    onTap: () => context.go('/follow-ups'),
                  ),
                  _buildNavItem(
                    context,
                    icon: Iconsax.book,
                    label: 'Bookings',
                    isActive: GoRouterState.of(
                      context,
                    ).uri.toString().startsWith('/bookings'),
                    onTap: () => context.go('/bookings'),
                  ),
                  _buildNavItem(
                    context,
                    icon: Iconsax.calendar,
                    label: 'Calendar',
                    isActive: GoRouterState.of(
                      context,
                    ).uri.toString().startsWith('/calendar'),
                    onTap: () => context.go('/calendar'),
                  ),

                  const SizedBox(height: 24),
                  _buildSectionHeader('FINANCE & DOCS'),
                  _buildNavItem(
                    context,
                    icon: Iconsax.wallet_2,
                    label: 'Finance',
                    isActive: GoRouterState.of(
                      context,
                    ).uri.toString().startsWith('/finance'),
                    onTap: () => context.go('/finance'),
                  ),
                  _buildNavItem(
                    context,
                    icon: Iconsax.receipt,
                    label: 'Invoices',
                    isActive: GoRouterState.of(
                      context,
                    ).uri.toString().startsWith('/invoices'),
                    onTap: () => context.go('/invoices'),
                  ),
                  _buildNavItem(
                    context,
                    icon: Iconsax.document_text,
                    label: 'Documents',
                    isActive: GoRouterState.of(
                      context,
                    ).uri.toString().startsWith('/documents'),
                    onTap: () => context.go('/documents'),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Bottom Area
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildNavItem(
                  context,
                  icon: Iconsax.setting_2,
                  label: 'Settings',
                  isActive: GoRouterState.of(
                    context,
                  ).uri.toString().startsWith('/settings'),
                  onTap: () => context.go('/settings'),
                ),
                _buildNavItem(
                  context,
                  icon: Iconsax.logout,
                  label: 'Log out',
                  onTap: () async {
                    await getIt<AuthService>().logout();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                ),
                const SizedBox(height: 16),
                Builder(
                  builder: (context) {
                    final user = getIt<AuthService>().getCurrentUser() ?? {};
                    final firstName = user['firstName'] ?? 'Admin';
                    final lastName = user['lastName'] ?? 'User';
                    final fullName = "$firstName $lastName";
                    final email = user['email'] ?? 'admin@kurchucrm.com';
                    final initials =
                        "${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}"
                            .toUpperCase();

                    return Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary,
                          radius: 18,
                          child: Text(
                            initials.isEmpty ? 'AU' : initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fullName,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                email,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.textSecondary),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 6.0),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1E1E1E) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textPrimary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
