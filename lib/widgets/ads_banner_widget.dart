import 'package:flutter/material.dart';
import '../services/admob_service.dart';

/// Widget hiển thị banner ad sử dụng AdMobService
class AdBannerWidget extends StatelessWidget {
  final EdgeInsets? margin;
  final bool showPlaceholder;

  const AdBannerWidget({
    super.key,
    this.margin,
    this.showPlaceholder = true,
  });

  @override
  Widget build(BuildContext context) {
    final adWidget = AdMobService.instance.getBannerAdWidget();

    if (adWidget != null) {
      return Container(
        margin: margin,
        child: adWidget,
      );
    }

    // Hiển thị placeholder nếu ad chưa load hoặc không khả dụng
    if (showPlaceholder) {
      return Container(
        margin: margin,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Đang tải quảng cáo...',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
