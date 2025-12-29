import 'dart:async';

import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/chat/presentation/views/widgets/agreement_bottom_header.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SmartAgreementBottomBar extends StatefulWidget {
  final String neederIdFromChat;

  final String chatId;
  const SmartAgreementBottomBar({
    super.key,
    required this.neederIdFromChat,
    required this.chatId,
  });

  @override
  State<SmartAgreementBottomBar> createState() =>
      _SmartAgreementBottomBarState();
}

class _SmartAgreementBottomBarState extends State<SmartAgreementBottomBar> {
  bool isHidden = false;

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null || currentUser.uid != widget.neederIdFromChat) {
      return const SizedBox.shrink();
    }

    if (isHidden) {
      return const SizedBox.shrink();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("chats")
          .doc(widget.chatId)
          .collection("messages")
          .snapshots(),
      builder: (context, messagesSnapshot) {
        if (!messagesSnapshot.hasData ||
            messagesSnapshot.data!.docs.length < 2) {
          return const SizedBox.shrink();
        }

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .snapshots(),
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData) return const SizedBox.shrink();

            final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
            if (userData == null || userData['userState'] != 'need') {
              return const SizedBox.shrink();
            }

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
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
                      AgreementBottomHeader(),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextButton(
                              onPressed: toggleVisibility,
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                'Not yet'.tr(context),
                                style: TextStyles.semiBold16.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[600],
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.check_circle_outline,
                                        size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Yes, Agreed'.tr(context),
                                      style: TextStyles.bold16,
                                    ),
                                  ],
                                ),
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
          },
        );
      },
    );
  }

  void toggleVisibility() {
    setState(() {
      isHidden = true;
    });

    _timer?.cancel();

    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          isHidden = false;
        });
      }
    });
  }
}
