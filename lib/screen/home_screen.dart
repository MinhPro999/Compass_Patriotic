import 'package:compassapp_vn/screen/screen_compass.dart';
import 'package:compassapp_vn/screen/screen_compass_8.dart';
import 'package:compassapp_vn/widgets/funtion_gidview.dart';
import 'package:compassapp_vn/widgets/user_info_bar.dart';
import 'package:compassapp_vn/widgets/ads_banner_widget.dart';
import 'package:compassapp_vn/widgets/ads_allpage_widget.dart';
import 'package:compassapp_vn/providers/user_state.dart';
import 'package:compassapp_vn/services/facebook_service.dart';
import 'package:compassapp_vn/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Log screen view to Facebook
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FacebookService.instance.logScreenView('home_screen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Color.fromARGB(222, 190, 10, 10),
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          body: Stack(
            children: [
              // Ảnh nền
              Image.asset(
                AppConstants.backgroundImage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                color: Colors.black
                    .withValues(alpha: OpacityConstants.backgroundOverlay),
                colorBlendMode: BlendMode.srcATop,
              ),
              SafeArea(
                child: Column(
                  children: [
                    const UserInfoBar(),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                AppConstants.chooseCompassTitle,
                                style: TextStyle(
                                  fontSize: AppConstants.titleFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  mainAxisExtent: 200,
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 2,
                                itemBuilder: (context, index) {
                                  return index == 0
                                      ? funtionGidview(
                                          AppConstants.normalCompassImage,
                                          AppConstants.basicCompassTitle,
                                          () async {
                                            // Log compass usage to Facebook
                                            FacebookService.instance
                                                .logCompassUsage(
                                              compassType: 'basic_compass',
                                            );

                                            // Hiển thị interstitial ad trước khi navigate
                                            await InterstitialAdHelper.showAd();

                                            if (context.mounted) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CompassDetailScreen(
                                                    title: '',
                                                    description: '',
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        )
                                      : funtionGidview(
                                          AppConstants.directionsImage,
                                          AppConstants.ageCompassTitle,
                                          () async {
                                            final userState =
                                                Provider.of<UserState>(context,
                                                    listen: false);

                                            // Kiểm tra xem giới tính hoặc năm sinh có bị rỗng không
                                            if (!userState.hasValidData) {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: const Text(AppConstants
                                                      .missingInfoError),
                                                  content: const Text(
                                                      AppConstants
                                                          .missingInfoMessage),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                          AppConstants
                                                              .agreeButton),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else {
                                              // Log compass usage to Facebook
                                              FacebookService.instance
                                                  .logCompassUsage(
                                                compassType: 'age_compass',
                                                userGender: userState.gender,
                                                userAge: userState.yearOfBirth,
                                              );

                                              // Hiển thị interstitial ad trước khi navigate
                                              await InterstitialAdHelper
                                                  .showAd();

                                              if (context.mounted) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const BatTrachScreen(),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Banner Ad ở cuối màn hình
                    const AdBannerWidget(
                      margin: EdgeInsets.only(top: 16),
                      showPlaceholder: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
