/// stream_messages_usecase.dart
library;

import 'dart:async';
import 'package:blood_bank/core/error/failures.dart';
import 'package:blood_bank/feature/chat/domain/entities/message_entity.dart';
import 'package:blood_bank/feature/chat/domain/repo/chat_repo.dart';
import 'package:dartz/dartz.dart';

class StreamMessagesUseCase {
  final ChatRepository repository;

  const StreamMessagesUseCase(this.repository);

  Stream<Either<Failure, List<MessageEntity>>> call(String otherUserId) {
    return repository.streamMessages(otherUserId);
  }
}
