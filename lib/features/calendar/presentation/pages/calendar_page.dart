import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crm_kurchudashboard/core/constants/app_colors.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/features/follow_ups/presentation/bloc/follow_up_bloc.dart';
import 'package:crm_kurchudashboard/features/follow_ups/presentation/bloc/follow_up_event.dart';
import 'package:crm_kurchudashboard/features/follow_ups/presentation/bloc/follow_up_state.dart';
import 'package:crm_kurchudashboard/features/follow_ups/data/models/follow_up_model.dart';
import 'package:crm_kurchudashboard/features/leads/data/services/lead_service.dart';
import 'package:crm_kurchudashboard/features/leads/data/models/lead_model.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _focusedMonth;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month, 1);
    _selectedDay = DateTime(now.year, now.month, now.day);
  }

  List<DateTime> _getCalendarDays() {
    final days = <DateTime>[];
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    
    // Day of week for 1st day (1 = Monday, 7 = Sunday)
    // We adjust padding so Monday is first day of the week
    final paddingDays = firstDay.weekday - 1;
    final startDay = firstDay.subtract(Duration(days: paddingDays));

    // Show 6 weeks (42 cells) to keep height uniform across month changes
    for (int i = 0; i < 42; i++) {
      days.add(startDay.add(Duration(days: i)));
    }
    return days;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  List<FollowUpModel> _getEventsForDay(DateTime day, List<FollowUpModel> allEvents) {
    return allEvents.where((event) => _isSameDay(event.scheduledAt, day)).toList();
  }

  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calendar',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Schedule meetings and track follow-ups.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.iconPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _showScheduleFollowUpDialog(context),
                  icon: const Icon(Iconsax.add, color: Colors.white, size: 20),
                  label: const Text(
                    'Schedule Meeting',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            BlocBuilder<FollowUpBloc, FollowUpState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(48.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (message) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(48.0),
                      child: Text(
                        'Error: $message',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ),
                  loaded: (followUps) {
                    final calendarDays = _getCalendarDays();

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final isWideScreen = constraints.maxWidth > 900;
                        return _buildCalendarGrid(calendarDays, followUps, isWideScreen);
                      },
                    );
                  },
                  orElse: () => const SizedBox(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(List<DateTime> calendarDays, List<FollowUpModel> followUps, bool isWideScreen) {
    final monthName = DateFormat('MMMM yyyy').format(_focusedMonth);
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Month navigation header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                monthName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _previousMonth,
                    icon: const Icon(Iconsax.arrow_left_2),
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _nextMonth,
                    icon: const Icon(Iconsax.arrow_right_3),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Weekdays header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: isWideScreen ? 0.8 : 1.1,
            ),
            itemCount: calendarDays.length,
            itemBuilder: (context, index) {
              final day = calendarDays[index];
              final isCurrentMonth = day.month == _focusedMonth.month;
              final isSelected = _isSameDay(day, _selectedDay);
              final isToday = _isSameDay(day, DateTime.now());
              final dayEvents = _getEventsForDay(day, followUps);

              // Indicator logic: show green dot if all events on this day are complete, purple otherwise
              final hasEvents = dayEvents.isNotEmpty;
              final allCompleted = hasEvents && dayEvents.every((e) => e.isCompleted);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDay = day;
                    // If user selects a day outside focused month, slide focused month to it
                    if (day.month != _focusedMonth.month) {
                      _focusedMonth = DateTime(day.year, day.month, 1);
                    }
                  });
                },
                child: Container(
                  padding: isWideScreen ? const EdgeInsets.all(8) : EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.iconPurple.withValues(alpha: 0.1)
                        : (isToday ? AppColors.iconBgBlue : Colors.transparent),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.iconPurple
                          : (isToday ? AppColors.iconBlue : Colors.transparent),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: isWideScreen ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                    mainAxisAlignment: isWideScreen ? MainAxisAlignment.start : MainAxisAlignment.center,
                    children: [
                      // Day number indicator
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isToday
                              ? AppColors.iconBlue
                              : (isSelected ? AppColors.iconPurple : Colors.transparent),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            fontWeight: (isSelected || isToday) ? FontWeight.bold : FontWeight.normal,
                            color: (isSelected || isToday)
                                ? Colors.white
                                : (isCurrentMonth ? AppColors.textPrimary : AppColors.textSecondary.withValues(alpha: 0.5)),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      
                      if (!isWideScreen) ...[
                        if (hasEvents) ...[
                          const SizedBox(height: 4),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: allCompleted ? AppColors.success : AppColors.iconPurple,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ] else ...[
                        const SizedBox(height: 4),
                        Expanded(
                          child: dayEvents.isEmpty
                              ? const SizedBox()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: dayEvents.length > 3 ? 4 : dayEvents.length,
                                  itemBuilder: (context, eventIndex) {
                                    if (eventIndex == 3 && dayEvents.length > 3) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 4, left: 4),
                                        child: Text(
                                          '+${dayEvents.length - 3} more',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      );
                                    }
                                    final event = dayEvents[eventIndex];
                                    final leadName = event.lead != null
                                        ? '${event.lead!.firstName} ${event.lead!.lastName}'
                                        : 'Lead ${event.leadId}';
                                    final timeStr = DateFormat('h:mm a').format(event.scheduledAt);
                                    
                                    return Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: event.isCompleted 
                                            ? AppColors.success.withValues(alpha: 0.08) 
                                            : AppColors.iconBlue.withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border(
                                          left: BorderSide(
                                            color: event.isCompleted ? AppColors.success : AppColors.iconBlue,
                                            width: 3,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            leadName,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: event.isCompleted ? AppColors.success : AppColors.iconBlue,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const SizedBox(height: 1),
                                          Text(
                                            timeStr,
                                            style: TextStyle(
                                              fontSize: 8.5,
                                              color: AppColors.textSecondary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }



  void _showScheduleFollowUpDialog(BuildContext context) {
    final followUpBloc = context.read<FollowUpBloc>();
    final formKey = GlobalKey<FormState>();
    String? selectedLeadId;
    String notes = '';
    DateTime scheduledDate = _selectedDay;
    TimeOfDay scheduledTime = const TimeOfDay(hour: 9, minute: 0);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'Schedule Meeting',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: FutureBuilder<({List<LeadModel> leads, int total, int skip, int limit})>(
            future: getIt<LeadService>().getLeads(limit: 100),
            builder: (futureContext, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.leads.isEmpty) {
                return SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(
                      'No leads found. Please create a lead first.',
                      style: TextStyle(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              final leads = snapshot.data!.leads;

              return StatefulBuilder(
                builder: (statefulContext, setState) {
                  if (selectedLeadId == null || !leads.any((l) => l.id == selectedLeadId)) {
                    selectedLeadId = leads.first.id;
                  }

                  return Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            initialValue: selectedLeadId,
                            decoration: InputDecoration(
                              labelText: 'Select Lead',
                              labelStyle: TextStyle(color: AppColors.textSecondary),
                            ),
                            dropdownColor: AppColors.surface,
                            style: TextStyle(color: AppColors.textPrimary),
                            items: leads.map((l) {
                              return DropdownMenuItem(
                                value: l.id,
                                child: Text('${l.firstName} ${l.lastName}'),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => selectedLeadId = val);
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          // Date picker row
                          InkWell(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: dialogContext,
                                initialDate: scheduledDate,
                                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );
                              if (date != null) {
                                setState(() => scheduledDate = date);
                              }
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Scheduled Date',
                                labelStyle: TextStyle(color: AppColors.textSecondary),
                              ),
                              child: Text(
                                DateFormat('MMMM d, yyyy').format(scheduledDate),
                                style: TextStyle(color: AppColors.textPrimary),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Time picker row
                          InkWell(
                            onTap: () async {
                              final time = await showTimePicker(
                                context: dialogContext,
                                initialTime: scheduledTime,
                              );
                              if (time != null) {
                                setState(() => scheduledTime = time);
                              }
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Scheduled Time',
                                labelStyle: TextStyle(color: AppColors.textSecondary),
                              ),
                              child: Text(
                                scheduledTime.format(dialogContext),
                                style: TextStyle(color: AppColors.textPrimary),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Notes',
                              labelStyle: TextStyle(color: AppColors.textSecondary),
                            ),
                            style: TextStyle(color: AppColors.textPrimary),
                            onSaved: (val) => notes = val ?? '',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.iconPurple,
              ),
              onPressed: () {
                if (selectedLeadId == null) return;
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();

                  final scheduledDateTime = DateTime(
                    scheduledDate.year,
                    scheduledDate.month,
                    scheduledDate.day,
                    scheduledTime.hour,
                    scheduledTime.minute,
                  );

                  followUpBloc.add(
                    FollowUpEvent.addFollowUp({
                      'leadId': selectedLeadId,
                      'type': 'CALL',
                      'scheduledAt': scheduledDateTime.toUtc().toIso8601String(),
                      'status': 'PENDING',
                      'notes': notes,
                    }),
                  );
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
