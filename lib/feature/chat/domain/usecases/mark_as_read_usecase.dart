import 'package:blood_bank/feature/chat/domain/repo/chat_repo.dart';

class MarkMessagesAsReadUseCase {
  final ChatRepository repository;

  MarkMessagesAsReadUseCase(this.repository);

  Future<void> call(String otherUserId) async {
    return await repository.markMessagesAsRead(otherUserId);
  }
}
