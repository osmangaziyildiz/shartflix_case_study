import 'package:firebase_crashlytics/firebase_crashlytics.dart';

abstract class LoggerService {
  Future<void> recordError({
    required dynamic exception,
    StackTrace? stackTrace,
    String? reason,
    bool fatal = false,
  });

  Future<void> setUserIdentifier(String identifier);
}

class LoggerServiceImpl implements LoggerService {
  final FirebaseCrashlytics _crashlytics;

  LoggerServiceImpl(this._crashlytics);

  @override
  Future<void> recordError({
    required dynamic exception,
    StackTrace? stackTrace,
    String? reason,
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(
      exception,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }

  @override
  Future<void> setUserIdentifier(String identifier) async {
    await _crashlytics.setUserIdentifier(identifier);
  }
}
