// ignore_for_file: unused_element

import 'package:comet/features/login/ui/forgot_passwardController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:comet/core/theme/app_colors.dart';
import 'package:pinput/pinput.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final controller = Get.put(ForgotPasswordController());

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
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
                        borderRadius: BorderRadius.circular(28),
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
        ),
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
          const SizedBox(height: 30),
          _customField(
            "Email Address",
            controller.emailController,
            Icons.email_outlined,
          ),
          const SizedBox(height: 30),
          Obx(
            () => _buildGradientButton(
              text: "Send Code",
              onTap: controller.sendOtp,
              isLoading: controller.isLoading.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpStep() {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: AppColors.babyblue,
        borderRadius: BorderRadius.circular(28),
      ),
    );

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

          Pinput(
            length: 4,
            controller: controller.otpController,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                border: Border.all(color: AppColors.purple, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Obx(
            () => _buildGradientButton(
              text: "Verify Code",
              onTap: controller.verifyOtp,
              isLoading: controller.isLoading.value,
            ),
          ),
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
          const SizedBox(height: 30),
          Obx(
            () => _buildGradientButton(
              text: "Reset Password",
              onTap: controller.resetPassword,
              isLoading: controller.isLoading.value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _customField(
    String hint,
    TextEditingController ctr,
    IconData icon, {
    bool isPass = false,
  }) {
    return TextField(
      controller: ctr,
      obscureText: isPass,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.purple),
        hintText: hint,
        filled: true,
        fillColor: AppColors.babyblue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.vibrantStart, AppColors.purple],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.vibrantStart.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
