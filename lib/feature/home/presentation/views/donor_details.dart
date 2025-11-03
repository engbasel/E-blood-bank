import 'package:blood_bank/feature/home/presentation/views/infoTile.dart';
import 'package:blood_bank/feature/home/presentation/views/info_section.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DonorProfileScreen extends StatefulWidget {
  final String uId;

  const DonorProfileScreen({super.key, required this.uId});

  @override
  State<DonorProfileScreen> createState() => _DonorProfileScreenState();
}

class _DonorProfileScreenState extends State<DonorProfileScreen> {
  final Color primaryColor = const Color(0xff800000);
  Map<String, dynamic>? donorData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchDonorData();
  }

  Future<void> fetchDonorData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('donerRequest')
          .where('uId', isEqualTo: widget.uId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          donorData = querySnapshot.docs.first.data();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Donor data not found';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load donor data: ${e.toString()}';
        isLoading = false;
      });
    }
  }


  String formatDate(dynamic date) {
    if (date == null) return 'N/A';
    if (date is Timestamp) {
      return DateFormat('MMM dd, yyyy').format(date.toDate());
    }
    if (date is String) return date;
    return 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Donor Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      )
          : errorMessage != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    errorMessage = null;
                  });
                  fetchDonorData();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
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
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    donorData?['name'] ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      donorData?['bloodType'] ?? 'N/A',
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

            // Personal Info Section
            InfoSection(
              title: 'Personal Information',
              icon: Icons.person_outline,
              primaryColor: primaryColor,
              children: [
                InfoTile(
                  icon: Icons.badge_outlined,
                  label: 'Full Name',
                  value: donorData?['name'] ?? 'N/A',

                ),
                InfoTile(
                  icon: Icons.cake_outlined,
                  label: 'Age',
                  value: donorData?['age']?.toString() ?? 'N/A',
                ),
                InfoTile(
                  icon: Icons.wc_outlined,
                  label: 'Gender',
                  value: donorData?['gender'] ?? 'N/A',

                ),
                InfoTile(
                  icon: Icons.credit_card_outlined,
                  label: 'ID Card',
                  value: donorData?['idCard']?.toString() ?? 'N/A',

                ),
              ],
            ),

            InfoSection(
              title: 'Donation Information',
              icon: Icons.bloodtype_outlined,
              primaryColor: primaryColor,
              children: [
                InfoTile(
                  icon: Icons.bloodtype,
                  label: 'Blood Type',
                  value: donorData?['bloodType'] ?? 'N/A',

                ),
                InfoTile(
                  icon: Icons.category_outlined,
                  label: 'Donation Type',
                  value: donorData?['donationType'] ?? 'N/A',

                ),
                InfoTile(
                  icon: Icons.water_drop_outlined,
                  label: 'Units',
                  value: donorData?['units']?.toString() ?? 'N/A',

                ),
                InfoTile(
                  icon: Icons.calendar_today_outlined,
                  label: 'Last Donation Date',
                  value: formatDate(donorData?['lastDonationDate']),

                ),
                InfoTile(
                  icon: Icons.event_outlined,
                  label: 'Next Donation Date',
                  value: formatDate(donorData?['nextDonationDate']),

                ),
                InfoTile(
                  icon: Icons.schedule_outlined,
                  label: 'Last Request Date',
                  value: formatDate(donorData?['lastRequestDate']),

                ),
              ],
            ),

// Contact Info Section
            InfoSection(
              title: 'Contact Information',
              icon: Icons.contact_phone_outlined,
              primaryColor: primaryColor,
              children: [
                InfoTile(
                  icon: Icons.phone_outlined,
                  label: 'Contact Number',
                  value: donorData?['contact']?.toString() ?? 'N/A',

                ),
                InfoTile(
                  icon: Icons.location_on_outlined,
                  label: 'Address',
                  value: donorData?['address'] ?? 'N/A',

                ),
                InfoTile(
                  icon: Icons.local_hospital_outlined,
                  label: 'Hospital Name',
                  value: donorData?['hospitalName'] ?? 'N/A',

                ),
                InfoTile(
                  icon: Icons.directions_outlined,
                  label: 'Distance',
                  value: donorData?['distance'] != null
                      ? '${donorData!['distance']} km'
                      : 'N/A',

                ),
              ],
            ),

            InfoSection(
              title: 'Medical Information',
              icon: Icons.medical_information_outlined,
              primaryColor: primaryColor,
              children: [
                InfoTile(
                  icon: Icons.health_and_safety_outlined,
                  label: 'Medical Conditions',
                  value: donorData?['medicalConditions'] ?? 'None',
                  isMultiline: true,

                ),
                InfoTile(
                  icon: Icons.notes_outlined,
                  label: 'Additional Notes',
                  value: donorData?['notes'] ?? 'None',
                  isMultiline: true,
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Widget _buildSection(String title, IconData icon, List<Widget> children) {
  //   return Container(
  //     margin: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.1),
  //           spreadRadius: 2,
  //           blurRadius: 8,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Row(
  //             children: [
  //               Icon(icon, color: primaryColor, size: 24),
  //               const SizedBox(width: 12),
  //               Text(
  //                 title,
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: primaryColor,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         const Divider(height: 1),
  //         ...children,
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildInfoTile(
  //     IconData icon,
  //     String label,
  //     String value, {
  //       bool isMultiline = false,
  //     }) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //     child: Row(
  //       crossAxisAlignment:
  //       isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(8),
  //           decoration: BoxDecoration(
  //             color: primaryColor.withOpacity(0.1),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: Icon(icon, color: primaryColor, size: 20),
  //         ),
  //         const SizedBox(width: 16),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 label,
  //                 style: TextStyle(
  //                   fontSize: 12,
  //                   color: Colors.grey[600],
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //               const SizedBox(height: 4),
  //               Text(
  //                 value,
  //                 style: const TextStyle(
  //                   fontSize: 16,
  //                   color: Colors.black87,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

