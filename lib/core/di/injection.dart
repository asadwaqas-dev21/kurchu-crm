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
import 'package:crm_kurchudashboard/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:crm_kurchudashboard/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:crm_kurchudashboard/features/leads/data/services/lead_service.dart';
import 'package:crm_kurchudashboard/features/leads/presentation/bloc/lead_bloc.dart';
import 'package:crm_kurchudashboard/features/follow_ups/data/services/follow_up_service.dart';
import 'package:crm_kurchudashboard/features/follow_ups/presentation/bloc/follow_up_bloc.dart';
import 'package:crm_kurchudashboard/features/bookings/data/services/booking_service.dart';
import 'package:crm_kurchudashboard/features/bookings/presentation/bloc/booking_bloc.dart';
import 'package:crm_kurchudashboard/features/itineraries/data/services/itinerary_service.dart';
import 'package:crm_kurchudashboard/features/itineraries/presentation/bloc/itinerary_bloc.dart';
import 'package:crm_kurchudashboard/features/invoices/data/services/invoice_service.dart';
import 'package:crm_kurchudashboard/features/documents/data/services/document_service.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();

// Manual registrations for now, as we don't have the generated file yet
extension GetItInjectableX on GetIt {
  void init() {
    this.registerLazySingleton<AuthService>(() => AuthService());
    this.registerLazySingleton<ApiClient>(() => ApiClient(authService: this()));
    this.registerLazySingleton<WebSocketService>(() => WebSocketService(authService: this()));

    this.registerLazySingleton<DashboardRemoteDataSource>(
        () => DashboardRemoteDataSourceImpl(apiClient: this()));
    this.registerLazySingleton<DashboardLocalDataSource>(
        () => DashboardLocalDataSourceImpl());

    this.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(
        remoteDataSource: this(),
        localDataSource: this(),
      ),
    );

    this.registerLazySingleton<GetMetricsUseCase>(() => GetMetricsUseCase(this()));
    this.registerLazySingleton<GetAlertsUseCase>(() => GetAlertsUseCase(this()));

    this.registerFactory<DashboardBloc>(() => DashboardBloc(
          getMetricsUseCase: this(),
          getAlertsUseCase: this(),
          webSocketService: this(),
        ));
    
    // AuthBloc is a placeholder for now
    this.registerFactory<AuthBloc>(() => AuthBloc());

    // Leads
    this.registerLazySingleton<LeadService>(() => LeadService());
    this.registerFactory<LeadBloc>(() => LeadBloc(leadService: this()));

    // FollowUps
    this.registerLazySingleton<FollowUpService>(() => FollowUpService());
    this.registerFactory<FollowUpBloc>(() => FollowUpBloc(followUpService: this()));

    // Bookings
    this.registerLazySingleton<BookingService>(() => BookingService());
    this.registerFactory<BookingBloc>(() => BookingBloc(bookingService: this()));

    // Itineraries
    this.registerLazySingleton<ItineraryService>(() => ItineraryService());
    this.registerFactory<ItineraryBloc>(() => ItineraryBloc(itineraryService: this()));

    // Invoices
    this.registerLazySingleton<InvoiceService>(() => InvoiceService());

    // Documents
    this.registerLazySingleton<DocumentService>(() => DocumentService());
  }
}
