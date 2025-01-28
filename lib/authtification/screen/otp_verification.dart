// lib/screens/otp_verification_screen.dart

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pinput/pinput.dart';

import '../../core/common/widgets/network_image.dart';
import '../../core/constant/assets_image_constant.dart';
import '../../core/constant/color_constants.dart';
import '../../core/constant/local/local_variables.dart';
import '../../home/screen.dart';
import '../controller/auth_controller.dart';



class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen(
      {super.key, required this.phone, required this.otp});
  final String otp;
  final String phone;
  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  TextEditingController otpController = TextEditingController();
  final timerSeconds = ValueNotifier(30);
  late AnimationController _animationController;
  late Animation _animation;
  Future otpTimer() async {
    while (timerSeconds.value > 0) {
      await Future.delayed(const Duration(seconds: 1));
      timerSeconds.value--;
    }
  }
  checkUser() {
    ref.read(authControllerProvider.notifier).checkUserData(
        phoneNumber: widget.phone,
        context: context,
        );
  }
  verifyOtp(String otp) {
    if (otp == widget.otp) {
      checkUser();
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     backgroundColor: Colors.green, content: Text("Otp verified")));


    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, content: Text("Wrong verified")));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    otpTimer();



    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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

          const Text(
            'OTP Verification',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Subtitle
          Text(
            'We Will send you a confirmation code\nto Mobile Number',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Phone Number Display
          Text(
            '${widget.phone}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // OTP Input Fields
          Pinput(
            controller: otpController,
            length: 6,
            defaultPinTheme: PinTheme(

              width: scrWidth * 0.12,
              height: scrHeight * 0.1,
              textStyle: TextStyle(
                fontSize: 20,
                color: ColorPalette
                    .black, // Change the text color to purple
                fontWeight: FontWeight.w600,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(scrWidth * 0.2),
                border: Border.all(
                    color: ColorPalette
                        .blueAccent), // Purple border color
              ),
            ),
            focusedPinTheme: PinTheme(
              width: scrWidth * 0.12,
              height: scrHeight * 0.06,
              textStyle: TextStyle(
                fontSize: scrWidth * 0.05,
                color: ColorPalette
                    .black, // Change the text color to purple
                fontWeight: FontWeight.w600,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(scrWidth * 0.2),
                border: Border.all(
                    color:
                        ColorPalette.orange), // Purple border color
              ),
            ),
            separatorBuilder: (index) =>
                SizedBox(width: scrWidth * 0.02),
            validator: (value) {

            },
            hapticFeedbackType: HapticFeedbackType.lightImpact,
            onCompleted: (pin) {
              debugPrint('onCompleted: $pin');
            },
            onChanged: (value) {
              debugPrint('onChanged: $value');
            },
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
            cursor: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 9),
                  width: 22,
                  height: 1,
                  color: Colors.white,
                ),
              ],
            ),
          ),



          // Resend Text
          ValueListenableBuilder(
              valueListenable: timerSeconds,
              builder: (context, _, __) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Didn\'t receive OTP? ',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (timerSeconds.value == 0) {
                          if (!widget.phone
                              .contains('917034350364')) {
                            await ref
                                .read(
                                    authControllerProvider.notifier)
                                .sendOTP(
                                    phoneNo: widget.phone,
                                    otp: widget.otp);
                          }
                          timerSeconds.value = 30;
                          otpTimer();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                                  backgroundColor: Colors.black,
                                  content: Center(
                                    child: Text(
                                      'OTP sent to your phone number successfully',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight:
                                              FontWeight.w500),
                                    ),
                                  )));
                        }
                      },
                      child: Text(
                        timerSeconds.value != 0
                            ? 'Resend in 00:${timerSeconds.value < 10 ? '0${timerSeconds.value}' : timerSeconds.value}'
                            : 'Resend OTP',
                        style: TextStyle(
                            color: ColorPalette.lateBlue
                                .withOpacity(timerSeconds.value != 0
                                    ? 0.6
                                    : 1),
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
              }),



          // Verify Button
          ElevatedButton(
            onPressed: () {
              verifyOtp(otpController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue[200],
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Verify',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}
