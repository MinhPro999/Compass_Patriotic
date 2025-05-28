import 'package:compassapp_vn/core/main_compass.dart';
import 'package:compassapp_vn/core/streambuilder_degree.dart';
import 'package:compassapp_vn/widgets/ads_banner_widget.dart';
import 'package:compassapp_vn/providers/compass_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Hàm xác định hướng từ góc
String getDirectionFromAngle(double angle) {
  if (angle >= 337.5 || angle < 22.5) {
    return 'Bắc';
  } else if (angle >= 22.5 && angle < 67.5) {
    return 'Đông Bắc';
  } else if (angle >= 67.5 && angle < 112.5) {
    return 'Đông';
  } else if (angle >= 112.5 && angle < 157.5) {
    return 'Đông Nam';
  } else if (angle >= 157.5 && angle < 202.5) {
    return 'Nam';
  } else if (angle >= 202.5 && angle < 247.5) {
    return 'Tây Nam';
  } else if (angle >= 247.5 && angle < 292.5) {
    return 'Tây';
  } else if (angle >= 292.5 && angle < 337.5) {
    return 'Tây Bắc';
  }
  return 'Không xác định';
}

class CompassDetailScreen extends StatefulWidget {
  final String title;
  final String description;

  const CompassDetailScreen({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  State<CompassDetailScreen> createState() => _CompassDetailScreenState();
}

class _CompassDetailScreenState extends State<CompassDetailScreen> {
  final String backgroundImagePath = 'assets/images/screen_dang.jpg';
  final String compassImagePath = 'assets/images/compass.png';
  final String overlayImagePath = 'assets/images/khung_compass.png';
  bool _permissionsChecked = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final compassState = Provider.of<CompassState>(context, listen: false);
    await compassState.initializeWithPermissions(context);
    setState(() {
      _permissionsChecked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Khóa màn hình ở chế độ dọc khi vào màn hình chi tiết
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xF6FFFFFF),
          ),
          onPressed: () {
            // Gỡ khóa chế độ xoay màn hình khi quay lại
            SystemChrome.setPreferredOrientations([]);
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'La Bàn Cơ Bản',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xAEBE0A0A),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true, // Để AppBar nằm trên ảnh nền
      body: Stack(
        children: [
          // Ảnh nền
          Image.asset(
            backgroundImagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(
                      height: 120), // Thêm khoảng cách ở đầu SafeArea
                  Center(
                    // Sử dụng Center để căn giữa toàn bộ nội dung
                    child: Column(
                      mainAxisSize: MainAxisSize
                          .min, // Thu nhỏ theo nội dung thay vì chiếm toàn bộ chiều cao
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Widget la bàn xoay
                            CompassWidget(
                              compassImagePath: compassImagePath,
                            ),
                            // Khung PNG cố định
                            Image.asset(
                              overlayImagePath,
                              height: 400,
                              width: 400,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Hiển thị góc tham chiếu
                        const StreamBuilderCompassDegree(),
                        const SizedBox(height: 8),

                        // Mô tả
                        Text(
                          widget.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 20),

                        // Banner Ad
                        const AdBannerWidget(
                          showPlaceholder: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
