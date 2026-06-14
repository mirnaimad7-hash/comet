// ignore_for_file: unused_import, unused_field

import 'package:comet/features/profile/edit_profile_page.dart';
import 'package:comet/home/home.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController controller = Get.put(ProfileController());
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    controller.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(),
          const SizedBox(height: 55),
          _buildIdentity(),
          _buildStats(),
          _buildPrivacyBox(),
          _buildTabs(),
          _buildPhotoGrid(),
          _buildWatermark(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E1E2C), Color(0xFF4B2A85)],
            ),
          ),
          child: Obx(() {
            return controller.coverPath.isNotEmpty
                ? Image.file(
                    File(controller.coverPath.value),
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDLsbNqbOS8NI2Sn2TZkoE2rUVgDNz2vejbkILmUwTjuPzHc1jpsTEcdgvZ0HEvsLk12w0ra0timVoqX3D8GCCSfDILFphuEuPSzbrn9Y2qxhhdppaTXQDhvDBLM6dy_Mj0u5NVYI8CD99gaSUycBH9jXE5fHfgvy4ENjGshN727oeizTH1NFvRGTKmopeiSxH2jacAJKPaNZ4oz6Vl0ZtbyfEUQPE8qmgKTOYpfdFuY6A_E8wayYCiaUgNju03PMspUu7_rLfiBQT5',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: const Color(0xFF4B2A85)),
                  );
          }),
        ),

        Positioned(
          top: 40,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.3),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Home()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.3),
                child: IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),

        Positioned(
          bottom: -40,
          left: 20,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF6B46C0), Color(0xFF8E5EFF)],
              ),
            ),
            child: Obx(() {
              return CircleAvatar(
                radius: 44,
                backgroundColor: Colors.white,
                backgroundImage: controller.avatarPath.isNotEmpty
                    ? FileImage(File(controller.avatarPath.value))
                    : const NetworkImage(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuDg0UqDRVrh8Uir7dGiDjAUEgEgskwZuspT2b2wjLloLq5TJcz_0PkoEklUcjDEte78r3vr4VjGlwQOxe7xfaVt4qHmoQDCtmKfXEMgu1M8dg5rKN60wBRUi_lKLzFlkR1pb5rn-r0F0Ka8IxNuXJHgBsaMlJXFQm8-Qlb8VZ-bhxl8eQdjHYXUBvI3nrvQOiJ7FNIKo_2bysk7l-UcIG5oqSs14BgSwW-zu2jXEa6E-W776oRsURf4QCDkut0Kmkmcacq5u9nq0wwr',
                          )
                          as ImageProvider,
              );
            }),
          ),
        ),

        Positioned(
          bottom: 10,
          right: 20,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              bool? updated = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
              if (updated == true) {
                controller.loadData();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B46C0), Color(0xFF8E5EFF)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIdentity() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.displayName.value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B1C30),
              ),
            ),
            Text(
              '@${controller.username.value}',
              style: const TextStyle(color: Color(0xFF494453), fontSize: 16),
            ),
            const SizedBox(height: 15),
            Text(
              controller.bio.value,
              style: const TextStyle(
                color: Color(0xFF494453),
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStats() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          _StatColumn(value: '128', label: 'POSTS'),
          SizedBox(width: 40),
          _StatColumn(value: '14.2k', label: 'FOLLOWERS'),
          SizedBox(width: 40),
          _StatColumn(value: '842', label: 'FOLLOWING'),
        ],
      ),
    );
  }

  Widget _buildPrivacyBox() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.visibility_off, color: Color(0xFF6B46C0)),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy Mode',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0B1C30),
                  ),
                ),
                Text(
                  'Profile visible to followers only',
                  style: TextStyle(color: Color(0xFF494453), fontSize: 11),
                ),
              ],
            ),
          ),
          Obx(() {
            return Switch(
              value: controller.isPrivacyMode.value,
              activeThumbColor: const Color(0xFF6B46C0),
              activeTrackColor: const Color(0xFF6B46C0).withValues(alpha: 0.5),
              onChanged: (bool value) async {
                await controller.togglePrivacy(value);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF6B46C0), width: 2),
              ),
            ),
            child: const Text(
              'Posts',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B46C0),
              ),
            ),
          ),
          const SizedBox(width: 30),
          const Text(
            'Media',
            style: TextStyle(
              color: Color(0xFF7A7484),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 30),
          const Text(
            'Tagged',
            style: TextStyle(
              color: Color(0xFF7A7484),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(1),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemCount: 9,
      itemBuilder: (context, index) => Container(
        color: Colors.grey[200],
        child: Image.network(
          'https://picsum.photos/id/${index + 20}/400/400',
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) =>
              const Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildWatermark() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Text(
          'COMET',
          style: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.w900,
            color: Color(0x0A000000),
            letterSpacing: -2,
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String value, label;
  const _StatColumn({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B1C30),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF7A7484),
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
