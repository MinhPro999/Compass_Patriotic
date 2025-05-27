import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import '../core/culcalator_monster.dart';
import '../core/constants.dart';
import '../services/facebook_service.dart';

/// Provider để quản lý state của user (giới tính, năm sinh, quái số)
class UserState extends ChangeNotifier {
  static final Logger _logger = Logger('UserState');

  String _gender = '';
  String _yearOfBirth = '';
  int _guaNumber = 0;
  String _mansion = '';
  String _guaResult = AppConstants.insufficientDataMessage;
  bool _hasError = false;
  String _errorMessage = '';

  // Getters
  String get gender => _gender;
  String get yearOfBirth => _yearOfBirth;
  int get guaNumber => _guaNumber;
  String get mansion => _mansion;
  String get guaResult => _guaResult;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  bool get hasValidData => _gender.isNotEmpty && _yearOfBirth.isNotEmpty;

  /// Cập nhật giới tính
  void updateGender(String gender) {
    if (_gender != gender) {
      _gender = gender;
      _logger.info('Gender updated to: $gender');
      _calculateGuaNumber();

      // Log to Facebook
      FacebookService.instance.setUserProperties(
        gender: gender,
        ageRange: _yearOfBirth.isNotEmpty ? _getAgeRange() : null,
      );

      notifyListeners();
    }
  }

  /// Cập nhật năm sinh
  void updateYearOfBirth(String year) {
    if (_yearOfBirth != year) {
      _yearOfBirth = year;
      _logger.info('Year of birth updated to: $year');
      _calculateGuaNumber();

      // Log to Facebook
      FacebookService.instance.setUserProperties(
        gender: _gender.isNotEmpty ? _gender : null,
        ageRange: year.isNotEmpty ? _getAgeRange() : null,
      );

      notifyListeners();
    }
  }

  /// Reset tất cả dữ liệu
  void reset() {
    _gender = '';
    _yearOfBirth = '';
    _guaNumber = 0;
    _mansion = '';
    _guaResult = AppConstants.insufficientDataMessage;
    _hasError = false;
    _errorMessage = '';
    _logger.info('User state reset');
    notifyListeners();
  }

  /// Tính toán quái số và mệnh
  void _calculateGuaNumber() {
    _hasError = false;
    _errorMessage = '';

    if (_yearOfBirth.isEmpty || _gender.isEmpty) {
      _guaResult = AppConstants.insufficientDataMessage;
      _guaNumber = 0;
      _mansion = '';
      return;
    }

    try {
      final mappedGender = AppConstants.genderMapping[_gender];
      if (mappedGender == null) {
        _setError('Giới tính không hợp lệ');
        return;
      }

      final yearOfBirth = int.parse(_yearOfBirth);
      if (yearOfBirth < 1900 || yearOfBirth > DateTime.now().year) {
        _setError('Năm sinh không hợp lệ');
        return;
      }

      final result = GuaCalculator.determineMansion(yearOfBirth, mappedGender);

      if (result.containsKey('error')) {
        _setError(result['error']);
        return;
      }

      _guaNumber = result['guaNumber'] ?? 0;
      _mansion = result['mansion'] ?? '';
      _guaResult = "Quái số: $_guaNumber, Mệnh: $_mansion";

      _logger.info('Calculated gua number: $_guaNumber, mansion: $_mansion');
    } catch (e) {
      _logger.severe('Error calculating gua number: $e');
      _setError('Lỗi khi tính toán: ${e.toString()}');
    }
  }

  /// Set error state
  void _setError(String message) {
    _hasError = true;
    _errorMessage = message;
    _guaResult = "Lỗi: $message";
    _guaNumber = 0;
    _mansion = '';
    _logger.warning('Error set: $message');
  }

  /// Validate year input
  bool isValidYear(String year) {
    if (year.length != AppConstants.maxYearLength) return false;

    try {
      final yearInt = int.parse(year);
      return yearInt >= 1900 && yearInt <= DateTime.now().year;
    } catch (e) {
      return false;
    }
  }

  /// Get mapped gender for API calls
  String? getMappedGender() {
    return AppConstants.genderMapping[_gender];
  }

  /// Get age range for Facebook analytics
  String _getAgeRange() {
    if (_yearOfBirth.isEmpty) return 'unknown';

    try {
      final birthYear = int.parse(_yearOfBirth);
      final currentYear = DateTime.now().year;
      final age = currentYear - birthYear;

      if (age < 18) return 'under_18';
      if (age < 25) return '18_24';
      if (age < 35) return '25_34';
      if (age < 45) return '35_44';
      if (age < 55) return '45_54';
      if (age < 65) return '55_64';
      return '65_plus';
    } catch (e) {
      return 'unknown';
    }
  }
}
