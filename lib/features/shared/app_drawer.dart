import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../auth/auth_service.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import '../booking/book_screen.dart';
import '../booking/my_bookings_screen.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../reviews/reviews_screen.dart';
import '../services/service_screen.dart';

/// القائمة الجانبية. تُقرأ حالة الدخول عند فتحها، ولا تتطلب مكتبات إضافية.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).pop(); // إغلاق القائمة
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  void _home(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  void _loginFor(BuildContext context, Widget destination) {
    // شاشة الدخول الحالية لا تعيد نتيجة؛ بعد نجاح الدخول سيظهر Home.
    // يُمكن للعميل فتح الوجهة من القائمة لاحقًا.
    if (!AuthService().isLoggedIn) {
      _open(context, const LoginScreen());
    } else {
      _open(context, destination);
    }
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل تريد تسجيل الخروج من حسابك؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    AuthService().logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;
    final loggedIn = user != null;

    return Drawer(
      backgroundColor: AppColors.dark2,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
              decoration: const BoxDecoration(
                color: AppColors.black,
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/gold2.jpeg',
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const CircleAvatar(
                        radius: 36,
                        backgroundColor: AppColors.dark3,
                        child: Icon(
                          Icons.local_car_wash,
                          color: AppColors.gold,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'مغسلة البرنس',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),

                  Text(
                    AuthService().isLoggedIn
                        ? 'أهلًا، ${AuthService().currentUser?.name ?? ''}'
                        : 'أهلًا بك، زائرنا',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  _item(Icons.home_outlined, 'الرئيسية', () => _home(context)),
                  _item(
                    Icons.local_car_wash_outlined,
                    'الخدمات والأسعار',
                    () => _open(context, const ServicesScreen()),
                  ),
                  _item(
                    Icons.event_available_outlined,
                    'حجز جديد',
                    () => _open(context, const BookScreen()),
                  ),
                  _item(
                    Icons.calendar_month_outlined,
                    'حجوزاتي',
                    () => _loginFor(context, const MyBookingsScreen()),
                  ),
                  _item(
                    Icons.star_border_rounded,
                    'التقييمات والآراء',
                    () => _open(context, const ReviewsScreen()),
                  ),
                  const Divider(
                    color: AppColors.border,
                    height: 24,
                    indent: 18,
                    endIndent: 18,
                  ),
                  if (loggedIn)
                    _item(
                      Icons.person_outline,
                      'الملف الشخصي',
                      () => _open(context, const ProfileScreen()),
                    )
                  else ...[
                    _item(
                      Icons.login_rounded,
                      'تسجيل الدخول',
                      () => _open(context, const LoginScreen()),
                    ),
                    _item(
                      Icons.person_add_alt_outlined,
                      'إنشاء حساب',
                      () => _open(context, const RegisterScreen()),
                    ),
                  ],
                ],
              ),
            ),
            if (loggedIn)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
                child: _item(
                  Icons.logout,
                  'تسجيل الخروج',
                  () => _logout(context),
                  isDanger: true,
                ),
              ),
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Al-Prince Car Wash',
                style: TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDanger = false,
  }) {
    final color = isDanger ? AppColors.red : AppColors.text;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 22),
      leading: Icon(icon, color: isDanger ? AppColors.red : AppColors.gold),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
