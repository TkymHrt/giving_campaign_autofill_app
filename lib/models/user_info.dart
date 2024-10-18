import 'dart:convert';

class UserInfo {
  final String lastName;
  final String firstName;
  final String kanaLastName;
  final String kanaFirstName;
  final String email;
  final String tel;
  final String gender;
  final int birthYear;
  final int birthMonth;
  final int birthDay;

  UserInfo({
    required this.lastName,
    required this.firstName,
    required this.kanaLastName,
    required this.kanaFirstName,
    required this.email,
    required this.tel,
    required this.gender,
    required this.birthYear,
    required this.birthMonth,
    required this.birthDay,
  });

  Map<String, dynamic> toJson() => {
        'lastName': lastName,
        'firstName': firstName,
        'kanaLastName': kanaLastName,
        'kanaFirstName': kanaFirstName,
        'email': email,
        'tel': tel,
        'gender': gender,
        'birthYear': birthYear,
        'birthMonth': birthMonth,
        'birthDay': birthDay,
      };

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        lastName: json['lastName'],
        firstName: json['firstName'],
        kanaLastName: json['kanaLastName'],
        kanaFirstName: json['kanaFirstName'],
        email: json['email'],
        tel: json['tel'],
        gender: json['gender'],
        birthYear: json['birthYear'],
        birthMonth: json['birthMonth'],
        birthDay: json['birthDay'],
      );

  static UserInfo? fromPrefs(String? jsonString) {
    if (jsonString == null) return null;
    try {
      return UserInfo.fromJson(json.decode(jsonString));
    } catch (e) {
      return null;
    }
  }
}
