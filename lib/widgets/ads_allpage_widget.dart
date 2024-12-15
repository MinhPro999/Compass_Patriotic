import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FullScreenAdWidget extends StatefulWidget {
  const FullScreenAdWidget({super.key});

  @override
  State<FullScreenAdWidget> createState() => _FullScreenAdWidgetState();
}

class _FullScreenAdWidgetState extends State<FullScreenAdWidget> {
  InterstitialAd? _interstitialAd;
  bool _isAdReady = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quảng cáo Toàn màn hình'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _isAdReady ? _showInterstitialAd : null,
          child: const Text('Hiển thị Quảng cáo'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  // Tải quảng cáo toàn trang
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId:
          'ca-app-pub-9304712998147652/1837124648', // Thay bằng Ad Unit ID của bạn
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdReady = true;

          // Lắng nghe sự kiện quảng cáo
          _interstitialAd?.setImmersiveMode(true);
          _interstitialAd?.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              print(
                  'Quảng cáo đã hiển thị'); // Khi quảng cáo đóng, bạn có thể tải lại một quảng cáo mới
              _loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('Quảng cáo không thể hiển thị: $error');
              ad.dispose();
              _loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Không thể tải quảng cáo: $error');
          _isAdReady = false;
        },
      ),
    );
  }

  // Hiển thị quảng cáo toàn màn hình
  void _showInterstitialAd() {
    if (_isAdReady && _interstitialAd != null) {
      _interstitialAd?.show();
      _isAdReady = false;
    } else {
      print('Quảng cáo chưa sẵn sàng.');
    }
  }
}
