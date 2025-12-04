import 'package:blood_bank/feature/home/domain/entities/needer_request_entity.dart';
import 'package:blood_bank/feature/home/presentation/views/info_tile.dart';
import 'package:blood_bank/feature/home/presentation/views/info_section.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:intl/intl.dart';


class NeederProfileScreen extends StatelessWidget {
  final NeederRequestEntity needer;
  final Color primaryColor = const Color(0xff800000);

  const NeederProfileScreen({super.key, required this.needer});

  String formatDate(DateTime? date, BuildContext context) {
    if (date == null) return 'n_a'.tr(context);
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? flutter.TextDirection.rtl : flutter.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text('patient_profile'.tr(context),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: primaryColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
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
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 60, color: primaryColor),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      needer.patientName.isNotEmpty ? needer.patientName : 'unknown'.tr(context),
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
                        needer.bloodType.isNotEmpty ? needer.bloodType : 'n_a'.tr(context),
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
                  InfoTile(icon: Icons.badge_outlined, label: 'full_name'.tr(context), value: needer.patientName),
                  InfoTile(icon: Icons.cake_outlined, label: 'age'.tr(context), value: needer.age.toString()),
                  InfoTile(icon: Icons.wc_outlined, label: 'gender'.tr(context), value: needer.gender),
                  InfoTile(icon: Icons.credit_card_outlined, label: 'id_card'.tr(context), value: needer.idCard.toString()),
                ],
              ),
              InfoSection(
                title: 'donation_info'.tr(context),
                icon: Icons.bloodtype_outlined,
                primaryColor: primaryColor,
                children: [
                  InfoTile(icon: Icons.bloodtype, label: 'blood_type'.tr(context), value: needer.bloodType),
                  InfoTile(icon: Icons.category_outlined, label: 'donation_type'.tr(context), value: needer.donationType),
                  InfoTile(icon: Icons.event_outlined, label: 'request_date'.tr(context), value: formatDate(needer.dateTime, context)),
                  InfoTile(icon: Icons.info_outline, label: 'status'.tr(context), value: needer.status),
                ],
              ),
              InfoSection(
                title: 'contact_info'.tr(context),
                icon: Icons.contact_phone_outlined,
                primaryColor: primaryColor,
                children: [
                  InfoTile(icon: Icons.phone_outlined, label: 'contact_number'.tr(context), value: needer.contact.toString()),
                  InfoTile(icon: Icons.location_on_outlined, label: 'address'.tr(context), value: needer.address),
                  InfoTile(icon: Icons.local_hospital_outlined, label: 'hospital_name'.tr(context), value: needer.hospitalName),
                ],
              ),
              InfoSection(
                title: 'medical_info'.tr(context),
                icon: Icons.medical_information_outlined,
                primaryColor: primaryColor,
                children: [
                  InfoTile(icon: Icons.health_and_safety_outlined, label: 'medical_conditions'.tr(context), value: needer.medicalConditions, isMultiline: true),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
