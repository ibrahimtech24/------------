import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import '../services/app_localizations.dart';

/// Helper class for showing beautiful snackbar notifications
class AppSnackbar {
  /// Show a success notification
  static void success(BuildContext context, String message) {
    _show(context, message, ContentType.success);
  }

  /// Show an error notification
  static void error(BuildContext context, String message) {
    _show(context, message, ContentType.failure);
  }

  /// Show an info / delete notification
  static void deleted(BuildContext context, String message) {
    _show(context, message, ContentType.failure);
  }

  /// Show a warning notification
  static void warning(BuildContext context, String message) {
    _show(context, message, ContentType.warning);
  }

  /// Show an info notification
  static void info(BuildContext context, String message) {
    _show(context, message, ContentType.help);
  }

  static void _show(BuildContext context, String message, ContentType type) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      content: Directionality(
        textDirection: Directionality.of(context),
        child: AwesomeSnackbarContent(
          title: _title(context, type),
          message: message,
          contentType: type,
        ),
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static String _title(BuildContext context, ContentType type) {
    if (type == ContentType.success) return S.of(context, 'success');
    if (type == ContentType.failure) return S.of(context, 'error');
    if (type == ContentType.warning) return S.of(context, 'warning');
    return S.of(context, 'info');
  }
}
