import 'package:flutter/material.dart';

class TestDialogUtils {
  static bool loadingShown = false;
  static bool loadingRemoved = false;
  static bool messageShown = false;
  static String? shownMessage;
  static String? shownTitle;
  static String? shownPosActionName;
  static String? shownNegActionName;
  static VoidCallback? posActionCallback;
  static VoidCallback? negActionCallback;

  static void reset() {
    loadingShown = false;
    loadingRemoved = false;
    messageShown = false;
    shownMessage = null;
    shownTitle = null;
    shownPosActionName = null;
    shownNegActionName = null;
    posActionCallback = null;
    negActionCallback = null;
  }

  static void showLoading({
    required BuildContext context,
    required String loadingText,
  }) {
    loadingShown = true;
  }

  static void removeLoading({required BuildContext context}) {
    loadingRemoved = true;
  }

  static void showMessage({
    required BuildContext context,
    String? title,
    required String message,
    String? posActionName,
    Function? posAction,
    String? negActionName,
    Function? negAction,
  }) {
    messageShown = true;
    shownMessage = message;
    shownTitle = title;
    shownPosActionName = posActionName;
    shownNegActionName = negActionName;
    posActionCallback = posAction as VoidCallback?;
    negActionCallback = negAction as VoidCallback?;
  }
}
