import 'package:comet/features/login/ui/forgot_passwardController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:comet/core/theme/app_colors.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final controller = Get.put(ForgotPasswordController());

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: 8,
                  width: controller.currentStep.value == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: controller.currentStep.value == index
                        ? AppColors.purple
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 30),

          Expanded(
            child: Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: _buildCurrentStep(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (controller.currentStep.value) {
      case 0:
        return _buildEmailStep();
      case 1:
        return _buildOtpStep();
      case 2:
        return _buildNewPasswordStep();
      default:
        return _buildEmailStep();
    }
  }

  Widget _buildEmailStep() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        key: const ValueKey(0),
        children: [
          const Icon(Icons.lock_reset, size: 80, color: AppColors.purple),
          const SizedBox(height: 20),
          const Text(
            "Forgot Password?",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "Enter your email to receive a reset code",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          _customField(
            "Email Address",
            controller.emailController,
            Icons.email_outlined,
          ),
          const SizedBox(height: 20),
          _actionButton("Send Code", controller.sendOtp),
        ],
      ),
    );
  }

  Widget _buildOtpStep() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        key: const ValueKey(1),
        children: [
          const Icon(
            Icons.mark_email_read_outlined,
            size: 80,
            color: Colors.blue,
          ),
          const SizedBox(height: 20),
          const Text(
            "Verify Email",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          _customField(
            "OTP Code",
            controller.otpController,
            Icons.security,
            isOtp: true,
          ),
          const SizedBox(height: 20),
          _actionButton("Verify Code", controller.verifyOtp),
        ],
      ),
    );
  }

  Widget _buildNewPasswordStep() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        key: const ValueKey(2),
        children: [
          const Icon(Icons.vpn_key_outlined, size: 80, color: Colors.green),
          const SizedBox(height: 20),
          const Text(
            "New Password",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          _customField(
            "New Password",
            controller.newPasswordController,
            Icons.lock_outline,
            isPass: true,
          ),
          const SizedBox(height: 20),
          _actionButton("Reset Password", controller.resetPassword),
        ],
      ),
    );
  }

  Widget _customField(
    String hint,
    TextEditingController ctr,
    IconData icon, {
    bool isPass = false,
    bool isOtp = false,
  }) {
    return TextField(
      controller: ctr,
      obscureText: isPass,
      keyboardType: isOtp ? TextInputType.number : TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        filled: true,
        fillColor: AppColors.babyblue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _actionButton(String text, VoidCallback onTap) {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isLoading.value ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.purple,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: controller.isLoading.value
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
      ),
    );
  }
}
