import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/feature/home/domain/entities/needer_request_entity.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RequestForNeederListViewItem extends StatelessWidget {
  const RequestForNeederListViewItem({super.key, required this.request});

  final NeederRequestEntity request;

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
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.person, color: Colors.white),
          ),
          title: Text(
            request.patientName.isNotEmpty
                ? request.patientName
                : 'no_name'.tr(context),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          subtitle: Row(
            children: [
              const Icon(Icons.local_hospital, size: 16, color: Colors.grey),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * .4,
                child: Text(
                  request.hospitalName.isNotEmpty
                      ? request.hospitalName
                      : 'unknown_hospital'.tr(context),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    Assets.imagesBlooddrop,
                    height: 35,
                  ),
                  Text(
                    request.bloodType.tr(context),
                    style: TextStyles.semiBold11.copyWith(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
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
