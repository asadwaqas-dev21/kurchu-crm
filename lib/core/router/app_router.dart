import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:crm_kurchudashboard/core/di/injection.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/pages/pipeline_board_page.dart';
import 'package:crm_kurchudashboard/features/leads/presentation/pages/leads_list_page.dart';
import 'package:crm_kurchudashboard/features/follow_ups/presentation/pages/follow_ups_page.dart';
import 'package:crm_kurchudashboard/features/bookings/presentation/pages/bookings_page.dart';
import 'package:crm_kurchudashboard/features/finance/presentation/pages/finance_page.dart';
import 'package:crm_kurchudashboard/features/invoices/presentation/pages/invoices_page.dart';
import 'package:crm_kurchudashboard/features/itineraries/presentation/pages/itineraries_page.dart';
import 'package:crm_kurchudashboard/features/documents/presentation/pages/documents_page.dart';
import 'package:crm_kurchudashboard/features/leads/presentation/pages/my_leads_page.dart';
import 'package:crm_kurchudashboard/features/settings/presentation/pages/settings_page.dart';

import 'package:crm_kurchudashboard/core/presentation/layouts/main_layout.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainLayout(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => BlocProvider(
            create: (context) => getIt<DashboardBloc>(),
            child: const DashboardPage(),
          ),
        ),
        GoRoute(
          path: '/my-leads',
          builder: (context, state) => const MyLeadsPage(),
        ),
        GoRoute(
          path: '/leads',
          builder: (context, state) => const LeadsListPage(),
        ),
        GoRoute(
          path: '/pipeline',
          builder: (context, state) => const PipelineBoardPage(),
        ),
        GoRoute(
          path: '/follow-ups',
          builder: (context, state) => const FollowUpsPage(),
        ),
        GoRoute(
          path: '/bookings',
          builder: (context, state) => const BookingsPage(),
        ),
        GoRoute(
          path: '/finance',
          builder: (context, state) => const FinancePage(),
        ),
        GoRoute(
          path: '/invoices',
          builder: (context, state) => const InvoicesPage(),
        ),
        GoRoute(
          path: '/itineraries',
          builder: (context, state) => const ItinerariesPage(),
        ),
        GoRoute(
          path: '/documents',
          builder: (context, state) => const DocumentsPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    ),
  ],
);
