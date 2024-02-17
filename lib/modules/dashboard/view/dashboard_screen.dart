import 'package:flutter/material.dart';
import 'package:login/modules/login/view/login_screen.dart';
import 'package:login/utils/app_utils.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("Log Out"),
          onPressed: () {
            AppUtils.setToken('');
            AppUtils.setUserId('');
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false);
          },
        ),
      ),
    );
  }
}
