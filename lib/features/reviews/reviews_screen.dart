import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../auth/auth_service.dart';
import '../auth/login_screen.dart';

/// Reviews are stored in memory for the UI prototype only.
/// Replace this repository with a backend when API integration begins.
class _Review {
  _Review({
    required this.ownerPhone,
    required this.author,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  final String ownerPhone;
  String author;
  int rating;
  String comment;
  final DateTime createdAt;
}

class _ReviewsStore {
  static final List<_Review> items = [];
}

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int _filter = 0; // 0 means all ratings.

  String? get _ownerPhone => AuthService().currentUser?.phone;

  _Review? get _myReview {
    final phone = _ownerPhone;
    if (phone == null) return null;
    for (final review in _ReviewsStore.items) {
      if (review.ownerPhone == phone) return review;
    }
    return null;
  }

  String _dateLabel(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }

  Future<void> _openReviewEditor({_Review? existing}) async {
    if (!AuthService().isLoggedIn) {
      final goToLogin = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('تسجيل الدخول مطلوب'),
          content: const Text(
            'يمكنك قراءة جميع الآراء بدون حساب. لإضافة تقييم، سجل دخولك أولًا ثم ارجع إلى صفحة التقييمات.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('لاحقًا'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('تسجيل الدخول'),
            ),
          ],
        ),
      );
      if (!mounted || goToLogin != true) return;
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      if (mounted) setState(() {});
      return;
    }

    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController(text: existing?.comment ?? '');
    int rating = existing?.rating ?? 5;

    try {
      final draft = await showModalBottomSheet<({int rating, String comment})>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: AppColors.dark2,
        builder: (sheetContext) => StatefulBuilder(
          builder: (sheetContext, updateSheet) => Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              MediaQuery.of(sheetContext).viewInsets.bottom + 24,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      existing == null ? 'أضف تقييمك' : 'تعديل تقييمك',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'كيف كانت تجربتك في مغسلة البرنس؟',
                      style: TextStyle(color: AppColors.textLight),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final value = index + 1;
                        return IconButton(
                          tooltip: '$value من 5',
                          onPressed: () => updateSheet(() => rating = value),
                          icon: Icon(
                            value <= rating ? Icons.star : Icons.star_border,
                            color: AppColors.gold,
                            size: 34,
                          ),
                        );
                      }),
                    ),
                    Center(
                      child: Text(
                        '$rating من 5',
                        style: const TextStyle(color: AppColors.goldLight),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: controller,
                      maxLines: 4,
                      maxLength: 500,
                      textInputAction: TextInputAction.newline,
                      decoration: const InputDecoration(
                        labelText: 'رأيك بالخدمة',
                        hintText: 'اكتب تجربتك هنا...',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) return 'اكتب رأيك قبل الإرسال';
                        if (text.length < 5) return 'اكتب 5 أحرف على الأقل';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (formKey.currentState?.validate() != true) return;
                          Navigator.pop(
                            sheetContext,
                            (rating: rating, comment: controller.text.trim()),
                          );
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: Text(existing == null ? 'نشر التقييم' : 'حفظ التعديل'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      if (!mounted || draft == null) return;
      final user = AuthService().currentUser;
      if (user == null) return;

      setState(() {
        if (existing != null && identical(_myReview, existing)) {
          existing.rating = draft.rating;
          existing.comment = draft.comment;
          existing.author = user.name;
        } else if (_myReview == null) {
          _ReviewsStore.items.insert(
            0,
            _Review(
              ownerPhone: user.phone,
              author: user.name,
              rating: draft.rating,
              comment: draft.comment,
              createdAt: DateTime.now(),
            ),
          );
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(existing == null ? 'تم نشر تقييمك' : 'تم تعديل تقييمك')),
      );
    } finally {
      // A bottom sheet completes its pop animation asynchronously; allowing the
      // frame to finish before disposal prevents TextField controller issues.
      WidgetsBinding.instance.addPostFrameCallback((_) => controller.dispose());
    }
  }

  Future<void> _deleteReview(_Review review) async {
    if (!identical(_myReview, review)) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف التقييم'),
        content: const Text('هل تريد حذف تقييمك نهائيًا من هذه الجلسة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('رجوع'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('حذف', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true || !identical(_myReview, review)) return;
    setState(() => _ReviewsStore.items.remove(review));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حذف تقييمك')),
    );
  }

  Widget _stars(int rating, {double size = 19}) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          5,
          (index) => Icon(
            index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
            color: AppColors.gold,
            size: size,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final reviews = _ReviewsStore.items;
    final average = reviews.isEmpty
        ? 0.0
        : reviews.fold<int>(0, (sum, r) => sum + r.rating) / reviews.length;
    final visible = reviews
        .where((r) => _filter == 0 || r.rating == _filter)
        .toList(growable: false);
    final mine = _myReview;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('التقييمات والآراء'),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.dark2,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const Text(
                    'آراء عملائنا',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    reviews.isEmpty ? '—' : average.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gold,
                    ),
                  ),
                  _stars(reviews.isEmpty ? 0 : average.round(), size: 26),
                  const SizedBox(height: 8),
                  Text(
                    reviews.isEmpty
                        ? 'لا توجد تقييمات حتى الآن'
                        : 'بناءً على ${reviews.length} تقييم',
                    style: const TextStyle(color: AppColors.textLight),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openReviewEditor(existing: mine),
                      icon: Icon(mine == null ? Icons.rate_review_outlined : Icons.edit_outlined),
                      label: Text(mine == null ? 'أضف تقييمك' : 'عدّل تقييمك'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'تقييمات العملاء',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterChip(0, 'الكل'),
                  for (var stars = 5; stars >= 1; stars--)
                    _filterChip(stars, '$stars ★'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (visible.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Column(
                  children: [
                    const Icon(
                      Icons.reviews_outlined,
                      color: AppColors.textMuted,
                      size: 58,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      reviews.isEmpty
                          ? 'كن أول من يشارك تجربته معنا'
                          : 'لا توجد تقييمات بهذا التصنيف',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textLight),
                    ),
                  ],
                ),
              )
            else
              ...visible.map((review) => _reviewCard(review)),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(int rating, String label) => Padding(
        padding: const EdgeInsetsDirectional.only(end: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: _filter == rating,
          onSelected: (_) => setState(() => _filter = rating),
          selectedColor: AppColors.gold,
          labelStyle: TextStyle(
            color: _filter == rating ? AppColors.black : AppColors.textLight,
          ),
        ),
      );

  Widget _reviewCard(_Review review) {
    final isMine = identical(_myReview, review);
    return Card(
      color: AppColors.dark2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.dark4,
                  child: const Icon(Icons.person_outline, color: AppColors.gold),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    review.author,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  _dateLabel(review.createdAt),
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _stars(review.rating),
            const SizedBox(height: 12),
            Text(review.comment, style: const TextStyle(color: AppColors.textLight)),
            if (isMine) ...[
              const Divider(height: 24),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => _openReviewEditor(existing: review),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('تعديل'),
                  ),
                  TextButton.icon(
                    onPressed: () => _deleteReview(review),
                    icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.red),
                    label: const Text('حذف', style: TextStyle(color: AppColors.red)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
