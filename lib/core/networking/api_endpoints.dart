class ApiEndpoints {
  static const String baseUrl = "http://10.2.0.2:8000";
  // static const String baseUrl = "http://localhost:8000";

  static const String signin = "/auth/signin";
  static const String signup = "/auth/signup";
  static const String signout = "/auth/signout";
  static const refresh = "/auth/refresh";
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';
}
