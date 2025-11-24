import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_bloc.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_event.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_bloc/add_donor_request_state.dart';
import 'package:blood_bank/feature/home/presentation/views/info_tile.dart';
import 'package:blood_bank/feature/home/presentation/views/info_section.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DonorProfileScreen extends StatefulWidget {
  final String uId;

  const DonorProfileScreen({super.key, required this.uId});

  @override
  State<DonorProfileScreen> createState() => _DonorProfileScreenState();
}

class _DonorProfileScreenState extends State<DonorProfileScreen> {
  final Color primaryColor = const Color(0xff800000);

  @override
  void initState() {
    super.initState();
    context.read<AddDonorRequestBloc>().add(GetDonorByIdEvent(userId: widget.uId));
  }

  String formatDate(dynamic date) {
    if (date == null) return 'n_a'.tr(context);
    if (date is Timestamp) {
      return DateFormat('MMM dd, yyyy').format(date.toDate());
    }
    if (date is String) return date;
    return 'n_a'.tr(context);
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? flutter.TextDirection.rtl : flutter.TextDirection.ltr,

      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'donor_profile'.tr(context),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: primaryColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<AddDonorRequestBloc, AddDonorRequestState>(
          builder: (context, state) {
            if (state is AddDonorRequestLoading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              );
            }

            if (state is AddDonorRequestFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<AddDonorRequestBloc>().add(
                            GetDonorByIdEvent(userId: widget.uId),
                          );
                        },
                        icon: const Icon(Icons.refresh),
                        label: Text('retry'.tr(context)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is DonorDataLoaded) {
              final donorData = state.donorData;

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
                            backgroundImage: donorData['photoUrl'] != null && donorData['photoUrl'].isNotEmpty
                                ? NetworkImage(donorData['photoUrl'])
                                : null,
                            backgroundColor: Colors.white,
                            child: (donorData['photoUrl'] == null || donorData['photoUrl'].isEmpty)
                                ? Icon(Icons.person, size: 60, color: primaryColor)
                                : null,
                          ),

                          const SizedBox(height: 16),
                          Text(
                            donorData['name'] ?? 'unknown'.tr(context),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              donorData['bloodType'] ?? 'n_a'.tr(context),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
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
                        InfoTile(icon: Icons.badge_outlined, label: 'full_name'.tr(context), value: donorData['name'] ?? 'n_a'.tr(context)),
                        InfoTile(icon: Icons.cake_outlined, label: 'age'.tr(context), value: donorData['age']?.toString() ?? 'n_a'.tr(context)),
                        InfoTile(icon: Icons.wc_outlined, label: 'gender'.tr(context), value: donorData['gender'] ?? 'n_a'.tr(context)),
                        InfoTile(icon: Icons.credit_card_outlined, label: 'id_card'.tr(context), value: donorData['idCard']?.toString() ?? 'n_a'.tr(context)),
                      ],
                    ),
                    InfoSection(
                      title: 'donation_info'.tr(context),
                      icon: Icons.bloodtype_outlined,
                      primaryColor: primaryColor,
                      children: [
                        InfoTile(icon: Icons.bloodtype, label: 'blood_type'.tr(context), value: donorData['bloodType'] ?? 'n_a'.tr(context)),
                        InfoTile(icon: Icons.category_outlined, label: 'donation_type'.tr(context), value: donorData['donationType'] ?? 'n_a'.tr(context)),
                        InfoTile(icon: Icons.water_drop_outlined, label: 'units'.tr(context), value: donorData['units']?.toString() ?? 'n_a'.tr(context)),
                        InfoTile(icon: Icons.calendar_today_outlined, label: 'last_donation_date'.tr(context), value: formatDate(donorData['lastDonationDate'])),
                        InfoTile(icon: Icons.event_outlined, label: 'next_donation_date'.tr(context), value: formatDate(donorData['nextDonationDate'])),
                        InfoTile(icon: Icons.schedule_outlined, label: 'last_request_date'.tr(context), value: formatDate(donorData['lastRequestDate'])),
                      ],
                    ),
                    InfoSection(
                      title: 'contact_info'.tr(context),
                      icon: Icons.contact_phone_outlined,
                      primaryColor: primaryColor,
                      children: [
                        InfoTile(icon: Icons.phone_outlined, label: 'contact_number'.tr(context), value: donorData['contact']?.toString() ?? 'n_a'.tr(context)),
                        InfoTile(icon: Icons.location_on_outlined, label: 'address'.tr(context), value: donorData['address'] ?? 'n_a'.tr(context)),
                        InfoTile(icon: Icons.local_hospital_outlined, label: 'hospital_name'.tr(context), value: donorData['hospitalName'] ?? 'n_a'.tr(context)),
                        InfoTile(icon: Icons.directions_outlined, label: 'distance'.tr(context), value: donorData['distance'] != null ? '${donorData['distance']} km' : 'n_a'.tr(context)),
                      ],
                    ),
                    InfoSection(
                      title: 'medical_info'.tr(context),
                      icon: Icons.medical_information_outlined,
                      primaryColor: primaryColor,
                      children: [
                        InfoTile(icon: Icons.health_and_safety_outlined, label: 'medical_conditions'.tr(context), value: donorData['medicalConditions'] ?? 'none'.tr(context), isMultiline: true),
                        InfoTile(icon: Icons.notes_outlined, label: 'additional_notes'.tr(context), value: donorData['notes'] ?? 'none'.tr(context), isMultiline: true),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

