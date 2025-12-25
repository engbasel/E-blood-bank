import 'package:blood_bank/core/widget/coustom_dialog.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/update_last_donation_date.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:restart_app/restart_app.dart';
import 'package:blood_bank/constants.dart';
import 'package:blood_bank/core/helper_function/get_user.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/widget/coustom_circular_progress_indicator.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/logout_button.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:blood_bank/feature/localization/cubit/locale_cubit.dart';
import 'package:blood_bank/feature/auth/data/models/user_model.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/big_info_card.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/custom_app_bar_profile.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/settings_item.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/settings_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
  });

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> with WidgetsBindingObserver {
  final shorebirdUpdater = ShorebirdUpdater();

  bool _isCheckingForUpdates = false;
  UpdateTrack currentTrack = UpdateTrack.stable;
  bool _notificationsEnabled = true;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkNotificationPermission();
    _initializeNotifications();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkNotificationPermission();
    }
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _checkNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enable notifications in device settings.'),
          action: SnackBarAction(
            label: 'Open Settings',
            onPressed: () {
              openAppSettings();
            },
          ),
        ),
      );
    }
    setState(() {
      _notificationsEnabled = status.isGranted;
    });
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification permission granted!')),
      );
    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification permission denied!')),
      );
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    final status = await Permission.notification.status;

    if (value && (status.isDenied || status.isPermanentlyDenied)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enable notifications in device settings.'),
          action: SnackBarAction(
            label: 'Open Settings',
            onPressed: () {
              openAppSettings();
            },
          ),
        ),
      );
      setState(() {
        _notificationsEnabled = false;
      });
      return;
    }

    setState(() {
      _notificationsEnabled = value;
    });

    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    if (value) {
      await _requestNotificationPermission();
      await firebaseMessaging.subscribeToTopic('all_users');
    } else {
      await firebaseMessaging.unsubscribeFromTopic('all_users');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'To fully disable notifications, please disable them in device settings.'),
          action: SnackBarAction(
            label: 'Open Settings',
            onPressed: () {
              openAppSettings();
            },
          ),
        ),
      );
    }
  }

  Future<void> _checkForUpdate() async {
    if (_isCheckingForUpdates) return;

    try {
      setState(() => _isCheckingForUpdates = true);
      final status = await shorebirdUpdater.checkForUpdate(track: currentTrack);
      if (!mounted) return;

      switch (status) {
        case UpdateStatus.upToDate:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('up_to_date'.tr(context))),
          );
        case UpdateStatus.outdated:
          _showUpdateDialog(context, shorebirdUpdater);
        case UpdateStatus.restartRequired:
          _showRestartSnackBar(context);
        case UpdateStatus.unavailable:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('update_unavailable'.tr(context))),
          );
      }
    } catch (error) {
      debugPrint('Error checking for update: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error_checking_for_update'.tr(context))),
      );
    } finally {
      setState(() => _isCheckingForUpdates = false);
    }
  }

  Future<void> _downloadUpdate(ShorebirdUpdater updater) async {
    try {
      await updater.update(track: currentTrack);
      if (!mounted) return;

      _showRestartSnackBar(context);
    } on UpdateException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('update_failed: ${e.message}'.tr(context))),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('update_failed: ${e.toString()}'.tr(context))),
      );
    }
  }

  void _showUpdateDialog(BuildContext context, ShorebirdUpdater updater) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('update_available'.tr(context)),
          content: Text('update_available_message'.tr(context)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('later'.tr(context)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _downloadUpdate(updater);
              },
              child: Text('update_now'.tr(context)),
            ),
          ],
        );
      },
    );
  }

  void _showRestartSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('update_downloaded_restart'.tr(context)),
        action: SnackBarAction(
          label: 'Restart',
          onPressed: () {
            Restart.restartApp();
          },
        ),
        duration: const Duration(seconds: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              StreamBuilder<UserModel>(
                stream: getUserStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CustomCircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return CustomDialog(
                      title: 'error_occurred'.tr(context),
                      content: 'error_occurred: ${snapshot.error}'.tr(context),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Center(
                        child: Text('no_user_data_available'.tr(context)));
                  }

                  final user = snapshot.data!;

                  return CustomProfileAppBar(
                    name: user.name!,
                    photoUrl: user.photoUrl,
                    userState: user.userState.tr(context),
                  );
                },
              ),
              const SizedBox(height: 60),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: kHorizintalPadding),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    SettingsSwitch(
                      title: 'available_to_donate'.tr(context),
                      keyName: 'available_to_donate',
                      value: true,
                      onChanged: (value) {},
                    ),
                    SettingsSwitch(
                      title: 'notification'.tr(context),
                      keyName: 'notification',
                      value: _notificationsEnabled,
                      onChanged: _toggleNotifications,
                    ),
                    SettingsItem(
                      title: 'manage_address'.tr(context),
                      icon: Icons.location_on,
                    ),
                    UpdateLastDonationDateTile(),
                    SettingsItem(
                      title: 'language'.tr(context),
                      icon: Icons.language,
                      onTap: () => _showLanguagePicker(context),
                    ),
                    SettingsItem(
                      title: 'Check for updates'.tr(context),
                      icon: Icons.arrow_forward_ios,
                      onTap: _checkForUpdate,
                    ),
                    const SizedBox(height: 20),
                    LogoutFeature(),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 175,
            left: 20,
            right: 20,
            child: StreamBuilder<UserModel>(
              stream: getUserStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CustomCircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return CustomDialog(
                    title: 'error_occurred'.tr(context),
                    content: 'error_occurred: ${snapshot.error}'.tr(context),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(
                      child: Text('no_user_data_available'.tr(context)));
                }

                final user = snapshot.data!;
                return BigInfoCard(
                  savedLives: 'lives_saved'.tr(context),
                  bloodGroup:
                      '${user.bloodType?.tr(context)} ${'group'.tr(context)}',
                  nextDonationDate: 'next_donation_date'.tr(context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'choose_language'.tr(context),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.language, color: Colors.white),
                title: Text('English',
                    style: const TextStyle(color: Colors.white)),
                onTap: () {
                  context.read<LocaleCubit>().changeLanguage('en');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language, color: Colors.white),
                title: Text('العربية',
                    style: const TextStyle(color: Colors.white)),
                onTap: () {
                  context.read<LocaleCubit>().changeLanguage('ar');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
