import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:logging/logging.dart';

/// Service để quản lý Facebook SDK và tracking events
class FacebookService {
  static final Logger _logger = Logger('FacebookService');
  static FacebookService? _instance;
  static FacebookService get instance => _instance ??= FacebookService._();

  FacebookService._();

  late FacebookAppEvents _facebookAppEvents;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Khởi tạo Facebook SDK
  Future<void> initialize() async {
    try {
      _logger.info('Initializing Facebook SDK...');

      _facebookAppEvents = FacebookAppEvents();

      // Set advertiser tracking enabled (for iOS 14.5+)
      await _facebookAppEvents.setAdvertiserTracking(enabled: true);

      // Set auto log app events
      await _facebookAppEvents.setAutoLogAppEventsEnabled(true);

      _isInitialized = true;
      _logger.info('Facebook SDK initialized successfully');

      // Log app activation
      await logAppActivation();
    } catch (e) {
      _logger.severe('Failed to initialize Facebook SDK: $e');
      _isInitialized = false;
    }
  }

  /// Log app activation event
  Future<void> logAppActivation() async {
    if (!_isInitialized) {
      _logger.warning('Facebook SDK not initialized');
      return;
    }

    try {
      await _facebookAppEvents.logEvent(
        name: 'fb_mobile_activate_app',
        parameters: {
          'fb_mobile_launch_source': 'Organic',
        },
      );
      _logger.info('App activation logged to Facebook');
    } catch (e) {
      _logger.warning('Failed to log app activation: $e');
    }
  }

  /// Log app install event (call once after first install)
  Future<void> logAppInstall() async {
    if (!_isInitialized) {
      _logger.warning('Facebook SDK not initialized');
      return;
    }

    try {
      await _facebookAppEvents.logEvent(
        name: 'fb_mobile_first_time_open',
        parameters: {
          'fb_mobile_app_install_time':
              DateTime.now().millisecondsSinceEpoch.toString(),
        },
      );
      _logger.info('App install logged to Facebook');
    } catch (e) {
      _logger.warning('Failed to log app install: $e');
    }
  }

  /// Log compass usage event
  Future<void> logCompassUsage({
    required String compassType,
    String? userGender,
    String? userAge,
  }) async {
    if (!_isInitialized) return;

    try {
      await _facebookAppEvents.logEvent(
        name: 'compass_usage',
        parameters: {
          'compass_type': compassType,
          if (userGender != null) 'user_gender': userGender,
          if (userAge != null) 'user_age': userAge,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        },
      );
      _logger.info('Compass usage logged: $compassType');
    } catch (e) {
      _logger.warning('Failed to log compass usage: $e');
    }
  }

  /// Log screen view event
  Future<void> logScreenView(String screenName) async {
    if (!_isInitialized) return;

    try {
      await _facebookAppEvents.logEvent(
        name: 'fb_mobile_content_view',
        parameters: {
          'fb_content_type': 'screen',
          'fb_content_id': screenName,
          'screen_name': screenName,
        },
      );
      _logger.info('Screen view logged: $screenName');
    } catch (e) {
      _logger.warning('Failed to log screen view: $e');
    }
  }

  /// Log ad interaction event
  Future<void> logAdInteraction({
    required String adType,
    required String action,
  }) async {
    if (!_isInitialized) return;

    try {
      await _facebookAppEvents.logEvent(
        name: 'ad_interaction',
        parameters: {
          'ad_type': adType,
          'action': action,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        },
      );
      _logger.info('Ad interaction logged: $adType - $action');
    } catch (e) {
      _logger.warning('Failed to log ad interaction: $e');
    }
  }

  /// Log user engagement event
  Future<void> logUserEngagement({
    required String engagementType,
    Map<String, String>? additionalParams,
  }) async {
    if (!_isInitialized) return;

    try {
      final parameters = <String, String>{
        'engagement_type': engagementType,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      };

      if (additionalParams != null) {
        parameters.addAll(additionalParams);
      }

      await _facebookAppEvents.logEvent(
        name: 'user_engagement',
        parameters: parameters,
      );
      _logger.info('User engagement logged: $engagementType');
    } catch (e) {
      _logger.warning('Failed to log user engagement: $e');
    }
  }

  /// Log custom event
  Future<void> logCustomEvent({
    required String eventName,
    Map<String, String>? parameters,
  }) async {
    if (!_isInitialized) return;

    try {
      await _facebookAppEvents.logEvent(
        name: eventName,
        parameters: parameters ?? {},
      );
      _logger.info('Custom event logged: $eventName');
    } catch (e) {
      _logger.warning('Failed to log custom event: $e');
    }
  }

  /// Set user properties for better targeting
  Future<void> setUserProperties({
    String? gender,
    String? ageRange,
    String? interests,
  }) async {
    if (!_isInitialized) return;

    try {
      // Facebook doesn't have direct user properties like Firebase
      // But we can log a user_profile event with this data
      await _facebookAppEvents.logEvent(
        name: 'user_profile_update',
        parameters: {
          if (gender != null) 'gender': gender,
          if (ageRange != null) 'age_range': ageRange,
          if (interests != null) 'interests': interests,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        },
      );
      _logger.info('User properties updated');
    } catch (e) {
      _logger.warning('Failed to set user properties: $e');
    }
  }

  /// Flush events (send immediately)
  Future<void> flush() async {
    if (!_isInitialized) return;

    try {
      await _facebookAppEvents.flush();
      _logger.info('Facebook events flushed');
    } catch (e) {
      _logger.warning('Failed to flush Facebook events: $e');
    }
  }

  /// Clear user data (for privacy compliance)
  Future<void> clearUserData() async {
    if (!_isInitialized) return;

    try {
      await _facebookAppEvents.clearUserData();
      _logger.info('Facebook user data cleared');
    } catch (e) {
      _logger.warning('Failed to clear user data: $e');
    }
  }

  /// Get anonymous ID for tracking
  Future<String?> getAnonymousId() async {
    if (!_isInitialized) return null;

    try {
      final anonymousId = await _facebookAppEvents.getAnonymousId();
      _logger.info('Anonymous ID retrieved: $anonymousId');
      return anonymousId;
    } catch (e) {
      _logger.warning('Failed to get anonymous ID: $e');
      return null;
    }
  }
}
