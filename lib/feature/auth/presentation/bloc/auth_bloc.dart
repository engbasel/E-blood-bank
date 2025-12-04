import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:blood_bank/feature/auth/domain/entities/user_entity.dart';
import 'package:blood_bank/feature/auth/domain/repositories/auth_repository.dart';
import 'package:blood_bank/feature/auth/domain/usecases/sign_in_with_google.dart';
import 'package:blood_bank/feature/auth/presentation/bloc/auth_event.dart';
import 'package:blood_bank/feature/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<UserEntity?>? _authStateSubscription;
  final SignInWithGoogle signInWithGoogleUseCase;

  AuthBloc( {
    required AuthRepository authRepository,
    required this.signInWithGoogleUseCase,

  })  : _authRepository = authRepository,
        super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    on<SignUpWithEmailEvent>(_onSignUpWithEmail);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignInWithFacebookEvent>(_onSignInWithFacebook);
    on<SignOutEvent>(_onSignOut);
    on<ResetPasswordEvent>(_onResetPassword);
    on<VerifyEmailEvent>(_onVerifyEmail);
    on<DeleteAccountEvent>(_onDeleteAccount);
    on<UpdateUserEvent>(_onUpdateUser);

    // _authStateSubscription = _authRepository.authStateChanges.listen(
    //   (user) {
    //     if (user == null) {
    //       emit(Unauthenticated());
    //     } else if (!user.emailVerified) {
    //       emit(EmailNotVerified(user));
    //     } else {
    //       emit(Authenticated(user));
    //     }
    //   },
    // );
    _authRepository.authStateChanges.listen((user) {
      add(AuthStatusChanged(user));
    });

    on<AuthStatusChanged>((event, emit) {
      if (event.user == null) {
        emit(Unauthenticated());
      } else if (!event.user!.emailVerified) {
        emit(EmailNotVerified(event.user!));
      } else {
        emit(Authenticated(event.user!));
      }
    });

  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _authRepository.getCurrentUser();
    result.fold(
      (failure) => emit(Unauthenticated()),
      (user) => user.emailVerified
          ? emit(Authenticated(user))
          : emit(EmailNotVerified(user)),
    );
  }

  Future<void> _onSignInWithEmail(
    SignInWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthActionInProgress());
    final result = await _authRepository.signInWithEmailAndPassword(
      event.email,
      event.password,
    );
    result.fold(
      (failure) => emit(AuthActionFailure(failure.toString())),
      (user) => user.emailVerified
          ? emit(Authenticated(user))
          : emit(EmailNotVerified(user)),
    );
  }

  Future<void> _onSignUpWithEmail(
    SignUpWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthActionInProgress());
    final result = await _authRepository.signUpWithEmailAndPassword(
        event.email, event.password, event.name);
    result.fold(
      (failure) => emit(AuthActionFailure(failure.toString())),
      (user) => emit(EmailNotVerified(user)),
    );
  }
  //
  // Future<void> _onSignInWithGoogle(
  //   SignInWithGoogleEvent event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(AuthActionInProgress());
  //   final result = await _authRepository.signInWithGoogle();
  //   result.fold(
  //     (failure) => emit(AuthActionFailure(failure.toString())),
  //     (user) => emit(Authenticated(user)),
  //   );
  // }

  Future<void> _onSignInWithGoogle(
      SignInWithGoogleEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthActionInProgress());
    final result = await signInWithGoogleUseCase();
    result.fold(
          (failure) => emit(AuthActionFailure(failure.toString())),
          (user) => emit(Authenticated(user)),
    );
  }


  Future<void> _onSignInWithFacebook(
    SignInWithFacebookEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthActionInProgress());
    final result = await _authRepository.signInWithFacebook();
    result.fold(
      (failure) => emit(AuthActionFailure(failure.toString())),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthActionInProgress());
    final result = await _authRepository.signOut();
    result.fold(
      (failure) => emit(AuthActionFailure(failure.toString())),
      (_) => emit(Unauthenticated()),
    );
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthActionInProgress());

    final result = await _authRepository.resetPassword(event.email);
    result.fold(
      (failure) => emit(AuthActionFailure(failure.toString())),
      (_) => emit( AuthActionSuccess('Password reset email sent')),
    );
  }

  Future<void> _onVerifyEmail(
    VerifyEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthActionInProgress());

    final result = await _authRepository.verifyEmail();
    result.fold(
      (failure) => emit(AuthActionFailure(failure.toString())),
      (_) => emit(const AuthActionSuccess('Verification email sent',)),
    );
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthActionInProgress());
    final result = await _authRepository.deleteAccount();
    result.fold(
      (failure) => emit(AuthActionFailure(failure.toString())),
      (_) => emit(Unauthenticated()),
    );
  }

  Future<void> _onUpdateUser(
    UpdateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthActionInProgress());
    final currentUser = (state as Authenticated).user;
    final updatedUser = currentUser.copyWith(
      name: event.name,
      photoUrl: event.photoURL,
      bloodType: event.bloodType,
    );

    final result = await _authRepository.updateUserProfile(updatedUser);
    result.fold(
      (failure) => emit(AuthActionFailure(failure.toString())),
      (_) => emit(Authenticated(updatedUser)),
    );
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
