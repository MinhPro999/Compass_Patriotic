import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/user_state.dart';
import '../core/constants.dart';

class UserInfoBar extends StatefulWidget {
  final Function(String yearOfBirth, String gender)? onInfoChanged;

  const UserInfoBar({super.key, this.onInfoChanged});

  @override
  State<UserInfoBar> createState() => _UserInfoBarState();
}

class _UserInfoBarState extends State<UserInfoBar> {
  final TextEditingController _yearController = TextEditingController();
  final FocusNode _yearFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    // Cài đặt giao diện status bar
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(AppConstants.statusBarColor),
      ),
    );

    return Consumer<UserState>(
      builder: (context, userState, child) {
        return Container(
          color: const Color(AppConstants.statusBarColor),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  SizedBox(
                    height: 48,
                    width: 48,
                    child: Image.asset(
                      AppConstants.appIcon,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 0),
                  // Chọn giới tính
                  Expanded(
                    child: _buildGenderSelection(userState),
                  ),
                  const SizedBox(width: 0),
                  // Nhập năm sinh
                  SizedBox(
                    width: 100,
                    child: _buildYearOfBirthField(userState),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Hiển thị quái số và mệnh
              Text(
                userState.guaResult,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppConstants.bodyFontSize,
                  fontWeight: FontWeight.bold,
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
    _yearController.dispose();
    _yearFocusNode.dispose();
    super.dispose();
  }

  // Widget chọn giới tính
  Widget _buildGenderSelection(UserState userState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _genderRadio('Nam', userState),
        const SizedBox(width: 0),
        _genderRadio('Nữ', userState),
      ],
    );
  }

  // Widget nhập năm sinh
  Widget _buildYearOfBirthField(UserState userState) {
    return TextField(
      textAlign: TextAlign.center,
      controller: _yearController,
      focusNode: _yearFocusNode,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Năm sinh',
        hintStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Color(AppConstants.yellowColor),
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Color(AppConstants.yellowColor),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Color(AppConstants.darkYellowColor),
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        LengthLimitingTextInputFormatter(AppConstants.maxYearLength),
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (value) {
        userState.updateYearOfBirth(value);
        widget.onInfoChanged?.call(value, userState.gender);
        if (value.length == AppConstants.maxYearLength) {
          _yearFocusNode.unfocus();
        }
      },
    );
  }

  // Radio button cho giới tính
  Widget _genderRadio(String value, UserState userState) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: userState.gender,
          onChanged: (newValue) {
            if (newValue != null) {
              userState.updateGender(newValue);
              widget.onInfoChanged?.call(userState.yearOfBirth, newValue);
            }
          },
          activeColor: const Color(AppConstants.darkYellowColor),
        ),
        Text(value,
            style: const TextStyle(color: Color(AppConstants.yellowColor))),
      ],
    );
  }
}
