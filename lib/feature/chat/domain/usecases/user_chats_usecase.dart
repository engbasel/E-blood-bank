/// stream_user_chats_usecase.dart
library;

import 'dart:async';
import 'package:blood_bank/core/error/failures.dart';
import 'package:blood_bank/feature/chat/domain/entities/chat_entity.dart';
import 'package:blood_bank/feature/chat/domain/repo/chat_repo.dart';
import 'package:dartz/dartz.dart';

class StreamUserChatsUseCase {
  final ChatRepository repository;

  const StreamUserChatsUseCase(this.repository);

  Stream<Either<Failure, List<ChatEntity>>> call(String currentUserId) {
    return repository.streamUserChats(currentUserId);
  }
}
