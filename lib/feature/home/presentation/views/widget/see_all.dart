import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/utils/page_rout_builder.dart';
import 'package:blood_bank/core/widget/coustom_circular_progress_indicator.dart';
import 'package:blood_bank/core/widget/coustom_dialog.dart';
import 'package:blood_bank/feature/home/presentation/views/donor_details.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SeeAllScreen extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> requests;
  final AsyncSnapshot<dynamic> snapshot;

  const SeeAllScreen({
    super.key,
    required this.requests,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Requests', style: TextStyles.semiBold16),
        backgroundColor: const Color(0xff800000),
        foregroundColor: Colors.white,
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CustomCircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return Center(
        child: CustomDialog(
          title: 'error_occurred'.tr(context),
          content: 'error_occurred: ${snapshot.error}'.tr(context),
        ),
      );
    }

    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index].data();
        return ListTile(
          leading: _buildUserAvatar(context, request['uId']),
          title: Text(request['name'] ?? 'No Name'),
          subtitle: _buildSubtitle(request, context),
          trailing: _buildTrailing(request, context),
          onTap: () {
            Navigator.of(context).push(
              buildPageRoute(
                  DonorProfileScreen(uId: request['uId'])
              ),
            );

          },
        );

      },
    );
  }

  Widget _buildUserAvatar(BuildContext context, String userId) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 50,
            height: 50,
            child: Center(child: CustomCircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          );
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final photoUrl = userData['photoUrl'];

        return CircleAvatar(
          radius: 25,
          backgroundImage: photoUrl != null && photoUrl.isNotEmpty
              ? NetworkImage(photoUrl)
              : null,
          backgroundColor: Colors.grey,
          child: photoUrl == null || photoUrl.isEmpty
              ? const Icon(Icons.person, color: Colors.white)
              : null,
        );
      },
    );
  }

  Widget _buildSubtitle(Map<String, dynamic> request, BuildContext context) {
    return Text(
      '${'blood_types'.tr(context)}: ${request['bloodType'].toString().tr(context)}',
    );
  }

  Widget _buildTrailing(Map<String, dynamic> request, BuildContext context) {
    return Text('${request['distance'] ?? '0'} ${'km'.tr(context)}');
  }
}

