import 'package:get/get.dart';
import 'package:ride_sharing_user_app/helper/display_helper.dart';

/// Helper class for input validation and sanitization
class InputValidationHelper {
  
  /// Validates phone number format
  static bool isValidPhoneNumber(String phoneNumber) {
    final phoneRegex = RegExp(r'^\d{7,15}$');
    return phoneRegex.hasMatch(phoneNumber.replaceAll(RegExp(r'\D'), ''));
  }

  /// Validates email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validates password strength
  static bool isValidPassword(String password) {
    // Minimum 8 characters, at least one letter and one number
    final passwordRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  /// Sanitizes string input to prevent injection attacks
  static String sanitizeInput(String input) {
    // Remove potentially dangerous characters
    return input
        .replaceAll(RegExp('[<>"\'\\\\/:;]'), '')
        .replaceAll(RegExp('\\s+'), ' ')
        .trim();
  }

  /// Validates address input
  static bool isValidAddress(String address) {
    return address.length >= 5 && address.length <= 255;
  }

  /// Validates latitude and longitude
  static bool isValidCoordinates(double latitude, double longitude) {
    return latitude >= -90 && latitude <= 90 && longitude >= -180 && longitude <= 180;
  }

  /// Validates amount (fare, balance, etc.)
  static bool isValidAmount(double amount) {
    return amount > 0 && amount < 1000000; // Reasonable upper limit
  }

  /// Validates trip ID format
  static bool isValidTripId(String tripId) {
    return tripId.isNotEmpty && tripId.length > 5;
  }

  /// Safe string parsing with fallback
  static String? safeStringFromJson(dynamic value) {
    try {
      if (value == null) return null;
      return value.toString().trim();
    } catch (e) {
      return null;
    }
  }

  /// Safe double parsing with fallback
  static double safeDoubleFromJson(dynamic value, {double defaultValue = 0.0}) {
    try {
      if (value == null) return defaultValue;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      return double.parse(value.toString());
    } catch (e) {
      return defaultValue;
    }
  }

  /// Safe int parsing with fallback
  static int safeIntFromJson(dynamic value, {int defaultValue = 0}) {
    try {
      if (value == null) return defaultValue;
      if (value is int) return value;
      return int.parse(value.toString());
    } catch (e) {
      return defaultValue;
    }
  }

  /// Validates and shows error for required fields
  static bool validateRequiredField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      showCustomSnackBar('$fieldName is required'.tr, isError: true);
      return false;
    }
    return true;
  }

  /// Validates phone number with user feedback
  static bool validatePhoneNumberWithFeedback(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      showCustomSnackBar('phone_is_required'.tr, isError: true);
      return false;
    }
    if (!isValidPhoneNumber(phoneNumber)) {
      showCustomSnackBar('invalid_phone_format'.tr, isError: true);
      return false;
    }
    return true;
  }

  /// Validates email with user feedback
  static bool validateEmailWithFeedback(String email) {
    if (email.isEmpty) {
      showCustomSnackBar('email_is_required'.tr, isError: true);
      return false;
    }
    if (!isValidEmail(email)) {
      showCustomSnackBar('invalid_email_format'.tr, isError: true);
      return false;
    }
    return true;
  }

  /// Validates password with user feedback
  static bool validatePasswordWithFeedback(String password) {
    if (password.isEmpty) {
      showCustomSnackBar('password_is_required'.tr, isError: true);
      return false;
    }
    if (password.length < 8) {
      showCustomSnackBar('password_must_be_at_least_8_characters'.tr, isError: true);
      return false;
    }
    return true;
  }
}
