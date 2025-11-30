// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:blood_bank/feature/chat/data/repo/chat_repo.dart';
// import 'message_state.dart';

// class MessageCubit extends Cubit<MessageState> {
//   final ChatRepository chatRepository;
//   final String currentUserId;
//   final String otherUserId;

//   MessageCubit({
//     required this.chatRepository,
//     required this.currentUserId,
//     required this.otherUserId,
//   }) : super(MessageInitial());

//   void fetchMessages() async {
//     emit(MessageLoading());
//     final chatId = chatRepository.generateChatId(currentUserId, otherUserId);

//     final result = await chatRepository.getChatData(chatId);
//     result.fold(
//       (failure) => emit(MessageError(failure.toString())),
//       (chatData) {
//         emit(MessageLoaded(chatData));
//       },
//     );
//   }
// }
