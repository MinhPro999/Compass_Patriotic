import 'package:flutter/material.dart';
import '../widgets/ads_banner_widget.dart';
import '../widgets/ads_allpage_widget.dart';
import '../widgets/rewarded_ad_widget.dart';
import '../services/admob_service.dart';

/// Screen để test tất cả loại ads (chỉ dùng cho development)
class AdMobTestScreen extends StatefulWidget {
  const AdMobTestScreen({super.key});

  @override
  State<AdMobTestScreen> createState() => _AdMobTestScreenState();
}

class _AdMobTestScreenState extends State<AdMobTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdMob Test Screen'),
        backgroundColor: const Color(0xAEBE0A0A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // AdMob Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AdMob Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStatusRow(
                      'AdMob Initialized',
                      AdMobService.instance.isInitialized,
                    ),
                    _buildStatusRow(
                      'Banner Ad Ready',
                      AdMobService.instance.isBannerLoaded,
                    ),
                    _buildStatusRow(
                      'Interstitial Ad Ready',
                      AdMobService.instance.isInterstitialLoaded,
                    ),
                    _buildStatusRow(
                      'Rewarded Ad Ready',
                      AdMobService.instance.isRewardedLoaded,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Banner Ad Test
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Banner Ad Test',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    AdBannerWidget(
                      showPlaceholder: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Interstitial Ad Test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Interstitial Ad Test',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final success = await InterstitialAdHelper.showAd();
                        if (!success && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Interstitial ad not ready'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.fullscreen),
                      label: Text(
                        InterstitialAdHelper.isReady()
                            ? 'Show Interstitial Ad'
                            : 'Loading...',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Rewarded Ad Test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rewarded Ad Test',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    RewardedAdButton(
                      text: 'Show Rewarded Ad',
                      onUserEarnedReward: (ad, reward) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Earned ${reward.amount} ${reward.type}!',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Navigation Tests
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Navigation Tests',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FullScreenAdWidget(),
                          ),
                        );
                      },
                      child: const Text('Test Interstitial Widget'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RewardedAdTestWidget(),
                          ),
                        );
                      },
                      child: const Text('Test Rewarded Widget'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Reload Ads
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ad Management',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              AdMobService.instance.loadBannerAd();
                              setState(() {});
                            },
                            child: const Text('Reload Banner'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              AdMobService.instance.loadInterstitialAd();
                              setState(() {});
                            },
                            child: const Text('Reload Interstitial'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, bool status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Icon(
            status ? Icons.check_circle : Icons.cancel,
            color: status ? Colors.green : Colors.red,
            size: 20,
          ),
        ],
      ),
    );
  }
}
