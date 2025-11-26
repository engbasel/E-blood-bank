import 'package:blood_bank/core/services/data_service.dart';
import 'package:blood_bank/core/services/fire_storage.dart';
import 'package:blood_bank/core/services/firebase_auth_service.dart';
import 'package:blood_bank/core/services/firestor_service.dart';
import 'package:blood_bank/core/services/health_request.dart';
import 'package:blood_bank/feature/home/domain/usecases/get_accepted_needer_use_case.dart';
import 'package:blood_bank/feature/home/domain/usecases/get_all_donors_use_case.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:blood_bank/core/services/storage_service.dart';
import 'package:blood_bank/feature/home/data/repos/doner_repo_impl.dart';
import 'package:blood_bank/feature/home/data/repos/health_repo_impl.dart';
import 'package:blood_bank/feature/home/data/repos/needer_repo_impl.dart';
import 'package:blood_bank/feature/home/data/datasources/doner_remote_data_source.dart';
import 'package:blood_bank/feature/home/data/datasources/needer_remote_data_source.dart';
import 'package:blood_bank/feature/home/domain/repos/health_repo.dart';
import 'package:blood_bank/feature/home/domain/usecases/add_donor_request_usecase.dart';
import 'package:blood_bank/feature/home/domain/usecases/add_needer_request_usecase.dart';
import 'package:blood_bank/feature/home/domain/usecases/get_health_news_usecase.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_bloc.dart';
import 'package:blood_bank/feature/home/presentation/manger/health_bloc/health_bloc.dart';
import 'package:blood_bank/feature/home/domain/repos/donor_repo.dart';
import 'package:blood_bank/feature/home/domain/repos/needer_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blood_bank/feature/auth/domain/usecases/sign_in_with_email.dart';
import 'package:blood_bank/feature/auth/domain/usecases/sign_up_with_email.dart';
import 'package:blood_bank/feature/auth/domain/usecases/sign_in_with_google.dart';
import 'package:blood_bank/feature/auth/domain/usecases/sign_in_with_facebook.dart';
import 'package:blood_bank/feature/auth/domain/usecases/sign_out.dart';
import 'package:blood_bank/feature/auth/domain/usecases/reset_password.dart';
import 'package:blood_bank/feature/auth/domain/usecases/verify_email.dart';
import 'package:blood_bank/feature/auth/domain/usecases/delete_account.dart';
import 'package:blood_bank/feature/auth/domain/usecases/update_user_profile.dart';
import 'package:blood_bank/feature/auth/domain/usecases/get_current_user.dart';
import 'package:blood_bank/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blood_bank/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:blood_bank/feature/auth/domain/repositories/auth_repository.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);

  // Core services registration
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  getIt.registerSingleton<DatabaseService>(FirestorService());
  getIt.registerSingleton<StorageService>(FireStorage());
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<HealthRequest>(HealthRequest(getIt<Dio>()));

  getIt.registerFactory<DonorRemoteDataSource>(
    () => DonorRemoteDataSourceImpl(getIt<DatabaseService>()),
  );

  getIt.registerSingleton<DonorRepo>(
    DonorRepoImpl(donorRemoteDataSource: getIt<DonorRemoteDataSource>()),
  );

  getIt.registerFactory<AddDonorRequestUseCase>(
    () => AddDonorRequestUseCase(getIt<DonorRepo>()),
  );

  getIt.registerFactory<GetAllDonorRequestsUseCase>(
    () => GetAllDonorRequestsUseCase(getIt<DonorRepo>()),
  );

  getIt.registerFactory<DonorRequestsBloc>(
    () => DonorRequestsBloc(getIt<AddDonorRequestUseCase>(),
      getIt<GetAllDonorRequestsUseCase>()),
  );
  getIt.registerFactory<NeederRemoteDataSource>(
    () => NeederRemoteDataSourceImpl(getIt<DatabaseService>()),
  );

  getIt.registerSingleton<NeederRepo>(
    NeederRepoImpl(getIt<NeederRemoteDataSource>()),
  );

  // Health feature registration
  getIt.registerSingleton<HealthRepo>(
    HealthRepoImpl(healthRequest: getIt<HealthRequest>()),
  );

  getIt.registerFactory<GetHealthNewsUseCase>(
    () => GetHealthNewsUseCase(getIt<HealthRepo>()),
  );

  getIt.registerFactory<HealthBloc>(
    () => HealthBloc(getIt<GetHealthNewsUseCase>()),
  );

  getIt.registerFactory<AddNeederRequestUseCase>(
    () => AddNeederRequestUseCase(getIt<NeederRepo>()),
  );
  getIt.registerFactory<GetAcceptedNeederRequestsUseCase>(
    () => GetAcceptedNeederRequestsUseCase(getIt<NeederRepo>()),
  );



  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
        firebaseAuth: getIt<FirebaseAuth>(), firestore: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt<AuthRemoteDataSource>()),
  );

  // Use cases
  getIt.registerFactory(() => SignInWithEmail(getIt<AuthRepository>()));
  getIt.registerFactory(() => SignUpWithEmail(getIt<AuthRepository>()));
  getIt.registerFactory(() => SignInWithGoogle(getIt<AuthRepository>()));
  getIt.registerFactory(() => SignInWithFacebook(getIt<AuthRepository>()));
  getIt.registerFactory(() => SignOut(getIt<AuthRepository>()));
  getIt.registerFactory(() => ResetPassword(getIt<AuthRepository>()));
  getIt.registerFactory(() => VerifyEmail(getIt<AuthRepository>()));
  getIt.registerFactory(() => DeleteAccount(getIt<AuthRepository>()));
  getIt.registerFactory(() => UpdateUserProfile(getIt<AuthRepository>()));
  getIt.registerFactory(() => GetCurrentUser(getIt<AuthRepository>()));
}
