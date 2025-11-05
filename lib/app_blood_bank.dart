import 'package:blood_bank/core/services/get_it_service.dart';
import 'package:blood_bank/feature/auth/domain/repositories/auth_repository.dart';
import 'package:blood_bank/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:blood_bank/feature/home/domain/usecases/add_donor_request_usecase.dart';
import 'package:blood_bank/feature/home/domain/usecases/get_donor_use_case.dart';
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
          create: (context) =>
              AuthBloc(authRepository: getIt<AuthRepository>()),
        ),
        BlocProvider(
          create: (context) => AddDonorRequestBloc(
            getIt.get<AddDonorRequestUseCase>(),
            getIt.get<GetDonorByIdUseCase>(),
          ),
        ),
      ],
      child: BlocBuilder<LocaleCubit, ChangeLocaleState>(
        builder: (context, state) {
          return MaterialApp(
            theme: ThemeData(
                fontFamily: 'iwanzaza', scaffoldBackgroundColor: Colors.white,
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
            }
          );

        },
      ),
    );
  }
}
