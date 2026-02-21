// Input validators for the registration form.

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email is required';
  }
  final emailRegex = RegExp(r'^[\w\.\+\-]+@[\w\-]+\.[\w\-\.]+$');
  if (!emailRegex.hasMatch(value.trim())) {
    return 'Enter a valid email address';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}

String? validateCardNumber(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Card number is required';
  }
  final digitsOnly = value.replaceAll(RegExp(r'\s'), '');
  if (!RegExp(r'^\d+$').hasMatch(digitsOnly)) {
    return 'Card number must contain only digits';
  }
  if (digitsOnly.length < 15 || digitsOnly.length > 16) {
    return 'Card number must be 15-16 digits';
  }
  return null;
}

String? validateExpiry(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Expiry is required';
  }
  final regex = RegExp(r'^(0[1-9]|1[0-2])\/(\d{2})$');
  final match = regex.firstMatch(value.trim());
  if (match == null) {
    return 'Enter expiry as MM/YY';
  }
  final month = int.parse(match.group(1)!);
  final year = int.parse(match.group(2)!) + 2000;
  final now = DateTime.now();
  final expiryDate = DateTime(year, month + 1, 0); // last day of month
  if (expiryDate.isBefore(now)) {
    return 'Card is expired';
  }
  return null;
}

String? validateCvv(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'CVV is required';
  }
  if (!RegExp(r'^\d{3,4}$').hasMatch(value.trim())) {
    return 'CVV must be 3-4 digits';
  }
  return null;
}
