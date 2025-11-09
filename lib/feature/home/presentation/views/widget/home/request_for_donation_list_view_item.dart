import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/core/widget/coustom_circular_progress_indicator.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RequestForDonationListViewItem extends StatelessWidget {
  const RequestForDonationListViewItem({super.key, this.request});
  final request;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 5,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ListTile(
          leading: SizedBox(
            width: 50,
            height: 50,
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(request['uId'])
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CustomCircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text('error: ${snapshot.error}'.tr(context)));
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return CircleAvatar(
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
                      ? Icon(Icons.person, color: Colors.white)
                      : null,
                );
              },
            ),
          ),
          title: Text(
            request['name'] ?? 'no_name'.tr(context),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              Text(
                request['hospitalName'] ?? 'unknown_hospital'.tr(context),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        Assets.imagesBlooddrop,
                        height: 35,
                      ),
                      Text(
                        request['bloodType'].toString().tr(context),
                        style: TextStyles.semiBold11.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 10,
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                    decoration: BoxDecoration(
                        color: const Color(0xff598158),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      '${request['distance'] ?? '0'} ${'km'.tr(context)}',
                      style: TextStyles.semiBold12.copyWith(
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
