import 'package:firebase_analytics/firebase_analytics.dart';

abstract class AnalyticsService {
  /// Kullanıcı giriş olayını loglar.
  Future<void> logLogin({String? loginMethod});

  /// Kullanıcı kayıt olayını loglar.
  Future<void> logSignUp({required String signUpMethod});

  /// Özel bir analitik olayını loglar.
  Future<void> logCustomEvent({
    required String name,
    Map<String, Object>? parameters,
  });

  /// Oturumdaki kullanıcı için bir kimlik belirler.
  Future<void> setUserId({required String? id});
}

class AnalyticsServiceImpl implements AnalyticsService {
  final FirebaseAnalytics _analytics;

  AnalyticsServiceImpl(this._analytics);

  @override
  Future<void> logLogin({String? loginMethod}) async {
    final parameters = <String, Object>{};
    if (loginMethod != null) {
      parameters['login_method'] = loginMethod;
    }
    await _analytics.logEvent(name: 'login', parameters: parameters);
  }

  @override
  Future<void> logSignUp({required String signUpMethod}) async {
    await _analytics.logEvent(
      name: 'sign_up',
      parameters: {'sign_up_method': signUpMethod},
    );
  }

  @override
  Future<void> logCustomEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> setUserId({required String? id}) async {
    await _analytics.setUserId(id: id);
  }
}
