

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';


import '../../constant/local/local_variables.dart';
showSnackBar({
  required String message,
  required BuildContext context,
  required IconData? icon,
  required Color? color,
}) {
  final snackBar = AnimatedSnackBar(
    builder: ((context) {
      return Container(
        height: scrHeight * (0.09),
        decoration: BoxDecoration(
            color: color ?? const Color.fromRGBO(64, 23, 117, 1),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            SizedBox(
              width: scrWidth * (0.02),
            ),
            Icon(icon, size: scrHeight * (0.04), color: Colors.white),
            SizedBox(
              width: scrWidth * (0.01),
            ),
            Expanded(
              child: Text(
                message,
                style:
                TextStyle(color: Colors.white, fontSize: scrHeight * (0.02)),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: scrWidth * (0.01),
            ),
          ],
        ),
      );
    }),
    duration: const Duration(seconds: 5),
    desktopSnackBarPosition: DesktopSnackBarPosition.bottomCenter,
  );

  snackBar.show(context);
}
