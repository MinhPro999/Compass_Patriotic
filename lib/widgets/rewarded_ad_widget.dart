import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/admob_service.dart';

/// Utility class để hiển thị rewarded ads
class RewardedAdHelper {
  /// Hiển thị rewarded ad với callback khi user nhận được reward
  static Future<bool> showAd({
    required OnUserEarnedRewardCallback onUserEarnedReward,
  }) async {
    return await AdMobService.instance.showRewardedAd(
      onUserEarnedReward: onUserEarnedReward,
    );
  }

  /// Kiểm tra xem rewarded ad có sẵn sàng không
  static bool isReady() {
    return AdMobService.instance.isRewardedLoaded;
  }
}

/// Widget button để hiển thị rewarded ad
class RewardedAdButton extends StatelessWidget {
  final String text;
  final OnUserEarnedRewardCallback onUserEarnedReward;
  final VoidCallback? onAdNotReady;
  final ButtonStyle? style;
  final Widget? icon;

  const RewardedAdButton({
    super.key,
    this.text = 'Xem quảng cáo nhận thưởng',
    required this.onUserEarnedReward,
    this.onAdNotReady,
    this.style,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isReady = RewardedAdHelper.isReady();

    return ElevatedButton.icon(
      onPressed: isReady ? () => _showRewardedAd(context) : null,
      icon: icon ?? const Icon(Icons.play_circle_fill),
      label: Text(isReady ? text : 'Đang tải quảng cáo...'),
      style: style ??
          ElevatedButton.styleFrom(
            backgroundColor: isReady ? Colors.green : Colors.grey,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
    );
  }

  Future<void> _showRewardedAd(BuildContext context) async {
    final success = await RewardedAdHelper.showAd(
      onUserEarnedReward: onUserEarnedReward,
    );

    if (!success) {
      onAdNotReady?.call();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Quảng cáo không khả dụng'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }
}

/// Widget demo để test rewarded ads (chỉ dùng cho development)
class RewardedAdTestWidget extends StatefulWidget {
  const RewardedAdTestWidget({super.key});

  @override
  State<RewardedAdTestWidget> createState() => _RewardedAdTestWidgetState();
}

class _RewardedAdTestWidgetState extends State<RewardedAdTestWidget> {
  int _rewardCount = 0;
  String _lastReward = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Rewarded Ads'),
        backgroundColor: const Color(0xAEBE0A0A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.card_giftcard,
                      size: 64,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Số lần nhận thưởng: $_rewardCount',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_lastReward.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Phần thưởng cuối: $_lastReward',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            RewardedAdButton(
              text: 'Xem quảng cáo nhận thưởng',
              onUserEarnedReward: (ad, reward) {
                setState(() {
                  _rewardCount++;
                  _lastReward = '${reward.amount} ${reward.type}';
                });

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Bạn đã nhận được ${reward.amount} ${reward.type}!',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              onAdNotReady: () {
                // Handle when ad is not ready
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Trạng thái: ${RewardedAdHelper.isReady() ? "Sẵn sàng" : "Đang tải..."}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Quay lại'),
            ),
          ],
        ),
      ),
    );
  }
}
