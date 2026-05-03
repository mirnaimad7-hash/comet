class AppExceptions implements Exception {
  final String message;
  final String prefix;

  AppExceptions([this.message = "حدث خطأ غير متوقع", this.prefix = ""]);

  @override
  String toString() {
    return "$prefix$message";
  }
}

// خطأ في الاتصال بالشبكة
class FetchDataException extends AppExceptions {
  FetchDataException([String? message])
    : super(message ?? "خطأ في الاتصال بالخادم", "خطأ شبكة: ");
}

// خطأ 400 يعني البيانات المرسلة غير صحيحة)
class BadRequestException extends AppExceptions {
  BadRequestException([String? message])
    : super(message ?? "طلب غير صالح", "طلب خاطئ: ");
}

// خطأ 401 أو 403  التوكن منتهي
class UnauthorizedException extends AppExceptions {
  UnauthorizedException([String? message])
    : super(message ?? "غير مصرح لك بالدخول", "جلسة منتهية: ");
}

// خطأ 404 المسار غير موجود
class NotFoundException extends AppExceptions {
  NotFoundException([String? message])
    : super(message ?? "المسار غير موجود", "غير موجود: ");
}

// خطأ 500 مشكلة في سيرفر Laravel/Next
class ServerException extends AppExceptions {
  ServerException([String? message])
    : super(message ?? "حدث خطأ في الخادم", "خطأ سيرفر: ");
}
