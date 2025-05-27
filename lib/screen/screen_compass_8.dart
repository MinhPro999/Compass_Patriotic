import 'dart:async';

import 'package:compassapp_vn/core/main_compass.dart';
import 'package:compassapp_vn/core/streambuilder_degree.dart';
import 'package:compassapp_vn/widgets/build_infobox_8.dart';
import 'package:compassapp_vn/widgets/ads_banner_widget.dart';
import 'package:compassapp_vn/providers/user_state.dart';
import 'package:compassapp_vn/providers/compass_state.dart';
import 'package:compassapp_vn/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

class BatTrachScreen extends StatefulWidget {
  const BatTrachScreen({
    super.key,
  });

  @override
  _BatTrachScreenState createState() => _BatTrachScreenState();
}

class _BatTrachScreenState extends State<BatTrachScreen> {
  static final Logger _logger = Logger('BatTrachScreen');
  final String overlayImagePath = AppConstants.compass8Overlay;
  StreamSubscription? _compassSubscription;

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserState, CompassState>(
      builder: (context, userState, compassState, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'La Bàn Bát Trạch ${userState.gender} ${userState.yearOfBirth}',
              style: const TextStyle(
                fontSize: AppConstants.subtitleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: const Color(AppConstants.primaryRedColor),
            elevation: 0,
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              if (compassState.compassData != null)
                Image.asset(
                  compassState.compassData!['compass'][0]['background'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 0),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CompassWidget(
                              compassImagePath: compassState
                                      .compassData?['compass']?[0]?['co'] ??
                                  '',
                            ),
                            Image.asset(
                              overlayImagePath,
                              height: AppConstants.compassSize,
                              width: AppConstants.compassSize,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        StreamBuilder<CompassEvent>(
                          stream: FlutterCompass.events,
                          builder: (context, snapshot) {
                            final CompassEvent? event = snapshot.data;
                            final headingData = getHeadingData(event?.heading);
                            final double? heading = headingData['heading'];
                            final String direction = headingData['direction'];

                            if (heading == null) {
                              return const Text(
                                AppConstants.noSensorData,
                                style: TextStyle(
                                  fontSize: AppConstants.bodyFontSize,
                                  color: Colors.white,
                                ),
                              );
                            }

                            final info =
                                compassState.getDetailedInfo(direction);
                            final Color colorChu = Color(int.parse(
                                info['color_chu']!.replaceAll('0x', '0xFF')));
                            final Color colorBox = Color(int.parse(
                                info['color_box']!.replaceAll('0x', '0xFF')));

                            return Column(
                              children: [
                                BuildInfoBox8(
                                  data: {
                                    "huong": info['huong'] ?? '',
                                    "tot_xau": info['tot_xau'] ?? '',
                                    "cung": info['cung'] ?? '',
                                    "y_nghia": info['y_nghia'] ?? '',
                                    "nen": info['nen'] ?? '',
                                    "khong_nen": info['khong_nen'] ?? '',
                                  },
                                  heading: heading,
                                  colorChu: colorChu,
                                  colorBox: colorBox,
                                ),
                                const SizedBox(height: 16),
                                // Banner Ad
                                const AdBannerWidget(
                                  showPlaceholder: false,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Load JSON data using Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userState = Provider.of<UserState>(context, listen: false);
      final compassState = Provider.of<CompassState>(context, listen: false);

      if (userState.guaNumber > 0) {
        compassState.loadJsonData(guaNumber: userState.guaNumber);
        _logger
            .info('Loading JSON data for gua number: ${userState.guaNumber}');
      } else {
        _logger.warning('Invalid gua number: ${userState.guaNumber}');
      }
    });
  }
}
