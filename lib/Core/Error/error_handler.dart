import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Core/Error/failure.dart';

class ErrorHandler {
  ErrorHandler._();

  static Failure handleError(Object error) {
    if (error is DioException) {
      return _handleDio(error);
    }
    if (error is FirebaseAuthException) {
      return _handleFirebaseAuthException(error);
    }

    return ServerFailure(AppText.unExpectedError);
  }

  static Failure _handleDio(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(AppText.connectionTimeOut);

      case DioExceptionType.sendTimeout:
        return ServerFailure(AppText.sendTimeOut);

      case DioExceptionType.receiveTimeout:
        return ServerFailure(AppText.receiveTimeOut);

      case DioExceptionType.badCertificate:
        return ServerFailure(AppText.receiveTimeOut);

      case DioExceptionType.badResponse:
        return ServerFailure(
          _handleStatusCode(exception.response?.statusCode),
        );

      case DioExceptionType.cancel:
        return ServerFailure(AppText.cancel);

      case DioExceptionType.connectionError:
        return ServerFailure(AppText.connectionError);

      default:
        return ServerFailure(AppText.unExpectedError);
    }
  }

  static String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return AppText.badRequest;
      case 401:
        return AppText.unauthorized;
      case 403:
        return AppText.forbidden;
      case 404:
        return AppText.notFound;
      case 500:
        return AppText.internalServerError;
      default:
        return AppText.somethingWentWrong;
    }
  }

  static Failure _handleFirebaseAuthException(FirebaseAuthException e) {
    print(e.code);

    switch (e.code) {
      case 'invalid-phone-number':
        return ServerFailure(AppText.invalidPhoneNumber);

      case 'invalid-credential':
        return ServerFailure(AppText.invalidLogin);

      case 'user-not-found':
        return ServerFailure(AppText.userNotFound);

      case 'wrong-password':
        return ServerFailure(AppText.wrongPassword);

      case 'email-already-in-use':
        return ServerFailure(AppText.emailAlreadyExists);

      case 'weak-password':
        return ServerFailure(AppText.weakPassword);

      case 'invalid-verification-code':
        return ServerFailure(AppText.invalidOtpCode);

      case 'session-expired':
        return ServerFailure(AppText.otpExpired);

      case 'too-many-requests':
        return ServerFailure(AppText.tooManyAttemptsTryLater);

      case 'network-request-failed':
        return ServerFailure(AppText.networkErrorShort);

      default:
        return ServerFailure(AppText.somethingWentWrong);
    }
  }
}
