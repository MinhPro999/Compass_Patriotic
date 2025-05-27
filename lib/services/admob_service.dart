import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logging/logging.dart';
import '../core/constants.dart';

/// Service để quản lý tất cả AdMob operations
class AdMobService {
  static final Logger _logger = Logger('AdMobService');
  static AdMobService? _instance;
  static AdMobService get instance => _instance ??= AdMobService._();

  AdMobService._();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Ad instances
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  // Ad states
  bool _isBannerLoaded = false;
  bool _isInterstitialLoaded = false;

  // Getters for ad states
  bool get isBannerLoaded => _isBannerLoaded;
  bool get isInterstitialLoaded => _isInterstitialLoaded;

  /// Khởi tạo AdMob
  Future<void> initialize() async {
    try {
      _logger.info('Initializing AdMob...');

      final initResult = await MobileAds.instance.initialize();

      _logger.info('AdMob initialization completed');
      _logger.info('Adapter statuses: ${initResult.adapterStatuses}');

      _isInitialized = true;

      // Pre-load ads
      await Future.wait([
        loadBannerAd(),
        loadInterstitialAd(),
      ]);
    } catch (e) {
      _logger.severe('Failed to initialize AdMob: $e');
      _isInitialized = false;
    }
  }

  /// Load Banner Ad
  Future<void> loadBannerAd() async {
    if (_bannerAd != null) {
      _bannerAd!.dispose();
    }

    try {
      _bannerAd = BannerAd(
        adUnitId: _getBannerAdUnitId(),
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) {
            _isBannerLoaded = true;
            _logger.info('Banner ad loaded successfully');
          },
          onAdFailedToLoad: (ad, error) {
            _isBannerLoaded = false;
            _logger.warning('Banner ad failed to load: ${error.message}');
            ad.dispose();

            // Retry after delay
            Timer(const Duration(seconds: 30), () => loadBannerAd());
          },
          onAdOpened: (_) => _logger.info('Banner ad opened'),
          onAdClosed: (_) => _logger.info('Banner ad closed'),
        ),
      );

      await _bannerAd!.load();
    } catch (e) {
      _logger.severe('Error loading banner ad: $e');
      _isBannerLoaded = false;
    }
  }

  /// Load Interstitial Ad
  Future<void> loadInterstitialAd() async {
    try {
      await InterstitialAd.load(
        adUnitId: _getInterstitialAdUnitId(),
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            _isInterstitialLoaded = true;
            _logger.info('Interstitial ad loaded successfully');

            _interstitialAd!.setImmersiveMode(true);
            _interstitialAd!.fullScreenContentCallback =
                FullScreenContentCallback(
              onAdShowedFullScreenContent: (_) {
                _logger.info('Interstitial ad showed');
              },
              onAdDismissedFullScreenContent: (ad) {
                _logger.info('Interstitial ad dismissed');
                ad.dispose();
                _isInterstitialLoaded = false;
                // Pre-load next ad
                loadInterstitialAd();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                _logger.warning('Interstitial ad failed to show: $error');
                ad.dispose();
                _isInterstitialLoaded = false;
                loadInterstitialAd();
              },
            );
          },
          onAdFailedToLoad: (error) {
            _isInterstitialLoaded = false;
            _logger.warning('Interstitial ad failed to load: ${error.message}');

            // Retry after delay
            Timer(const Duration(seconds: 30), () => loadInterstitialAd());
          },
        ),
      );
    } catch (e) {
      _logger.severe('Error loading interstitial ad: $e');
      _isInterstitialLoaded = false;
    }
  }

  /// Show Interstitial Ad
  Future<bool> showInterstitialAd() async {
    if (!_isInterstitialLoaded || _interstitialAd == null) {
      _logger.warning('Interstitial ad not ready');
      return false;
    }

    try {
      await _interstitialAd!.show();
      return true;
    } catch (e) {
      _logger.severe('Error showing interstitial ad: $e');
      return false;
    }
  }

  /// Get Banner Ad Widget
  Widget? getBannerAdWidget() {
    if (!_isBannerLoaded || _bannerAd == null) {
      return null;
    }

    return SizedBox(
      height: _bannerAd!.size.height.toDouble(),
      width: _bannerAd!.size.width.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }

  /// Get production ad unit IDs
  String _getBannerAdUnitId() {
    return AppConstants.bannerAdUnitId;
  }

  String _getInterstitialAdUnitId() {
    return AppConstants.interstitialAdUnitId;
  }

  /// Dispose all ads
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();

    _isBannerLoaded = false;
    _isInterstitialLoaded = false;

    _logger.info('AdMob service disposed');
  }
}
