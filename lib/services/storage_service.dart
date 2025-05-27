import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';

/// Service để quản lý lưu trữ dữ liệu local với SharedPreferences
class StorageService {
  static final Logger _logger = Logger('StorageService');
  static StorageService? _instance;
  static StorageService get instance => _instance ??= StorageService._();
  
  StorageService._();

  SharedPreferences? _prefs;
  bool _isInitialized = false;
  
  bool get isInitialized => _isInitialized;

  // Storage keys
  static const String _keyGender = 'user_gender';
  static const String _keyYearOfBirth = 'user_year_of_birth';
  static const String _keyFirstLaunch = 'app_first_launch';
  static const String _keyLastUsed = 'app_last_used';

  /// Khởi tạo SharedPreferences
  Future<void> initialize() async {
    try {
      _logger.info('Initializing StorageService...');
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
      _logger.info('StorageService initialized successfully');
      
      // Log first launch if needed
      await _trackFirstLaunch();
      await _updateLastUsed();
      
    } catch (e) {
      _logger.severe('Failed to initialize StorageService: $e');
      _isInitialized = false;
    }
  }

  /// Lưu giới tính
  Future<bool> saveGender(String gender) async {
    if (!_isInitialized || _prefs == null) {
      _logger.warning('StorageService not initialized');
      return false;
    }

    try {
      final success = await _prefs!.setString(_keyGender, gender);
      if (success) {
        _logger.info('Gender saved: $gender');
      } else {
        _logger.warning('Failed to save gender');
      }
      return success;
    } catch (e) {
      _logger.severe('Error saving gender: $e');
      return false;
    }
  }

  /// Lấy giới tính đã lưu
  String? getSavedGender() {
    if (!_isInitialized || _prefs == null) {
      _logger.warning('StorageService not initialized');
      return null;
    }

    try {
      final gender = _prefs!.getString(_keyGender);
      if (gender != null) {
        _logger.info('Retrieved saved gender: $gender');
      }
      return gender;
    } catch (e) {
      _logger.severe('Error retrieving gender: $e');
      return null;
    }
  }

  /// Lưu năm sinh
  Future<bool> saveYearOfBirth(String year) async {
    if (!_isInitialized || _prefs == null) {
      _logger.warning('StorageService not initialized');
      return false;
    }

    try {
      final success = await _prefs!.setString(_keyYearOfBirth, year);
      if (success) {
        _logger.info('Year of birth saved: $year');
      } else {
        _logger.warning('Failed to save year of birth');
      }
      return success;
    } catch (e) {
      _logger.severe('Error saving year of birth: $e');
      return false;
    }
  }

  /// Lấy năm sinh đã lưu
  String? getSavedYearOfBirth() {
    if (!_isInitialized || _prefs == null) {
      _logger.warning('StorageService not initialized');
      return null;
    }

    try {
      final year = _prefs!.getString(_keyYearOfBirth);
      if (year != null) {
        _logger.info('Retrieved saved year of birth: $year');
      }
      return year;
    } catch (e) {
      _logger.severe('Error retrieving year of birth: $e');
      return null;
    }
  }

  /// Lưu cả giới tính và năm sinh cùng lúc
  Future<bool> saveUserInfo(String gender, String yearOfBirth) async {
    if (!_isInitialized || _prefs == null) {
      _logger.warning('StorageService not initialized');
      return false;
    }

    try {
      final genderSuccess = await _prefs!.setString(_keyGender, gender);
      final yearSuccess = await _prefs!.setString(_keyYearOfBirth, yearOfBirth);
      
      final success = genderSuccess && yearSuccess;
      if (success) {
        _logger.info('User info saved: $gender, $yearOfBirth');
      } else {
        _logger.warning('Failed to save user info');
      }
      return success;
    } catch (e) {
      _logger.severe('Error saving user info: $e');
      return false;
    }
  }

  /// Lấy thông tin user đã lưu
  Map<String, String?> getSavedUserInfo() {
    if (!_isInitialized || _prefs == null) {
      _logger.warning('StorageService not initialized');
      return {'gender': null, 'yearOfBirth': null};
    }

    try {
      final gender = _prefs!.getString(_keyGender);
      final yearOfBirth = _prefs!.getString(_keyYearOfBirth);
      
      _logger.info('Retrieved user info - Gender: $gender, Year: $yearOfBirth');
      
      return {
        'gender': gender,
        'yearOfBirth': yearOfBirth,
      };
    } catch (e) {
      _logger.severe('Error retrieving user info: $e');
      return {'gender': null, 'yearOfBirth': null};
    }
  }

  /// Xóa dữ liệu user
  Future<bool> clearUserData() async {
    if (!_isInitialized || _prefs == null) {
      _logger.warning('StorageService not initialized');
      return false;
    }

    try {
      final genderRemoved = await _prefs!.remove(_keyGender);
      final yearRemoved = await _prefs!.remove(_keyYearOfBirth);
      
      final success = genderRemoved && yearRemoved;
      if (success) {
        _logger.info('User data cleared');
      } else {
        _logger.warning('Failed to clear user data');
      }
      return success;
    } catch (e) {
      _logger.severe('Error clearing user data: $e');
      return false;
    }
  }

  /// Kiểm tra xem có dữ liệu user đã lưu không
  bool hasUserData() {
    if (!_isInitialized || _prefs == null) {
      return false;
    }

    try {
      final gender = _prefs!.getString(_keyGender);
      final yearOfBirth = _prefs!.getString(_keyYearOfBirth);
      
      return gender != null && gender.isNotEmpty && 
             yearOfBirth != null && yearOfBirth.isNotEmpty;
    } catch (e) {
      _logger.severe('Error checking user data: $e');
      return false;
    }
  }

  /// Track first launch
  Future<void> _trackFirstLaunch() async {
    if (!_isInitialized || _prefs == null) return;

    try {
      final isFirstLaunch = _prefs!.getBool(_keyFirstLaunch) ?? true;
      if (isFirstLaunch) {
        await _prefs!.setBool(_keyFirstLaunch, false);
        _logger.info('First app launch tracked');
      }
    } catch (e) {
      _logger.warning('Error tracking first launch: $e');
    }
  }

  /// Update last used timestamp
  Future<void> _updateLastUsed() async {
    if (!_isInitialized || _prefs == null) return;

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      await _prefs!.setInt(_keyLastUsed, timestamp);
    } catch (e) {
      _logger.warning('Error updating last used: $e');
    }
  }

  /// Check if this is first launch
  bool isFirstLaunch() {
    if (!_isInitialized || _prefs == null) return true;

    try {
      return _prefs!.getBool(_keyFirstLaunch) ?? true;
    } catch (e) {
      _logger.warning('Error checking first launch: $e');
      return true;
    }
  }

  /// Get last used timestamp
  DateTime? getLastUsed() {
    if (!_isInitialized || _prefs == null) return null;

    try {
      final timestamp = _prefs!.getInt(_keyLastUsed);
      return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
    } catch (e) {
      _logger.warning('Error getting last used: $e');
      return null;
    }
  }

  /// Get all stored keys (for debugging)
  Set<String> getAllKeys() {
    if (!_isInitialized || _prefs == null) return {};

    try {
      return _prefs!.getKeys();
    } catch (e) {
      _logger.warning('Error getting all keys: $e');
      return {};
    }
  }
}
