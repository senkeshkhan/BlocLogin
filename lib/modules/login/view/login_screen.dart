import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/modules/dashboard/view/dashboard_screen.dart';
import 'package:login/modules/login/bloc/login_bloc.dart';
import 'package:login/utils/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textBox("Email", "Enter your email", emailController),
            textBox("Password", "Enter your password", passwordController),
            buttonWidget(),
          ],
        ),
      ),
    );
  }

  BlocProvider<LoginBloc> buttonWidget() {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginUserLoadingState) {
            loading(context);
          } else if (state is LoginUserSuccessState) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const DashboardScreen(),
                ),
                (route) => false);
          } else if (state is LoginUserErrorState) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                showCloseIcon: true,
                closeIconColor: Colors.white,
              ),
            );
          }
        },
        builder: (ctx, state) {
          return GestureDetector(
            onTap: () {
              ctx.read<LoginBloc>().add(
                    LoginUserEvent(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    ),
                  );
            },
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryColors,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Continue",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> loading(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      title: const Text(
        "Login",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
      ),
    );
  }

  Widget textBox(String title, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          BlocProvider(
            create: (context) => LoginBloc(),
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (ctx, state) {
                return TextField(
                  controller: controller,
                  textInputAction: title == "Password"
                      ? TextInputAction.done
                      : TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: hint,
                    suffixIcon: title == "Password"
                        ? changeVisibilityButton(ctx)
                        : null,
                  ),
                  maxLines: 1,
                  obscureText: title == "Password"
                      ? !ctx.read<LoginBloc>().isVisible
                      : false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector changeVisibilityButton(BuildContext ctx) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        ctx.read<LoginBloc>().add(
              ChangeVisibilityEvent(
                isVisible: !ctx.read<LoginBloc>().isVisible,
              ),
            );
      },
      child: Icon(
        ctx.read<LoginBloc>().isVisible
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined,
      ),
    );
  }
}
