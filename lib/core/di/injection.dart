import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:crm_kurchudashboard/core/services/api_client.dart';
import 'package:crm_kurchudashboard/core/services/auth_service.dart';
import 'package:crm_kurchudashboard/core/services/websocket_service.dart';
import 'package:crm_kurchudashboard/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:crm_kurchudashboard/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:crm_kurchudashboard/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/usecases/get_metrics_usecase.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/usecases/get_alerts_usecase.dart';
import 'package:crm_kurchudashboard/features/dashboard/domain/usecases/mark_alert_as_read_usecase.dart';
import 'package:crm_kurchudashboard/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:crm_kurchudashboard/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:crm_kurchudashboard/features/leads/data/services/lead_service.dart';
import 'package:crm_kurchudashboard/features/leads/presentation/bloc/lead_bloc.dart';
import 'package:crm_kurchudashboard/features/follow_ups/data/services/follow_up_service.dart';
import 'package:crm_kurchudashboard/features/follow_ups/presentation/bloc/follow_up_bloc.dart';
import 'package:crm_kurchudashboard/features/bookings/data/services/booking_service.dart';
import 'package:crm_kurchudashboard/features/bookings/presentation/bloc/booking_bloc.dart';
import 'package:crm_kurchudashboard/features/invoices/data/services/invoice_service.dart';
import 'package:crm_kurchudashboard/features/documents/data/services/document_service.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

// Manual registrations for now, as we don't have the generated file yet
extension GetItInjectableX on GetIt {
  void init() {
    registerLazySingleton<AuthService>(() => AuthService());
    registerLazySingleton<ApiClient>(() => ApiClient(authService: this()));
    registerLazySingleton<WebSocketService>(
      () => WebSocketService(authService: this()),
    );

    registerLazySingleton<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImpl(apiClient: this()),
    );
    registerLazySingleton<DashboardLocalDataSource>(
      () => DashboardLocalDataSourceImpl(),
    );

    registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(
        remoteDataSource: this(),
        localDataSource: this(),
      ),
    );

    registerLazySingleton<GetMetricsUseCase>(() => GetMetricsUseCase(this()));
    registerLazySingleton<GetAlertsUseCase>(() => GetAlertsUseCase(this()));
    registerLazySingleton<MarkAlertAsReadUseCase>(() => MarkAlertAsReadUseCase(this()));

    registerFactory<DashboardBloc>(
      () => DashboardBloc(
        getMetricsUseCase: this(),
        getAlertsUseCase: this(),
        markAlertAsReadUseCase: this(),
        webSocketService: this(),
      ),
    );

    // AuthBloc is a placeholder for now
    registerFactory<AuthBloc>(() => AuthBloc());

    // Leads
    registerLazySingleton<LeadService>(() => LeadService());
    registerFactory<LeadBloc>(() => LeadBloc(leadService: this()));

    // FollowUps
    registerLazySingleton<FollowUpService>(() => FollowUpService());
    registerFactory<FollowUpBloc>(() => FollowUpBloc(followUpService: this()));

    // Bookings
    registerLazySingleton<BookingService>(() => BookingService());
    registerFactory<BookingBloc>(() => BookingBloc(bookingService: this()));



    // Invoices
    registerLazySingleton<InvoiceService>(() => InvoiceService());

    // Documents
    registerLazySingleton<DocumentService>(() => DocumentService());
  }
}
