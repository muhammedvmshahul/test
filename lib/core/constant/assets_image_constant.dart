import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AssetConst {
  // URL base constants
  static const _imagesBaseUrl =
      "https://firebasestorage.googleapis.com/v0/b/litlab-319ec.appspot.com/o/_assets%2Fimages%2F";
  static const _animationsBaseUrl =
      "https://firebasestorage.googleapis.com/v0/b/litlab-319ec.appspot.com/o/_assets%2Fanimations%2F";
  static const _mediaSuffix = '?alt=media';

  ///lottie
  static const comingSoon = "${_animationsBaseUrl}coming_soon.json";
  static const successLottie = "${_animationsBaseUrl}success.json";
  static const notification = "assets/icons/notification.svg";
  static const menu = "assets/icons/menu.svg";

  ///icons
  static const note = "assets/icons/note.svg";
  static const model_question_paper_icon = "assets/icons/model.svg";
  static const sample_question_paper_icon = "assets/icons/sample_question.svg";
  static const material_icon = "assets/icons/material_icon.svg";
  static const weeklyChallengeIcon = "assets/icons/challenge.svg";
  static const specialExamIcon = "assets/icons/exam.svg";
  static const assessmentTestIcon = "assets/icons/assessment.svg";
  static const targetIcon = "assets/icons/target.svg";
  static const timeIcon = "assets/icons/time.svg";
  static const downloadIcon = "assets/icons/download_icon.svg";
  static const moduleIcon = "assets/icons/module.svg";
  static const likeIcon = "assets/icons/like.svg";
  static const dislikeIcon = "assets/icons/dislike.svg";

  ///images
  static const logo = "${_imagesBaseUrl}Logo.png$_mediaSuffix";
  static const logo2 = "${_imagesBaseUrl}main_logo.png$_mediaSuffix";
  static const onbody_logo = "${_imagesBaseUrl}onbody_logo.png$_mediaSuffix";
  static const assessmentLogo = "${_imagesBaseUrl}assessment.png$_mediaSuffix";
  static const welcome_image =
      "${_imagesBaseUrl}welcome_image.png$_mediaSuffix";
  static const paper_image = "${_imagesBaseUrl}paper_image.png$_mediaSuffix";
  static const welcome_loadind =
      "${_imagesBaseUrl}welcome_loadind.gif$_mediaSuffix";
  static const book = "${_imagesBaseUrl}book.png$_mediaSuffix";

  static const commonPaper = "assets/images/common.svg";
  static const selectCommonPaper = "assets/images/note_icon.svg";
  static const malayalam = "assets/images/malayalam.svg";
  static const history = "assets/images/history.svg";
  static const sociology = "assets/images/sociolagy.svg";
  static const economic = "assets/images/economics.svg";
  static const backgroundCommon =
      "${_imagesBaseUrl}background_image_common.png$_mediaSuffix";
  static const backgroundCommonAuth =
      "${_imagesBaseUrl}background_auth.png$_mediaSuffix";
  static const coreIcon = "assets/images/core_icon.svg";

  static const silverIcon = '${_imagesBaseUrl}silver.png$_mediaSuffix';
  static const goldIcon = '${_imagesBaseUrl}gold.png$_mediaSuffix';
  static const diamondIcon = '${_imagesBaseUrl}diamond.png$_mediaSuffix';

  static const onboady2 = '${_animationsBaseUrl}onboady2.json$_mediaSuffix';
  static const Animation1 = '${_animationsBaseUrl}Animation1.json$_mediaSuffix';
  static const animation3 = '${_animationsBaseUrl}animation3.json$_mediaSuffix';

  static final List<String> networkImageUrls = [
    welcome_loadind,
    welcome_image,
    onboady2,
    Animation1,
    animation3,
    logo,
    logo2,
    paper_image,
    onbody_logo,
    assessmentLogo,
    book,
    silverIcon,
    goldIcon,
    diamondIcon,
  ];

  static Future preloadNetworkImages(BuildContext context) async {
    for (var url in networkImageUrls) {
      await precacheImage(NetworkImage(url), context);
    }
  }
}
