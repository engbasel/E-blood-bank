import 'package:blood_bank/feature/home/presentation/views/widget/home/blood_needed.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/custom_card_items.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/donor_carousel.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/requestes_for_donation.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/user_handler.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
  //   return Directionality(
  //     textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
  //     child: Scaffold(
  //       backgroundColor: Colors.white,
  //       body: Column(
  //         children: [
  //           SizedBox(
  //             height: 290,
  //             child: Stack(
  //               children: [
  //                 const UserHandler(),
  //                 const Positioned(
  //                   top: 115,
  //                   left: 0,
  //                   right: -20,
  //                   child: DonorCarousel(),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Expanded(
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 children: [
  //                   CustomCardItems(),
  //                   SizedBox(height: 20),
  //                   BloodNeededWidget(),
  //                   SizedBox(height: 20),
  //                   RequestsForDonation(),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 290,
                child: Stack(
                  children: [
                    const UserHandler(),
                    const Positioned(
                      top: 115,
                      left: 0,
                      right: -20,
                      child: DonorCarousel(),
                    ),
                  ],
                ),
              ),
              CustomCardItems(),
              const SizedBox(height: 20),
              BloodNeededWidget(),
              const SizedBox(height: 20),
              RequestsForDonation(),
            ],
          ),
        ),
      ),
    );
  }

}
