// ignore_for_file: deprecated_member_use

import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/core/services/auth_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  bool _isSaving = false;
  String _activeTab = 'Profile';

  bool _emailLeads = true;
  bool _emailBookings = true;
  bool _emailSystem = false;
  bool _pushLeads = true;
  bool _pushBookings = true;
  bool _pushSystem = true;
  bool _smsLeads = false;
  bool _smsBookings = false;
  bool _isLoadingSettings = false;
  bool _isSavingSettings = false;

  @override
  void initState() {
    super.initState();
    final user = getIt<AuthService>().getCurrentUser() ?? {};
    _firstNameController = TextEditingController(text: user['firstName'] ?? '');
    _lastNameController = TextEditingController(text: user['lastName'] ?? '');
    _emailController = TextEditingController(text: user['email'] ?? '');
    _phoneController = TextEditingController(text: user['phone'] ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final success = await getIt<AuthService>().updateProfile(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Profile updated successfully!'
              : 'Failed to update profile.',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: success ? AppColors.success : AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final initials =
        "${_firstNameController.text.isNotEmpty ? _firstNameController.text[0] : ''}${_lastNameController.text.isNotEmpty ? _lastNameController.text[0] : ''}"
            .toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage your preferences and account settings.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Settings Menu
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSettingsTab('Profile', Iconsax.profile),
                        _buildSettingsTab(
                          'Notifications',
                          Iconsax.notification,
                        ),
                        _buildSettingsTab('Security', Iconsax.lock),
                        _buildSettingsTab('Integrations', Iconsax.link),
                        _buildSettingsTab('Billing', Iconsax.card),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Settings Content
                Expanded(
                  flex: 3,
                  child: _activeTab == 'Profile'
                      ? _buildProfileContent(initials)
                      : (_activeTab == 'Notifications'
                            ? _buildNotificationsContent()
                            : _buildPlaceholderContent()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTab(String title, IconData icon) {
    final isActive = _activeTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTab = title;
        });
        if (title == 'Notifications') {
          _loadNotificationSettings();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.iconBgPurple.withOpacity(0.5)
              : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isActive ? AppColors.iconPurple : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.iconPurple : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive ? AppColors.iconPurple : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(String initials) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.iconBgBlue,
                  child: Text(
                    initials,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.iconBlue,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Change Avatar',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'First Name',
                    _firstNameController,
                    true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    'Last Name',
                    _lastNameController,
                    true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField('Email Address', _emailController, false),
            const SizedBox(height: 16),
            _buildTextField('Phone Number', _phoneController, true),
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.iconPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _isSaving ? null : _saveChanges,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool isEditable,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
            color: isEditable
                ? Colors.transparent
                : AppColors.border.withOpacity(0.2),
          ),
          child: TextFormField(
            controller: controller,
            enabled: isEditable,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isEditable
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
            validator: (val) {
              if (isEditable && (val == null || val.isEmpty)) {
                return 'This field cannot be empty';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderContent() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(48),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.setting_3, size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              '$_activeTab Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This settings panel is coming soon!',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadNotificationSettings() async {
    setState(() {
      _isLoadingSettings = true;
    });

    final settings = await getIt<AuthService>().getNotificationSettings();
    if (settings != null && mounted) {
      setState(() {
        _emailLeads = settings['emailLeads'] ?? true;
        _emailBookings = settings['emailBookings'] ?? true;
        _emailSystem = settings['emailSystem'] ?? false;

        _pushLeads = settings['pushLeads'] ?? true;
        _pushBookings = settings['pushBookings'] ?? true;
        _pushSystem = settings['pushSystem'] ?? true;

        _smsLeads = settings['smsLeads'] ?? false;
        _smsBookings = settings['smsBookings'] ?? false;

        _isLoadingSettings = false;
      });
    } else if (mounted) {
      setState(() {
        _isLoadingSettings = false;
      });
    }
  }

  Future<void> _saveNotificationSettings() async {
    setState(() {
      _isSavingSettings = true;
    });

    final success = await getIt<AuthService>().updateNotificationSettings({
      'emailLeads': _emailLeads,
      'emailBookings': _emailBookings,
      'emailSystem': _emailSystem,
      'pushLeads': _pushLeads,
      'pushBookings': _pushBookings,
      'pushSystem': _pushSystem,
      'smsLeads': _smsLeads,
      'smsBookings': _smsBookings,
    });

    if (!mounted) return;
    setState(() {
      _isSavingSettings = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Notification settings updated successfully!'
              : 'Failed to update settings.',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: success ? AppColors.success : AppColors.error,
      ),
    );
  }

  Widget _buildNotificationsContent() {
    if (_isLoadingSettings) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.all(48),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notification Preferences',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select how and when you want to receive alerts and system updates.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 24),

          _buildNotificationSectionHeader('Email Notifications'),
          _buildSwitchRow(
            'New leads assigned',
            'Get notified immediately when a lead is assigned to you.',
            _emailLeads,
            (val) => setState(() => _emailLeads = val),
          ),
          Divider(color: AppColors.border, height: 16),
          _buildSwitchRow(
            'Booking status updates',
            'Get notified when a client confirms or cancels a booking.',
            _emailBookings,
            (val) => setState(() => _emailBookings = val),
          ),
          Divider(color: AppColors.border, height: 16),
          _buildSwitchRow(
            'System alerts',
            'Receive security warnings and system maintenance logs.',
            _emailSystem,
            (val) => setState(() => _emailSystem = val),
          ),

          const SizedBox(height: 24),
          _buildNotificationSectionHeader('Push Notifications'),
          _buildSwitchRow(
            'Activity on assigned leads',
            'Popups when comments are added or follow-ups are due.',
            _pushLeads,
            (val) => setState(() => _pushLeads = val),
          ),
          Divider(color: AppColors.border, height: 16),
          _buildSwitchRow(
            'Bookings and Payments',
            'Popups when deposits are cleared or bookings are created.',
            _pushBookings,
            (val) => setState(() => _pushBookings = val),
          ),
          Divider(color: AppColors.border, height: 16),
          _buildSwitchRow(
            'System updates',
            'Popups for system status changes or new releases.',
            _pushSystem,
            (val) => setState(() => _pushSystem = val),
          ),

          const SizedBox(height: 24),
          _buildNotificationSectionHeader('SMS Notifications'),
          _buildSwitchRow(
            'Leads urgent follow-ups',
            'Receive text message reminders for overdue calls.',
            _smsLeads,
            (val) => setState(() => _smsLeads = val),
          ),
          Divider(color: AppColors.border, height: 16),
          _buildSwitchRow(
            'Bookings confirmation',
            'Receive text alerts for newly confirmed trips.',
            _smsBookings,
            (val) => setState(() => _smsBookings = val),
          ),

          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.iconPurple,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _isSavingSettings ? null : _saveNotificationSettings,
              child: _isSavingSettings
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Save Preferences',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildSwitchRow(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.iconPurple,
          ),
        ],
      ),
    );
  }
}
