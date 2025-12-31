String maskPhoneNumber(String phone) {
  if (phone.length <= 7) return phone;

  final int visibleLength = phone.length - 7;
  final String visiblePart = phone.substring(0, visibleLength);
  final String maskedPart = 'x' * 7;

  return '$visiblePart$maskedPart';
}
