/// Infer card brand from the first digits of the card number.
String inferCardBrand(String cardNumber) {
  final digits = cardNumber.replaceAll(RegExp(r'\s'), '');
  if (digits.isEmpty) return 'OTHER';

  if (digits.startsWith('4')) return 'VISA';
  if (digits.startsWith('34') || digits.startsWith('37')) return 'AMEX';
  if (digits.startsWith('6011') ||
      digits.startsWith('65') ||
      digits.startsWith('644') ||
      digits.startsWith('645') ||
      digits.startsWith('646') ||
      digits.startsWith('647') ||
      digits.startsWith('648') ||
      digits.startsWith('649')) {
    return 'DISCOVER';
  }
  final firstTwo = int.tryParse(digits.substring(0, digits.length >= 2 ? 2 : digits.length));
  if (firstTwo != null && firstTwo >= 51 && firstTwo <= 55) return 'MC';
  // Mastercard 2-series
  if (digits.length >= 4) {
    final first4 = int.tryParse(digits.substring(0, 4));
    if (first4 != null && first4 >= 2221 && first4 <= 2720) return 'MC';
  }

  return 'OTHER';
}

/// Extract last 4 digits from a card number string.
String getLast4(String cardNumber) {
  final digits = cardNumber.replaceAll(RegExp(r'\s'), '');
  if (digits.length < 4) return digits;
  return digits.substring(digits.length - 4);
}

/// Format masked card display: BRAND •••• LAST4
String maskedCardDisplay(String brand, String last4) {
  return '$brand •••• $last4';
}
