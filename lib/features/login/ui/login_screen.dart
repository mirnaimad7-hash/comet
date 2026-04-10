// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:comet/core/theme/app_colors.dart'; 
import 'package:comet/features/login/loginController.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  
  Widget build(BuildContext context) {
   
final LoginController controller = Get.find<LoginController>();

    return Scaffold(
      backgroundColor: AppColors.surfaceColor, 
      body: Stack(
        children: [
          Positioned(
            bottom: 100,
            child: Opacity(
              opacity: 0.05,
              child: Transform.rotate(
                angle: -0.2,
                child: Text(
                  'Comet',
                  style: TextStyle(
                    fontSize: 150,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.vibrantStart, AppColors.purple],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.3),
                          blurRadius: 15,
                        )
                      ],
                    ),
                    child: const Icon(Icons.flare, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Comet',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome Back!',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Please enter your details to continue',
                          style: TextStyle(color: Colors.black.withOpacity(0.5)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  _buildTextField(hint: 'Email or Phone',
  textController: controller.emailController,),
                  const SizedBox(height: 20),
                  
                  Obx(() => _buildTextField(
                    hint: 'Password',
  textController: controller.passwordController,
                    isPassword: true,
                    obscureText: !controller.isPasswordVisible.value,
                    onIconTap: controller.togglePasswordVisibility,
                    icon: controller.isPasswordVisible.value 
                        ? Icons.visibility 
                        : Icons.visibility_off,
                  )),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text('Forgot Password?', 
                        style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildGradientButton(text: 'Log In', onTap: controller.login),

                  const SizedBox(height: 30),
                  _buildSeparator(),
                  const SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(child: _buildSocialButton(label: 'Google', icon: Icons.g_mobiledata)),
                      const SizedBox(width: 20),
                      Expanded(child: _buildSocialButton(label: 'Apple', icon: Icons.apple)),
                    ],
                  ),
                  
                  const SizedBox(height: 50),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {}, 
                        child: Text("Sign Up", style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildTextField({
  required String hint, 
  required TextEditingController textController, //  السطر لاستلام المتحكم
  bool isPassword = false, 
  bool obscureText = false, 
  IconData? icon, 
  VoidCallback? onIconTap
}) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.surfaceColor,
      borderRadius: BorderRadius.circular(15),
    ),
    child: TextField(
      controller: textController, //للربط!
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        suffixIcon: isPassword 
            ? IconButton(icon: Icon(icon, color: Colors.grey), onPressed: onIconTap) 
            : null,
      ),
    ),
  );
}

  Widget _buildGradientButton({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.vibrantStart,  AppColors.purple]),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: AppColors.vibrantStart.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Center(
          child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.withOpacity(0.3))),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("OR CONTINUE WITH", style: TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 1)),
        ),
        Expanded(child: Divider(color: Colors.grey.withOpacity(0.3))),
      ],
    );
  }

  Widget _buildSocialButton({required String label, required IconData icon}) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}