import 'package:blood_bank/feature/chat/domain/repo/chat_repo.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<void> call({
    required String receiverId,
    required String content,
    required String senderId,
  }) async {
    return await repository.sendMessage(
      receiverId: receiverId,
      content: content,
      senderId: senderId,
    );
  }
}
