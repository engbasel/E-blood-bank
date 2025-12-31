import 'dart:async';
import 'package:blood_bank/constants.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/auth/data/models/user_model.dart';
import 'package:blood_bank/feature/chat/data/repo/agreement_repo_imple.dart';
import 'package:blood_bank/feature/chat/presentation/views/widgets/agreement_bottom_header.dart';
import 'package:blood_bank/feature/chat/presentation/views/widgets/agreement_form_sheet.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SmartAgreementBottomBar extends StatefulWidget {
  final String neederIdFromChat;
  final String donorIdFromChat;
  final String chatId;

  const SmartAgreementBottomBar({
    super.key,
    required this.neederIdFromChat,
    required this.chatId,
    required this.donorIdFromChat,
  });

  @override
  State<SmartAgreementBottomBar> createState() =>
      _SmartAgreementBottomBarState();
}

class _SmartAgreementBottomBarState extends State<SmartAgreementBottomBar> {
  bool isTemporarilyHidden = false;
  Timer? _timer;
  late Future<List<UserModel>> usersFuture;

  @override
  void initState() {
    super.initState();
    usersFuture = AgreementRepoImpl().sortUsersByState(
      widget.neederIdFromChat,
      widget.donorIdFromChat,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || isTemporarilyHidden) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<List<UserModel>>(
      future: usersFuture,
      builder: (context, usersSnapshot) {
        if (!usersSnapshot.hasData) return const SizedBox.shrink();

        final donor = usersSnapshot.data![0];
        final needer = usersSnapshot.data![1];

        if (currentUser.uid != needer.uId) return const SizedBox.shrink();

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("chats")
              .doc(widget.chatId)
              .collection("messages")
              .orderBy('timestamp', descending: true)
              .limit(10)
              .snapshots(),
          builder: (context, messagesSnapshot) {
            if (messagesSnapshot.hasError) {
              return const SizedBox.shrink();
            }

            if (!messagesSnapshot.hasData) return const SizedBox.shrink();

            final messages = messagesSnapshot.data!.docs;

            if (!hasRecentAgreement(messages)) {
              return const SizedBox.shrink();
            }

            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(needer.uId)
                  .snapshots(),
              builder: (context, userDocSnapshot) {
                if (!userDocSnapshot.hasData) return const SizedBox.shrink();
                final userData =
                    userDocSnapshot.data!.data() as Map<String, dynamic>?;
                if (userData == null || userData['userState'] != 'need') {
                  return const SizedBox.shrink();
                }

                return _buildAgreementUI(donor, needer);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildAgreementUI(UserModel donor, UserModel needer) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const AgreementBottomHeader(),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextButton(
                      onPressed: toggleVisibility,
                      child: Text('Not yet'.tr(context),
                          style: TextStyles.semiBold16
                              .copyWith(color: Colors.grey[600])),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) =>
                              AgreementFormSheet(donor: donor, needer: needer),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle_outline,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text('Yes, Agreed'.tr(context),
                              style: TextStyles.bold16
                                  .copyWith(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toggleVisibility() {
    setState(() => isTemporarilyHidden = true);
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => isTemporarilyHidden = false);
    });
  }

  bool hasRecentAgreement(List<QueryDocumentSnapshot> messages) {
    if (messages.isEmpty) return false;

    final now = DateTime.now();

    for (var doc in messages) {
      final data = doc.data() as Map<String, dynamic>;

      final String content = (data['text'] ?? '').toString().toLowerCase();

      final dynamic timeData = data['timestamp'];

      if (timeData is Timestamp) {
        DateTime messageTime = timeData.toDate();

        bool containsKeyword =
            kagreementKeywords.any((kw) => content.contains(kw));
        bool isRecent = now.difference(messageTime).inHours < 24;

        if (containsKeyword && isRecent) {
          return true;
        }
      }
    }
    return false;
  }
}
