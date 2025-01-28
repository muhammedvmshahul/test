import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget cachedNetworkCustomImage(String path,
    {double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
    double scale = 1}) {
  return CachedNetworkImage(
    imageUrl: path,
    height: height,
    fadeInDuration: const Duration(milliseconds: 10),
    width: width,
    fit: fit,
    scale: scale,
  );
}
