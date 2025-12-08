import 'dart:convert';
import 'package:blood_bank/constants.dart';
import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
import 'package:blood_bank/core/services/firestor_service.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/core/utils/page_rout_builder.dart';
import 'package:blood_bank/core/widget/coustom_circular_progress_indicator.dart';
import 'package:blood_bank/core/widget/custom_app_bar.dart';
import 'package:blood_bank/core/widget/custom_button.dart';
import 'package:blood_bank/feature/auth/presentation/view/widget/preference_button.dart';
import 'package:blood_bank/feature/home/presentation/views/custom_bottom_nav_bar.dart';
import 'package:blood_bank/core/services/shared_preferences_sengleton.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DonorOrNeed extends StatefulWidget {
  const DonorOrNeed({super.key});

  @override
  State<DonorOrNeed> createState() => _DonorOrNeedState();
}

class _DonorOrNeedState extends State<DonorOrNeed> {
  String? selectedKey;
  bool isSaving = false;
  final FirestorService fireStoreService = FirestorService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfUserStateExists();
    });
  }

  Future<void> _checkIfUserStateExists() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userId = user.uid;
      final isUserStateSelected =
      Prefs.getBool('${userId}_$kIsUserStateSelected');
      if (isUserStateSelected) {
        Navigator.of(context).pushAndRemoveUntil(
          buildPageRoute(const CustomBottomNavBar()),
              (Route<dynamic> route) => false,
        );
      }
    }
  }

  Future<void> saveUserState() async {
    if (selectedKey == null) {
      failureTopSnackBar(context, 'please_select_an_option'.tr(context));
      return;
    }

    setState(() {
      isSaving = true;
    });

    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userId = user.uid;

      try {
        await fireStoreService.updateData(
          path: 'users',
          docuementId: userId,
          data: {'userState': selectedKey},
        );

        final currentUserData = Prefs.getString(kUserData);
        Map<String, dynamic> userData =
        currentUserData.isNotEmpty ? jsonDecode(currentUserData) : {};

        userData['userState'] = selectedKey;
        Prefs.setString(kUserData, jsonEncode(userData));
        Prefs.setBool('${userId}_$kIsUserStateSelected', true);

        successTopSnackBar(
            context, 'user_state_updated_successfully'.tr(context));

        Navigator.of(context).pushReplacement(
          buildPageRoute(const CustomBottomNavBar()),
        );
      } catch (e) {
        failureTopSnackBar(context, 'failed_to_update_user_state'.tr(context));
      } finally {
        setState(() {
          isSaving = false;
        });
      }
    } else {
      failureTopSnackBar(context, 'user_not'.tr(context));
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        top: 120,
        left: 50,
        title: '',
        leadingIcon: Icons.arrow_back_ios_new_rounded,
        onSkipPressed: () {},
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
            child: Column(
              children: [
                const SizedBox(height: 90),
                Text(
                  "Choose which one do you prefer?".tr(context),
                  style: TextStyles.semiBold19,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PreferenceButton(
                        image: Assets.imagesNeed,
                        label: "need".tr(context),
                        isSelected: selectedKey == "need",
                        onPressed: () {
                          setState(() {
                            selectedKey = "need";
                          });
                        },
                      ),
                      SizedBox(width: width * 0.1),
                      PreferenceButton(
                        image: Assets.imagesDoner,
                        label: "donor".tr(context),
                        isSelected: selectedKey == "donor",
                        onPressed: () {
                          setState(() {
                            selectedKey = "donor";
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                CustomButton(
                  onPressed: saveUserState,
                  text: isSaving ? "Saving...".tr(context) : "next".tr(context),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
          if (isSaving)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CustomCircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

