import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

toastificationErrorWidget(BuildContext context, String text) {
  return toastification.show(
    context: context,
    title: Text(text),
    // .... Other parameters
    animationDuration: const Duration(milliseconds: 300),
    dragToClose: true,
    icon: const Icon(
      Icons.error_outline_sharp,
      color: Colors.red,
    ),
    autoCloseDuration: const Duration(seconds: 3),
    style: ToastificationStyle.flat,
    alignment: Alignment.bottomCenter,
  );
}
