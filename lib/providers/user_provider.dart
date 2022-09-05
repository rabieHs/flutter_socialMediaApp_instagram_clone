import 'package:flutter/material.dart';
import 'package:socialnetworkapp/models/user.dart';
import 'package:socialnetworkapp/resources/auth.methods.dart';

class UserProvider with ChangeNotifier{
  AuthMethods _authMethods = AuthMethods();
  User? _user;
  User get getUser => _user!;
  Future<void> refreshUser() async{
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();

  }

}