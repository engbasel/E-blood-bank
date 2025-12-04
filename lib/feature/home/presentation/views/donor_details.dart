import 'package:blood_bank/core/helper_function/generate_chat_id_fun.dart';
import 'package:blood_bank/feature/chat/presentation/views/chat_screen_view.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_bloc.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_state.dart';
import 'package:blood_bank/feature/home/presentation/views/info_tile.dart';
import 'package:blood_bank/feature/home/presentation/views/info_section.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DonorProfileScreen extends StatelessWidget {
  final String uId;
  final Color primaryColor = const Color(0xff800000);

  const DonorProfileScreen({super.key, required this.uId});

  String formatDate(dynamic date, BuildContext context) {
    if (date == null) return 'n_a'.tr(context);
    if (date is Timestamp) {
      return DateFormat('MMM dd, yyyy').format(date.toDate());
    }
    if (date is DateTime) {
      return DateFormat('MMM dd, yyyy').format(date);
    }

    if (date is String) return date;
    return 'n_a'.tr(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Directionality(
      textDirection:
          isArabic ? flutter.TextDirection.rtl : flutter.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text('donor_profile'.tr(context),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: primaryColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<DonorRequestsBloc, DonorRequestsState>(
          builder: (context, state) {
            if (state is DonorRequestsLoaded || state is DonorRequestsSuccess) {
              final requests = state is DonorRequestsLoaded
                  ? state.requests
                  : (state as DonorRequestsSuccess).requests;

              final donorList = requests.where((r) => r.uId == uId).toList();
              final donor = donorList.first;
              print('=========================================');
              print(donor.lastDonationDate);
              print('=========================================');

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: donor.photoUrl != null &&
                                    donor.photoUrl!.isNotEmpty
                                ? NetworkImage(donor.photoUrl!)
                                : null,
                            backgroundColor: Colors.white,
                            child: (donor.photoUrl == null ||
                                    donor.photoUrl!.isEmpty)
                                ? Icon(Icons.person,
                                    size: 60, color: primaryColor)
                                : null,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            donor.name.isNotEmpty
                                ? donor.name
                                : 'unknown'.tr(context),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              donor.bloodType.isNotEmpty
                                  ? donor.bloodType
                                  : 'n_a'.tr(context),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    contactNumber: donor.contact.toString(),
                                    userName: donor.name,
                                    userImage: donor.photoUrl!,
                                    chatId: generateChatId(
                                        currentUserId, donor.uId),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(30),
                                border:
                                    Border.all(color: Colors.white, width: 1),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.message_rounded,
                                      color: Colors.white, size: 24),
                                  const SizedBox(width: 8),
                                  Text(
                                    'send_to_donor'.tr(context),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InfoSection(
                      title: 'personal_info'.tr(context),
                      icon: Icons.person_outline,
                      primaryColor: primaryColor,
                      children: [
                        InfoTile(
                            icon: Icons.badge_outlined,
                            label: 'full_name'.tr(context),
                            value: donor.name),
                        InfoTile(
                            icon: Icons.cake_outlined,
                            label: 'age'.tr(context),
                            value: donor.age.toString()),
                        InfoTile(
                            icon: Icons.wc_outlined,
                            label: 'gender'.tr(context),
                            value: donor.gender),
                        InfoTile(
                            icon: Icons.credit_card_outlined,
                            label: 'id_card'.tr(context),
                            value: donor.idCard.toString()),
                      ],
                    ),
                    InfoSection(
                      title: 'donation_info'.tr(context),
                      icon: Icons.bloodtype_outlined,
                      primaryColor: primaryColor,
                      children: [
                        InfoTile(
                            icon: Icons.bloodtype,
                            label: 'blood_type'.tr(context),
                            value: donor.bloodType),
                        InfoTile(
                            icon: Icons.category_outlined,
                            label: 'donation_type'.tr(context),
                            value: donor.donationType),
                        InfoTile(
                            icon: Icons.water_drop_outlined,
                            label: 'units'.tr(context),
                            value: donor.units.toString()),
                        InfoTile(
                            icon: Icons.calendar_today_outlined,
                            label: 'last_donation_date'.tr(context),
                            value: formatDate(donor.lastDonationDate, context)),
                        InfoTile(
                            icon: Icons.event_outlined,
                            label: 'next_donation_date'.tr(context),
                            value: formatDate(donor.nextDonationDate, context)),
                        InfoTile(
                            icon: Icons.schedule_outlined,
                            label: 'last_request_date'.tr(context),
                            value: formatDate(donor.lastRequestDate, context)),
                      ],
                    ),
                    InfoSection(
                      title: 'contact_info'.tr(context),
                      icon: Icons.contact_phone_outlined,
                      primaryColor: primaryColor,
                      children: [
                        InfoTile(
                            icon: Icons.phone_outlined,
                            label: 'contact_number'.tr(context),
                            value: donor.contact.toString()),
                        InfoTile(
                            icon: Icons.location_on_outlined,
                            label: 'address'.tr(context),
                            value: donor.address),
                        InfoTile(
                            icon: Icons.local_hospital_outlined,
                            label: 'hospital_name'.tr(context),
                            value: donor.hospitalName),
                        InfoTile(
                            icon: Icons.directions_outlined,
                            label: 'distance'.tr(context),
                            value: '${donor.distance} km'),
                      ],
                    ),
                    InfoSection(
                      title: 'medical_info'.tr(context),
                      icon: Icons.medical_information_outlined,
                      primaryColor: primaryColor,
                      children: [
                        InfoTile(
                            icon: Icons.health_and_safety_outlined,
                            label: 'medical_conditions'.tr(context),
                            value: donor.medicalConditions,
                            isMultiline: true),
                        InfoTile(
                            icon: Icons.notes_outlined,
                            label: 'additional_notes'.tr(context),
                            value: donor.notes,
                            isMultiline: true),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            }

            if (state is DonorRequestsFailure) {
              return Center(child: Text(state.message));
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
