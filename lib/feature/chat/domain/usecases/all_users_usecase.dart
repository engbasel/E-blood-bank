/// stream_all_users_usecase.dart
library;

import 'dart:async';
import 'package:blood_bank/core/error/failures.dart';
import 'package:blood_bank/feature/auth/domain/entities/user_entity.dart';
import 'package:blood_bank/feature/chat/domain/repo/chat_repo.dart';
import 'package:dartz/dartz.dart';

class StreamAllUsersUseCase {
  final ChatRepository repository;

  const StreamAllUsersUseCase(this.repository);

  Stream<Either<Failure, List<UserEntity>>> call() {
    return repository.streamAllUsers();
  }
}
