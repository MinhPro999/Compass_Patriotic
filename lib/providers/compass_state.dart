import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:logging/logging.dart';
import '../core/constants.dart';
// import '../services/permission_service.dart'; // Disabled - not needed

/// Provider để quản lý state của compass
class CompassState extends ChangeNotifier {
  static final Logger _logger = Logger('CompassState');

  StreamSubscription<CompassEvent>? _compassSubscription;
  double _heading = 0.0;
  String _direction = DirectionConstants.unknown;
  bool _isCompassAvailable = false;
  bool _hasError = false;
  String _errorMessage = '';
  Map<String, dynamic>? _compassData;
  Map<String, dynamic> _huongTotXauMap = {};
  Map<String, dynamic> _yNghiaCungMap = {};
  Map<String, dynamic> _nenKhongNenMap = {};

  // Getters
  double get heading => _heading;
  String get direction => _direction;
  bool get isCompassAvailable => _isCompassAvailable;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  Map<String, dynamic>? get compassData => _compassData;
  Map<String, dynamic> get huongTotXauMap => _huongTotXauMap;
  Map<String, dynamic> get yNghiaCungMap => _yNghiaCungMap;
  Map<String, dynamic> get nenKhongNenMap => _nenKhongNenMap;

  CompassState() {
    _initializeCompass();
  }

  /// Khởi tạo compass (không cần permission)
  Future<bool> initializeWithPermissions(context) async {
    try {
      _logger.info('Initializing compass (no permissions needed)...');

      // Compass không cần permission - magnetometer/gyroscope là cảm biến cơ bản
      // Khởi tạo trực tiếp
      _reinitializeCompass();
      return true;
    } catch (e) {
      _logger.severe('Error initializing compass: $e');
      _setError('Lỗi khởi tạo la bàn: ${e.toString()}');
      return false;
    }
  }

  /// Khởi tạo lại compass
  void _reinitializeCompass() {
    try {
      // Hủy subscription cũ nếu có
      _compassSubscription?.cancel();

      // Tạo subscription mới
      _compassSubscription = FlutterCompass.events?.listen(
        _onCompassEvent,
        onError: _onCompassError,
      );

      if (_compassSubscription != null) {
        _isCompassAvailable = true;
        _hasError = false;
        _errorMessage = '';
        _logger.info('Compass reinitialized successfully');
        notifyListeners();
      } else {
        _setError('Compass không khả dụng trên thiết bị này');
      }
    } catch (e) {
      _logger.severe('Error reinitializing compass: $e');
      _setError('Lỗi khởi tạo lại compass: ${e.toString()}');
    }
  }

  /// Khởi tạo compass
  void _initializeCompass() {
    try {
      _compassSubscription = FlutterCompass.events?.listen(
        _onCompassEvent,
        onError: _onCompassError,
      );

      if (_compassSubscription != null) {
        _isCompassAvailable = true;
        _logger.info('Compass initialized successfully');
      } else {
        _setError('Compass không khả dụng trên thiết bị này');
      }
    } catch (e) {
      _logger.severe('Error initializing compass: $e');
      _setError('Lỗi khởi tạo compass: ${e.toString()}');
    }
  }

  /// Xử lý sự kiện compass
  void _onCompassEvent(CompassEvent event) {
    try {
      if (event.heading != null) {
        _heading = event.heading!;
        _direction = _getDirectionFromAngle(_heading);
        _hasError = false;
        _errorMessage = '';
        notifyListeners();
      }
    } catch (e) {
      _logger.warning('Error processing compass event: $e');
      _setError('Lỗi xử lý dữ liệu compass');
    }
  }

  /// Xử lý lỗi compass
  void _onCompassError(dynamic error) {
    _logger.severe('Compass error: $error');
    _setError('Lỗi cảm biến compass: ${error.toString()}');
  }

