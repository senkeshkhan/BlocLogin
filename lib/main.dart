import 'package:flutter/material.dart';
import 'package:login/modules/dashboard/view/dashboard_screen.dart';
import 'package:login/modules/login/view/login_screen.dart';
import 'package:login/utils/app_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final haveToken = (await AppUtils.getToken()).isNotEmpty;
  runApp(MyApp(
      firstWidget: haveToken ? const DashboardScreen() : const LoginScreen()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.firstWidget});
  final Widget firstWidget;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: firstWidget,
    );
  }
}
