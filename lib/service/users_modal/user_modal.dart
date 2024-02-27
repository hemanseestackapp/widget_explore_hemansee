// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String userType;
  String uid;
  String profile;
  String firstName;
  String lastName;
  String userName;
  String email;
  String mobile;
  String password;
  String confirmPassword;

  UserModel({
    required this.userType,
    required this.uid,
    required this. profile,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.mobile,
    required this.password,
    required this.confirmPassword,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json['uid'],
    userType: json['userType'],
    profile: json['image'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    userName: json['userName'],
    email: json['email'],
    mobile: json['mobile'],
    password: json['password'],
    confirmPassword: json['confirmPassword'],
  );

  Map<String, dynamic> toJson() => {
    'userType':userType,
    'uid':uid,
    'image':profile,
    'firstName': firstName,
    'lastName': lastName,
    'userName': userName,
    'email': email,
    'mobile': mobile,
    'password': password,
    'confirmPassword': confirmPassword,
  };
}
