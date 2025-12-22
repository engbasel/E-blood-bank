import 'package:blood_bank/core/services/get_it_service.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/feature/auth/domain/repositories/auth_repository.dart';
import 'package:blood_bank/feature/auth/domain/usecases/sign_in_with_google.dart';
import 'package:blood_bank/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:blood_bank/feature/home/domain/usecases/add_donor_request_usecase.dart';
import 'package:blood_bank/feature/home/domain/usecases/add_needer_request_usecase.dart';
import 'package:blood_bank/feature/home/domain/usecases/get_accepted_needer_requests_use_case.dart';
import 'package:blood_bank/feature/home/domain/usecases/get_all_donors_requests_use_case.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_event.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_needer_request_bloc/add_needer_request_bloc.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_needer_request_bloc/add_needer_request_event.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:blood_bank/feature/localization/cubit/locale_cubit.dart';
import 'package:blood_bank/feature/splash/presentation/views/splash_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_bloc.dart';

class BloodBank extends StatelessWidget {
  const BloodBank({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocaleCubit()..getSavedLanguage(),
        ),
        BlocProvider(
          create: (context) => AuthBloc(
              authRepository: getIt<AuthRepository>(),
              signInWithGoogleUseCase: getIt.get<SignInWithGoogle>()),
        ),
        BlocProvider(
          create: (context) => AddNeederRequestBloc(
            getIt<AddNeederRequestUseCase>(),
            getIt<GetAcceptedNeederRequestsUseCase>(),
          )..add(GetAcceptedNeederRequestsEvent()),
        ),
        BlocProvider(
          create: (context) => DonorRequestsBloc(
            getIt.get<AddDonorRequestUseCase>(),
            getIt.get<GetAllDonorRequestsUseCase>(),
          )..add(ListenToDonorRequestsEvent()),
        ),
      ],
      child: BlocBuilder<LocaleCubit, ChangeLocaleState>(
        builder: (context, state) {
          return MaterialApp(
              theme: ThemeData(
                fontFamily: 'iwanzaza',
                scaffoldBackgroundColor: Colors.white,
                colorScheme: ColorScheme.light(
                  primary: AppColors.primaryColor,
                  onPrimary: Colors.white,
                ),
                datePickerTheme: DatePickerThemeData(
                  headerBackgroundColor: AppColors.primaryColor,
                  headerForegroundColor: Colors.white,
                  todayBackgroundColor:
                      WidgetStateProperty.all(AppColors.primaryColor),
                  todayForegroundColor: WidgetStateProperty.all(Colors.white),
                ),
              ),
              themeMode: ThemeMode.light,
              locale: state.locale,
              supportedLocales: const [Locale('en'), Locale('ar')],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                for (var locale in supportedLocales) {
                  if (deviceLocale != null &&
                      deviceLocale.languageCode == locale.languageCode) {
                    return deviceLocale;
                  }
                }

                return supportedLocales.first;
              },
              debugShowCheckedModeBanner: false,
              home: SplashInitializer(),
              builder: (context, child) {
                return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: const SystemUiOverlayStyle(
                    statusBarIconBrightness: Brightness.light,
                  ),
                  child: child!,
                );
              });
        },
      ),
    );
  }
}
