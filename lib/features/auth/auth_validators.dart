String? validateEmail(String? v) {
  if (v == null || v.trim().isEmpty) return 'Email is required';
  final regex = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$");
  if (!regex.hasMatch(v.trim())) return 'Enter a valid email';
  return null;
}

String? validatePassword(String? v) {
  if (v == null || v.trim().isEmpty) return 'Password is required';
  if (v.trim().length < 6) return 'Password must be at least 6 characters';
  return null;
}
String? validateConfirmPassword(String? password, String? confirmPassword) {
  if (confirmPassword == null || confirmPassword.trim().isEmpty) {
    return 'Please confirm your password';
  }
  if (password != confirmPassword) {
    return 'Passwords do not match';
  }
  return null;
}