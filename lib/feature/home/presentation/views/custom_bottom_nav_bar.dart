import 'dart:async';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/core/utils/page_rout_builder.dart';
import 'package:blood_bank/feature/home/presentation/views/donor_view.dart';
import 'package:blood_bank/feature/home/presentation/views/home_view.dart';
import 'package:blood_bank/feature/home/presentation/views/need_view.dart';
import 'package:blood_bank/feature/home/presentation/views/profile_view.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/chat_bot/chat_bot_view_body.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int selected = 0;
  bool shouldAnimateLottie = false;
  Timer? animationTimer;
  int animationCount = 0;

  @override
  void initState() {
    super.initState();
    _startAnimationCycle();
  }

  void _startAnimationCycle() {
    _playAnimationTwice();
    animationTimer = Timer.periodic(const Duration(minutes: 3), (timer) {
      if (animationCount < 3) {
        _playAnimationTwice();
      } else {
        animationTimer?.cancel();
      }
    });
  }

  void _playAnimationTwice() async {
    if (animationCount >= 3) return;
    setState(() {
      shouldAnimateLottie = true;
      animationCount++;
    });
    await Future.delayed(const Duration(seconds: 3));
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => shouldAnimateLottie = true);
    await Future.delayed(const Duration(seconds: 3));
    setState(() => shouldAnimateLottie = false);
  }

  @override
  void dispose() {
    animationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeView(),
      NeedView(),
      const DonorView(),
      ProfileView(
        selected: selected,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xff800000),
      extendBody: true,
      bottomNavigationBar: _buildBottomBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: IndexedStack(
          index: selected,
          children: screens,
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      color: Colors.white,
      height: 80,
      child: StylishBottomBar(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        option: DotBarOptions(
          dotStyle: DotStyle.tile,
          gradient: const LinearGradient(
            colors: [Colors.deepPurple, Colors.pink],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        items: [
          _buildBottomBarItem(Assets.imagesHome, 'home'.tr(context)),
          _buildBottomBarItem(Assets.imagesNeed, 'need'.tr(context)),
          _buildBottomBarItem(Assets.imagesDoner, 'donor'.tr(context)),
          _buildBottomBarItem(Assets.imagesProfile, 'profile'.tr(context)),
        ],
        hasNotch: true,
        fabLocation: StylishBarFabLocation.center,
        currentIndex: selected,
        notchStyle: NotchStyle.circle,
        onTap: (index) {
          if (index != selected) {
            setState(() {
              selected = index;
            });
          }
        },
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      elevation: 15,
      shape: const CircleBorder(),
      onPressed: () {
        Navigator.of(context).push(
          buildPageRoute(const ChatBotViewBody()),
        );
      },
      backgroundColor: AppColors.primaryColor,
      child: Lottie.asset(
        'assets/chatbot.json',
        height: 40,
        width: 40,
        fit: BoxFit.contain,
        repeat: shouldAnimateLottie,
        animate: shouldAnimateLottie,
      ),
    );
  }

  BottomBarItem _buildBottomBarItem(String asset, String label) {
    return BottomBarItem(
      icon: SvgPicture.asset(
        asset,
        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
        height: 28,
      ),
      selectedIcon: SvgPicture.asset(
        asset,
        height: 30,
      ),
      selectedColor: AppColors.primaryColor,
      title: Text(label),
    );
  }
}
