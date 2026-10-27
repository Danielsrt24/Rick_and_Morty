import 'package:flutter/material.dart';
import '../models/user.dart';
import 'welcome_screen.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WelcomeScreen(user: user);
  }
}