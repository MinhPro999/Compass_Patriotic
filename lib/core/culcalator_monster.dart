class GuaCalculator {
  static Map<String, dynamic> determineMansion(int yearOfBirth, String gender) {
    int lastTwoDigitsSum = (yearOfBirth % 10) + ((yearOfBirth ~/ 10) % 10);

    if (lastTwoDigitsSum >= 10) {
      lastTwoDigitsSum = (lastTwoDigitsSum % 10) + (lastTwoDigitsSum ~/ 10);
    }

    int guaNumber;
    if (gender.toLowerCase() == 'male') {
      guaNumber =
          yearOfBirth < 2000 ? (10 - lastTwoDigitsSum) : (9 - lastTwoDigitsSum);
    } else if (gender.toLowerCase() == 'female') {
      guaNumber =
          yearOfBirth < 2000 ? (5 + lastTwoDigitsSum) : (6 + lastTwoDigitsSum);
    } else {
      return {
        'error': 'Giới tính không hợp lệ. Hãy nhập "male" hoặc "female".'
      };
    }

    if (guaNumber == 5) {
      guaNumber = gender.toLowerCase() == 'male' ? 2 : 8;
    }

    if (guaNumber >= 10) {
      guaNumber = (guaNumber % 10) + (guaNumber ~/ 10);
    }

    String mansion =
        ([1, 3, 4, 9].contains(guaNumber)) ? 'Đông Tứ Mệnh' : 'Tây Tứ Mệnh';

    return {'guaNumber': guaNumber, 'mansion': mansion};
  }
}
