import 'package:flutter/material.dart';
import '../services/admob_service.dart';

/// Utility class để hiển thị interstitial ads
class InterstitialAdHelper {
  /// Hiển thị interstitial ad nếu có sẵn
  static Future<bool> showAd() async {
    return await AdMobService.instance.showInterstitialAd();
  }

  /// Kiểm tra xem interstitial ad có sẵn sàng không
  static bool isReady() {
    return AdMobService.instance.isInterstitialLoaded;
  }
}

/// Widget demo để test interstitial ads (chỉ dùng cho development)
class FullScreenAdWidget extends StatelessWidget {
  const FullScreenAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Quảng cáo Toàn màn hình'),
        backgroundColor: const Color(0xAEBE0A0A),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final success = await InterstitialAdHelper.showAd();
                if (!success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Quảng cáo chưa sẵn sàng'),
                    ),
                  );
                }
              },
              child: const Text('Hiển thị Quảng cáo Interstitial'),
            ),
            const SizedBox(height: 20),
            Text(
              'Trạng thái: ${InterstitialAdHelper.isReady() ? "Sẵn sàng" : "Đang tải..."}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Quay lại'),
            ),
          ],
        ),
      ),
    );
  }
}
