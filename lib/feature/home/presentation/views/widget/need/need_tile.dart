
import 'package:blood_bank/core/helper_function/validators_textform.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/widget/coustom_aleart_diloage.dart';
import 'package:blood_bank/core/widget/custom_request_text_field.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/need/need_details_screen.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NeedTile extends StatelessWidget {
  final String neederId;
  final Map<String, dynamic> data;

  const NeedTile({
    super.key,
    required this.neederId,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(data['patientName'] ?? 'no_name'.tr(context)),
      subtitle: Text(
        '${'hospital'.tr(context)}: ${data['hospitalName'] ?? 'no_hospital'.tr(context)}\n'
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Edit button
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: AppColors.primaryColorB,
            ),
            onPressed: () => _editNeeder(context, neederId, data),
          ),
          // Delete button
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: AppColors.backgroundColor,
            ),
            onPressed: () => _deleteNeeder(context, neederId),
          ),
        ],
      ),
      onTap: () {
        _handleNeederTap(context, neederId, data);
      },
    );
  }

  void _handleNeederTap(
      BuildContext context, String neederId, Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NeedDetailsScreen(needData: data),
      ),
    );
  }

  void _editNeeder(
      BuildContext context, String neederId, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) {
        final patientController =
        TextEditingController(text: data['patientName']);
        final hospitalController =
        TextEditingController(text: data['hospitalName']);
        final bloodTypeController =
        TextEditingController(text: data['bloodType']);
        final formKey = GlobalKey<FormState>();
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'edit_request'.tr(context),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColorB,
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'edit_request_data'.tr(context),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.backgroundColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomRequestTextField(
                        controller: patientController,
                        hintText: 'patientName'.tr(context),
                        validator: (value) =>
                            Validators.validateName(value, context),
                      ),
                      const SizedBox(height: 20),
                      CustomRequestTextField(
                        controller: hospitalController,
                        hintText: 'hospitalName'.tr(context),
                        validator: (value) =>
                            Validators.validateHospitalName(value, context),
                      ),
                      const SizedBox(height: 20),
                      CustomRequestTextField(
                        controller: bloodTypeController,
                        hintText: 'bloodType'.tr(context),

                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('cancel'.tr(context),
                      style: const TextStyle(color: Colors.black)),
                ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                    if (formKey.currentState!.validate()) {
                      setState(() => isLoading = true);

                      await FirebaseFirestore.instance
                          .collection('neederRequest')
                          .doc(neederId)
                          .update({
                        'patientName': patientController.text,
                        'hospitalName': hospitalController.text,
                        'bloodType': bloodTypeController.text,
                      });

                      setState(() => isLoading = false);
                      Navigator.pop(context);
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(strokeWidth: 2)
                      : Text('Save'.tr(context),
                      style: const TextStyle(
                          color: AppColors.primaryColor, fontSize: 16)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Delete needer request
  Future<void> _deleteNeeder(
      BuildContext context, String neederId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          title: 'delete_request'.tr(context),
          content: 'confirm_delete_request'.tr(context),
          confirmText: 'delete'.tr(context),
          cancelText: 'cancel'.tr(context),
          onConfirm: () => Navigator.pop(context, true),
          onCancel: () => Navigator.pop(context, false),
        );
      },
    );

    if (confirmed == true) {
      await FirebaseFirestore.instance
          .collection('neederRequest')
          .doc(neederId)
          .delete();
    }
  }
}