  /// Tính toán hướng từ góc
  String _getDirectionFromAngle(double angle) {
    // Chuyển góc âm thành góc dương
    if (angle < 0) {
      angle += 360;
    }

    if (angle >= 337.5 || angle < 22.5) {
      return DirectionConstants.north;
    } else if (angle >= 22.5 && angle < 67.5) {
      return DirectionConstants.northeast;
    } else if (angle >= 67.5 && angle < 112.5) {
      return DirectionConstants.east;
    } else if (angle >= 112.5 && angle < 157.5) {
      return DirectionConstants.southeast;
    } else if (angle >= 157.5 && angle < 202.5) {
      return DirectionConstants.south;
    } else if (angle >= 202.5 && angle < 247.5) {
      return DirectionConstants.southwest;
    } else if (angle >= 247.5 && angle < 292.5) {
      return DirectionConstants.west;
    } else if (angle >= 292.5 && angle < 337.5) {
      return DirectionConstants.northwest;
    }
    return DirectionConstants.unknown;
  }

  /// Load dữ liệu JSON cho compass 8 hướng
  Future<void> loadJsonData({required int guaNumber}) async {
    try {
      final fileName = AppConstants.jsonFileMapping[guaNumber] ??
          AppConstants.defaultJsonFile;

      _logger.info(
          'Loading JSON data for gua number: $guaNumber, file: $fileName');

      final String response = await rootBundle.loadString('lib/data/$fileName');
      final data = json.decode(response);

      _compassData = data;
      _buildDataMaps();

      _logger.info('JSON data loaded successfully');
      notifyListeners();
    } catch (e) {
      _logger.severe('Error loading JSON data: $e');
      _setError('Lỗi tải dữ liệu: ${e.toString()}');
    }
  }

  /// Xây dựng các map dữ liệu từ JSON
  void _buildDataMaps() {
    if (_compassData == null) return;

    try {
      _huongTotXauMap = {
        for (var item in _compassData!['huong_tot_xau'])
          item['huong'].toLowerCase(): {
            'huong': item['huong'] ?? '',
            'tot_xau': item['tot_xau'] ?? '',
            'cung': item['cung'] ?? '',
            'color_chu': item['color_chu'] ?? '#FFFFFF',
            'color_box': item['color_box'] ?? '#000000'
          }
      };

      _yNghiaCungMap = {
        for (var item in _compassData!['y_nghia_cung'])
          item['cung']: {
            'cung': item['cung'] ?? '',
            'y_nghia': item['y_nghia'] ?? ''
          }
      };

      _nenKhongNenMap = {
        for (var item in _compassData!['nen_khong_nen'])
          item['cung']: {
            'cung': item['cung'] ?? '',
            'nen': item['nen'] ?? '',
            'khong_nen': item['khong_nen'] ?? ''
          }
      };

      _logger.info('Data maps built successfully');
    } catch (e) {
      _logger.warning('Error building data maps: $e');
    }
  }

  /// Lấy thông tin chi tiết cho một hướng
  Map<String, String> getDetailedInfo(String direction) {
    Map<String, String> info = {};
    String directionKey = direction.toLowerCase();

    if (_huongTotXauMap.containsKey(directionKey)) {
      var currentData = _huongTotXauMap[directionKey];
      info['tot_xau'] = currentData?['tot_xau'] ?? '';
      info['huong'] = currentData?['huong'] ?? '';
      info['cung'] = currentData?['cung'] ?? '';
      info['color_chu'] = currentData?['color_chu'] ?? '0xFFFFFFFF';
      info['color_box'] = currentData?['color_box'] ?? '0xFF000000';
    }

    if (info['cung'] != null && _yNghiaCungMap.containsKey(info['cung'])) {
      var cungData = _yNghiaCungMap[info['cung']];
      info['y_nghia'] = cungData?['y_nghia'] ?? '';
    }

    if (info['cung'] != null && _nenKhongNenMap.containsKey(info['cung'])) {
      var nenData = _nenKhongNenMap[info['cung']];
      info['nen'] = nenData?['nen'] ?? '';
      info['khong_nen'] = nenData?['khong_nen'] ?? '';
    }

    return info;
  }

  /// Set error state
  void _setError(String message) {
    _hasError = true;
    _errorMessage = message;
    _isCompassAvailable = false;
    notifyListeners();
  }

  /// Reset compass state
  void reset() {
    _heading = 0.0;
    _direction = DirectionConstants.unknown;
    _hasError = false;
    _errorMessage = '';
    _compassData = null;
    _huongTotXauMap.clear();
    _yNghiaCungMap.clear();
    _nenKhongNenMap.clear();
    _logger.info('Compass state reset');
    notifyListeners();
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    _logger.info('CompassState disposed');
    super.dispose();
  }
}
