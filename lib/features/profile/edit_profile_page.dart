// ignore_for_file: unused_import, unused_field

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'profile_controller.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ProfileController controller = Get.put(ProfileController());

  File? _avatarImage;
  File? _coverImage;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String _selectedGender = 'Female';

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  Future<void> _loadCurrentData() async {
    // تحميل البيانات من الكنترولر مباشرة لملء الـ Controllers حقت الواجهة
    setState(() {
      if (controller.avatarPath.isNotEmpty) {
        _avatarImage = File(controller.avatarPath.value);
      }
      if (controller.coverPath.isNotEmpty) {
        _coverImage = File(controller.coverPath.value);
      }

      _nameController.text = controller.displayName.value;
      _usernameController.text = controller.username.value;
      _bioController.text = controller.bio.value;
      _emailController.text = controller.email.value;
      _phoneController.text = controller.phone.value;
      _dobController.text = controller.dob.value;
      _selectedGender = controller.selectedGender.value;
    });
  }

  Future<void> _saveData() async {
    await controller.saveData(
      name: _nameController.text,
      uname: _usernameController.text,
      ubio: _bioController.text,
      uemail: _emailController.text,
      uphone: _phoneController.text,
      udob: _dobController.text,
      gender: _selectedGender,
    );

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم حفظ التعديلات بنجاح!')));
      Navigator.pop(context, true);
    }
  }

  Future<void> _pickAvatar() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      setState(() {
        _avatarImage = File(pickedFile.path);
      });
      await controller.updateAvatar(pickedFile.path);
    }
  }

  Future<void> _pickCover() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      setState(() {
        _coverImage = File(pickedFile.path);
      });
      await controller.updateCover(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0B1C30)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xFF0B1C30),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: _saveData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B46C0),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      GestureDetector(
                        onTapDown: (_) => _pickCover(),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          height: 130,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF4FF),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(
                                0xFF6B46C0,
                              ).withValues(alpha: 0.2),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Obx(() {
                              return controller.coverPath.isNotEmpty
                                  ? Image.file(
                                      File(controller.coverPath.value),
                                      fit: BoxFit.cover,
                                    )
                                  : const Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.photo,
                                            color: Color(0xFF6B46C0),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Tap to change Cover',
                                            style: TextStyle(
                                              color: Color(0xFF6B46C0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                            }),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -40,
                        child: GestureDetector(
                          onTapDown: (_) => _pickAvatar(),
                          behavior: HitTestBehavior.opaque,
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF6B46C0),
                                      Color(0xFF00D4FF),
                                    ],
                                  ),
                                ),
                                child: Obx(() {
                                  return CircleAvatar(
                                    radius: 45,
                                    backgroundColor: Colors.white,
                                    backgroundImage:
                                        controller.avatarPath.isNotEmpty
                                        ? FileImage(
                                            File(controller.avatarPath.value),
                                          )
                                        : const NetworkImage(
                                                'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400',
                                              )
                                              as ImageProvider,
                                  );
                                }),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6B46C0),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.photo_camera,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Profile Photo',
                      style: TextStyle(
                        color: Color(0xFF7A7484),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildInputField('FULL NAME', _nameController, false),
            _buildInputField('USERNAME', _usernameController, true),
            _buildInputField('BIO', _bioController, false, isLongText: true),
            _buildInputField(
              'EMAIL ADDRESS',
              _emailController,
              false,
              keyboardType: TextInputType.emailAddress,
            ),
            _buildInputField(
              'PHONE NUMBER',
              _phoneController,
              false,
              keyboardType: TextInputType.phone,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    'DATE OF BIRTH',
                    _dobController,
                    false,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF4FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'GENDER',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF494453),
                            letterSpacing: 1,
                          ),
                        ),
                        DropdownButton<String>(
                          value: _selectedGender,
                          isExpanded: true,
                          underline: const SizedBox(),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Color(0xFF494453),
                          ),
                          items:
                              <String>[
                                'Female',
                                'Male',
                                'Non-binary',
                                'Prefer not to say',
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      color: Color(0xFF0B1C30),
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedGender = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF4FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.security,
                      color: Color(0xFF6B46C0),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account Security',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF0B1C30),
                          ),
                        ),
                        Text(
                          'Manage passwords & 2FA',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF494453),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Color(0xFF494453)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    bool hasAtPrefix, {
    bool isLongText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF494453),
              letterSpacing: 1,
            ),
          ),
          Row(
            children: [
              if (hasAtPrefix)
                const Padding(
                  padding: EdgeInsets.only(right: 4.0),
                  child: Text(
                    '@',
                    style: TextStyle(
                      color: Color(0xFF6B46C0),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: isLongText ? 3 : 1,
                  keyboardType: keyboardType,
                  style: const TextStyle(
                    color: Color(0xFF0B1C30),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
