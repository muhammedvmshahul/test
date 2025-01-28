// lib/screens/otp_screen.dart

import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


import '../../../core/common/widgets/toastification.dart';
import '../../core/common/widgets/network_image.dart';
import '../../core/constant/assets_image_constant.dart';
import '../../core/constant/color_constants.dart';
import '../../core/constant/local/local_variables.dart';
import '../controller/auth_controller.dart';
import 'otp_verification.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  String? phoneNumber;
  final formKey = GlobalKey<FormState>();
  String _generateOTP() {
    final random = math.Random();
    return (random.nextInt(900000) + 100000).toString();
  }
  late AnimationController _animationController;
  checkUser() {
    ref.read(authControllerProvider.notifier).checkUserDataDemo(
      phoneNumber: '+918848271266',
      context: context,
    );
  }
  sendotp(String phoneNumber) {
    print(phoneNumber);

    ///remove +
    final sanitizedPhoneNumber = phoneNumber.replaceAll('+', '');
    if (sanitizedPhoneNumber == '917034350364') {
      Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => OtpVerificationScreen(
              otp: '000000',
              phone: phoneNumber,
            ),
          ));
    } else {
      ///genets
      final otp = _generateOTP();
      log(otp);
      ref
          .read(authControllerProvider.notifier)
          .sendOTP(otp: otp, phoneNo: sanitizedPhoneNumber)
          .then((value) {
        print("Response: $value");

        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => OtpVerificationScreen(
                otp: otp,
                phone: phoneNumber,
              ),
            ));
      }).catchError((err) {
        print("Err Response: $err");
      });
    }
  }

  TextEditingController phone = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo and Icons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    cachedNetworkCustomImage(AssetConst.logo2, height: 55),
                    cachedNetworkCustomImage(
                      AssetConst.onbody_logo,
                      height: 85,
                    ),
                  ],
                ),

                const SizedBox(height: 40),
                SizedBox(

                  child: Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [


                          const SizedBox(height: 32),

                          // Title
                          Text(
                            'Enter Your Mobile Number',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 8),

                          // Subtitle
                          Text(
                            'We Will send you a confirmation code',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: ColorPalette.black,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 32),

                          // Phone Number Input
                          Form(
                            key: formKey,
                            child: Padding(
                              padding: EdgeInsets.all(scrWidth * 0.03),
                              child: IntlPhoneField(
                                controller: phone,
                                validator: (val) {
                                  if (val == null || val.number.isEmpty) {
                                    return 'Invalid Mobile Number';
                                  }
                                  return null;
                                },
                                pickerDialogStyle: PickerDialogStyle(
                                  backgroundColor: Colors.white,
                                  countryCodeStyle: GoogleFonts.montserrat(
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w600),
                                  countryNameStyle: GoogleFonts.montserrat(
                                    color: Colors.black,
                                  ),
                                  listTileDivider: const SizedBox(),
                                  searchFieldInputDecoration: InputDecoration(
                                    labelText: 'Search country',
                                    suffixIcon:
                                    const Icon(CupertinoIcons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Rounded corners
                                      borderSide: BorderSide(
                                        color: ColorPalette.primary
                                            .withOpacity(0.5), // / Border color
                                        width: 2.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: ColorPalette.primary.withOpacity(
                                            0.5), // Border color when focused
                                        width: 2.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                        color: Colors
                                            .grey, // Border color when not focused
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onSubmitted: (p0) {},
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Rounded corners
                                    borderSide: BorderSide(
                                      color: ColorPalette.primary
                                          .withOpacity(0.5), // / Border color
                                      width: 2.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: ColorPalette.primary.withOpacity(
                                          0.5), // Border color when focused
                                      width: 2.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Colors
                                          .grey, // Border color when not focused
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                flagsButtonPadding: const EdgeInsets.all(10),
                                dropdownTextStyle: GoogleFonts.montserrat(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w600),
                                initialCountryCode: 'IN',
                                onChanged: (phone) {
                                  try {
                                    phoneNumber = phone.completeNumber;
                                    print(phoneNumber);
                                    setState(() {});
                                  } catch (e) {}
                                },
                                dropdownIconPosition: IconPosition.trailing,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 15,
                          ),

                          // Verify Button
                          ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                if (phoneNumber == null) {
                                  toastificationErrorWidget(
                                      context, "Enter Your Phone Number");
                                } else if (phoneNumber!.length < 10) {
                                  toastificationErrorWidget(
                                      context, "Enter Your Phone Number");
                                } else {
                                  await sendotp(phoneNumber.toString());
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPalette.lateBlue,
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Send OTP',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: scrHeight * 0.02,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              checkUser();
                            },
                            child: Text("Demo"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPalette.lateBlue,
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
                // Welcome Back Image
              ],
            ),
          ),
        ),
      ),
    );
  }
}
