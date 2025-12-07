import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/widget/coustom_dialog.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/need/blood_request_card.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/need/blood_skeletonizer.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

class BloodRequest extends StatelessWidget {
  const BloodRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('neederRequest')
            .where('uId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots()
            .distinct((prev, next) => prev.docs == next.docs),
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return CustomDialog(
              title: 'error_occurred'.tr(context),
              content: 'error_occurred: ${snapshot.error}'.tr(context),
            );
          }
          if (!snapshot.hasData) {
            return ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => const BloodRequestSkeletonCard(),
            );
          }

          final requests = snapshot.data?.docs ?? [];
          if (requests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'not_submitted'.tr(context),
                    style: TextStyles.bold16.copyWith(color: AppColors.primaryColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: Lottie.asset(
                      'assets/images/no_request.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            );
          }


          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index].data();
              return BloodRequestCard(request: request);
            },
          );
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text("Blood Requests", style: TextStyles.semiBold19),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}

