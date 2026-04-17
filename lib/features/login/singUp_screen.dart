// ignore_for_file: deprecated_member_use, unused_import
import 'package:comet/core/theme/app_colors.dart';
import 'package:comet/features/login/sinUpController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:comet/core/routing/app_router.dart';
import 'package:comet/features/login/singUp_screen.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());

    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      body: Stack(
        children: [
          Positioned(
            top: -50.h,
            right: -80.w,
            child: _buildBlurCircle(
              300,
              AppColors.secondaryNeon.withOpacity(0.08),
            ),
          ),
          Positioned(
            bottom: -40.h,
            left: -60.w,
            child: _buildBlurCircle(
              250,
              AppColors.vibrantEnd.withOpacity(0.12),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  _buildLogoSection(),
                  SizedBox(height: 35.h),

                  _buildInputLabel("FULL NAME"),
                  Obx(
                    () => _buildCustomTextField(
                      hint: "Stellar Voyager",
                      icon: Icons.person_outline,
                      controller: controller.nameController,
                      errorText: controller.nameError.value,
                    ),
                  ),
                  SizedBox(height: 18.h),

                  _buildInputLabel("EMAIL/PHONE"),
                  Obx(
                    () => _buildCustomTextField(
                      hint: "hello@comet.io",
                      icon: Icons.alternate_email,
                      controller: controller.emailController,
                      errorText: controller.emailError.value,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  _buildInputLabel("PASSWORD"),
                  Obx(
                    () => _buildCustomTextField(
                      hint: "••••••••",
                      icon: Icons.lock_outline,
                      controller: controller.passwordController,
                      errorText: controller.passwordError.value,
                      obscureText: controller.isPasswordObscured.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordObscured.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey,
                          size: 20.sp,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),

                  _buildInputLabel("CONFIRM PASSWORD"),
                  Obx(
                    () => _buildCustomTextField(
                      hint: "••••••••",
                      icon: Icons.verified_user_outlined,
                      controller: controller.confirmPasswordController,
                      errorText: controller.confirmError.value,
                      obscureText: controller.isConfirmPasswordObscured.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isConfirmPasswordObscured.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey,
                          size: 20.sp,
                        ),
                        onPressed: controller.toggleConfirmVisibility,
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),

                  Obx(
                    () => _buildGradientButton(
                      text: "Sign Up",
                      isLoading: controller.isLoading.value,
                      onTap: controller.signUp,
                    ),
                  ),

                  SizedBox(height: 40.h),
                  _buildLoginLink(),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurCircle(double size, Color color) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        Image.asset('assets/logo.png', height: 150.h, fit: BoxFit.contain),
        SizedBox(height: 25.h),
        Text(
          "Join the Galaxy",
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            "Experience a high-end editorial social space curated for the visionary.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.darkblue.withOpacity(0.8),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.darkblue.withOpacity(0.7),
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    String errorText = "",
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    bool hasError = errorText.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: TextStyle(fontSize: 15.sp, color: AppColors.onSurfaceColor),
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(
                icon,
                color: hasError ? Colors.red : AppColors.textGrey,
                size: 22.sp,
              ),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: AppColors.babyblue,
              contentPadding: EdgeInsets.symmetric(
                vertical: 18.h,
                horizontal: 16.w,
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28.r),
                borderSide: hasError
                    ? const BorderSide(color: Colors.red, width: 1.5)
                    : BorderSide.none,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28.r),
                borderSide: hasError
                    ? const BorderSide(color: Colors.red, width: 1.5)
                    : BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28.r),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : AppColors.purpule01,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: EdgeInsets.only(left: 15.w, top: 5.h),
            child: Text(
              errorText,
              style: TextStyle(color: Colors.red, fontSize: 10.sp),
            ),
          ),
      ],
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
        height: 56.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.r),
          gradient: const LinearGradient(
            colors: [AppColors.secondaryNeon, AppColors.primaryNeon],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondaryNeon.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 24.h,
                  width: 24.h,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
        ),
        GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.login),
          child: Text(
            "Log In",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
