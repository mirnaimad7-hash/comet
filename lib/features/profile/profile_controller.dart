import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var displayName = 'Julianne V. Sterling'.obs;
  var username = 'julianne_star'.obs;
  var bio = 'Digital curator of celestial moments...'.obs;
  var email = 'j.sterling@comet.curator'.obs;
  var phone = '+1 (555) 890-4412'.obs;
  var dob = '12 / 04 / 1996'.obs;
  var selectedGender = 'Female'.obs;
  var isPrivacyMode = true.obs;

  var avatarPath = ''.obs;
  var coverPath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    avatarPath.value = prefs.getString('avatar_path') ?? '';
    coverPath.value = prefs.getString('cover_path') ?? '';
    displayName.value = prefs.getString('user_name') ?? 'Julianne V. Sterling';
    username.value = prefs.getString('username') ?? 'julianne_star';
    bio.value =
        prefs.getString('bio') ??
        'Digital curator of celestial moments. Exploring the intersection of high fashion and cosmic aesthetics. Based in NYC.';
    email.value = prefs.getString('email') ?? 'j.sterling@comet.curator';
    phone.value = prefs.getString('phone') ?? '+1 (555) 890-4412';
    dob.value = prefs.getString('dob') ?? '12 / 04 / 1996';
    selectedGender.value = prefs.getString('gender') ?? 'Female';
    isPrivacyMode.value = prefs.getBool('privacy_mode') ?? true;
  }

  Future<void> saveData({
    required String name,
    required String uname,
    required String ubio,
    required String uemail,
    required String uphone,
    required String udob,
    required String gender,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('username', uname);
    await prefs.setString('bio', ubio);
    await prefs.setString('email', uemail);
    await prefs.setString('phone', uphone);
    await prefs.setString('dob', udob);
    await prefs.setString('gender', gender);

    displayName.value = name;
    username.value = uname;
    bio.value = ubio;
    email.value = uemail;
    phone.value = uphone;
    dob.value = udob;
    selectedGender.value = gender;
  }

  Future<void> updateAvatar(String path) async {
    final prefs = await SharedPreferences.getInstance();
    avatarPath.value = path;
    await prefs.setString('avatar_path', path);
  }

  Future<void> updateCover(String path) async {
    final prefs = await SharedPreferences.getInstance();
    coverPath.value = path;
    await prefs.setString('cover_path', path);
  }

  Future<void> togglePrivacy(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    isPrivacyMode.value = value;
    await prefs.setBool('privacy_mode', value);
  }
}
