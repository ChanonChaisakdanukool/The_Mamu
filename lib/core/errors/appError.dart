/// ประเภทของ Error ที่ใช้ map แล้วใช้งานใน UI / logic ได้
enum AppErrorType {
  unknown,
  serviceOffline,
  networkOffline,
  validation,
  unauthorized,
  timeout,
}

/// ตัวช่วยจัดการ Error ในแอป
///
/// ใช้สำหรับเก็บข้อมูล error ที่ชัดเจนและง่ายต่อการส่งต่อใน UI / log / network
class AppError {
  final String message;
  final String? code;
  final AppErrorType type;
  final Object? exception;
  final StackTrace? stackTrace;

  const AppError({
    required this.message,
    this.code,
    this.type = AppErrorType.unknown,
    this.exception,
    this.stackTrace,
  });

  /// ให้อ่านค่าได้ง่ายขึ้น เช่น ส่งไปแสดงบน Snackbar
  @override
  String toString() {
    final codeText = code != null ? ' ($code)' : '';
    return 'AppError: $message$codeText';
  }

  /// แปลงจาก Exception ที่เกิดขึ้นเป็น AppError
  factory AppError.fromException(
    Object exception, {
    StackTrace? stackTrace,
    String? code,
    AppErrorType type = AppErrorType.unknown,
  }) {
    const defaultMessage = 'เกิดข้อผิดพลาดภายในระบบ';

    String message;
    AppErrorType resolvedType = type;

    if (exception is FormatException) {
      message = exception.message;
      resolvedType = AppErrorType.validation;
    } else if (exception is ArgumentError) {
      message = exception.message ?? defaultMessage;
      resolvedType = AppErrorType.validation;
    } else if (exception is StateError) {
      message = exception.message;
    } else {
      final text = exception.toString().toLowerCase();
      if (text.contains('offline') || text.contains('not connected')) {
        resolvedType = AppErrorType.networkOffline;
      } else if (text.contains('service unavailable') || text.contains('503')) {
        resolvedType = AppErrorType.serviceOffline;
      }
      message = exception.toString();
    }

    return AppError(
      message: message.isNotEmpty ? message : defaultMessage,
      code: code,
      type: resolvedType,
      exception: exception,
      stackTrace: stackTrace,
    );
  }

  /// แปลงจากข้อความธรรมดาเป็น AppError
  factory AppError.fromMessage(
    String message, {
    String? code,
    AppErrorType type = AppErrorType.unknown,
  }) {
    return AppError(message: message, code: code, type: type);
  }

  /// แปลงจากรหัสโค้ดเป็น AppErrorType (ถ้าใช้ map case)
  static AppErrorType typeFromCode(String? code) {
    switch (code) {
      case 'SERVICE_OFFLINE':
        return AppErrorType.serviceOffline;
      case 'NETWORK_OFFLINE':
        return AppErrorType.networkOffline;
      case 'UNAUTHORIZED':
        return AppErrorType.unauthorized;
      case 'TIMEOUT':
        return AppErrorType.timeout;
      default:
        return AppErrorType.unknown;
    }
  }
}
