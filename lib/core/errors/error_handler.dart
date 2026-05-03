import 'package:dio/dio.dart';

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.response?.statusCode) {
        case 401:
          return "البريد الإلكتروني أو كلمة السر غير صحيحة";
        case 409:
          return "المستخدم موجود مسبقاً";
        case 500:
          return "خطأ في السيرفر، حاول لاحقاً";
        default:
          return "حدث خطأ غير متوقع";
      }
    }
    return "تأكد من اتصالك بالإنترنت";
  }
}
