import 'package:blood_bank/core/helper_function/generate_chat_id_fun.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/feature/chat/presentation/views/chat_screen_view.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NeedDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> needData;
  const NeedDetailsScreen({super.key, required this.needData});

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        title: Text(
          'need_details'.tr(context),
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.backgroundColor,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(context),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.backgroundColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 3,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        userName: needData['name'],
                        userImage: needData['photoUrl'],
                        chatId: generateChatId(currentUserId, needData['uId']),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.wechat_outlined,
                    color: Colors.white, size: 26),
                label: Text(
                  "send_message".tr(context),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              needData['patientName'] ?? 'no_name'.tr(context),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.local_hospital,
                    color: AppColors.backgroundColor),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    needData['hospitalName'] ?? 'no_hospital'.tr(context),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Details Section
  Widget _buildDetailsSection(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailItem(
                context, Icons.location_on, 'address', needData['address']),
            _buildDetailItem(
                context, Icons.cake, 'age', needData['age'].toString()),
            _buildDetailItem(
                context, Icons.bloodtype, 'blood_type', needData['bloodType']),
            _buildDetailItem(
                context, Icons.phone, 'contact', needData['contact']),
            _buildDetailItem(context, Icons.volunteer_activism, 'donation_type',
                needData['donationType']),
            _buildDetailItem(
                context, Icons.person, 'gender', needData['gender']),
            _buildDetailItem(context, Icons.credit_card, 'id_card',
                needData['idCard'].toString()),
            _buildDetailItem(context, Icons.calendar_today, 'date_time',
                needData['dateTime']),
            _buildDetailItem(context, Icons.health_and_safety,
                'medical_conditions', needData['medicalConditions']),
            _buildDetailItem(
                context, Icons.assignment, 'status', needData['status']),
          ],
        ),
      ),
    );
  }

  // Detail Item
  Widget _buildDetailItem(
      BuildContext context, IconData icon, String labelKey, dynamic value) {
    String formattedValue = _formatDate(value);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.backgroundColor),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              '${labelKey.tr(context)}:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              formattedValue,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic value) {
    try {
      DateTime date;
      if (value is Timestamp) {
        date = value.toDate();
      } else if (value is String) {
        date = DateTime.parse(value);
      } else {
        return value.toString();
      }
      return DateFormat('dd - MM - yyyy').format(date);
    } catch (e) {
      return value.toString();
    }
  }
}
