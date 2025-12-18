import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../services/product_service.dart';
import '../theme/app_colors.dart';

class AddEditProductScreen extends StatefulWidget {
  final ProductModel? product;
  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final _title = TextEditingController();
  final _brand = TextEditingController();
  final _category = TextEditingController();
  final _image = TextEditingController();
  final _price = TextEditingController();
  final _stock = TextEditingController();

  final service = ProductService();

  bool _saving = false;

  // ✅ أقسام جاهزة (نفس اللي عندك في الرئيسية)
  final List<Map<String, String>> _categories = const [
    {'id': 'screens', 'name': 'شاشات'},
    {'id': 'phones', 'name': 'هواتف'},
    {'id': 'consoles', 'name': 'ألعاب'},
    {'id': 'other', 'name': 'أخرى'},
  ];

  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    if (p != null) {
      _title.text = p.title;
      _brand.text = p.brand;
      _category.text = p.category;
      _image.text = p.image;
      _price.text = p.price.toString();
      _stock.text = p.stock.toString();

      // حاول يطابق category مع القائمة
      final match = _categories.any((c) => c['id'] == p.category);
      _selectedCategoryId = match ? p.category : 'other';
    } else {
      _selectedCategoryId = _categories.first['id'];
      _category.text = _selectedCategoryId ?? '';
    }

    // لو اختار other نخلي الcategory مكتوب يدوي
    if (_selectedCategoryId != null && _selectedCategoryId != 'other') {
      _category.text = _selectedCategoryId!;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _brand.dispose();
    _category.dispose();
    _image.dispose();
    _price.dispose();
    _stock.dispose();
    super.dispose();
  }

  InputDecoration _dec({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.white70),
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: const TextStyle(color: AppColors.textMuted),
      filled: true,
      fillColor: AppColors.cardDark,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.borderSoft),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
      ),
    );
  }

  Future<void> save() async {
    if (_saving) return;
    if (!_formKey.currentState!.validate()) return;

    final price = int.tryParse(_price.text.trim());
    final stock = int.tryParse(_stock.text.trim());

    if (price == null || stock == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('السعر والكمية لازم يكونوا أرقام فقط')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final p = ProductModel(
        id: widget.product?.id ?? '',
        title: _title.text.trim(),
        brand: _brand.text.trim(),
        category: _category.text.trim(),
        image: _image.text.trim(),
        price: price,
        stock: stock,
      );

      if (widget.product == null) {
        await service.addProduct(p);
      } else {
        await service.updateProduct(p);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.product == null ? 'تمت إضافة المنتج ✅' : 'تم حفظ التعديل ✅',
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('صار خطأ: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldDark,
        appBar: AppBar(
          backgroundColor: AppColors.scaffoldDark,
          elevation: 0,
          centerTitle: true,
          title: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFF6A00), Color(0xFFFFC107)],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ).createShader(bounds),
            child: Text(
              isEdit ? 'تعديل منتج' : 'إضافة منتج',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ✅ Header Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6A00), Color(0xFFFFC107)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isEdit ? Icons.edit_rounded : Icons.add_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isEdit
                            ? 'عدّل بيانات المنتج وبعدين اضغط حفظ'
                            : 'عبّي بيانات المنتج وبعدين اضغط إضافة',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ✅ Preview Card
              _PreviewCard(imageName: _image.text.trim()),
              const SizedBox(height: 14),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _fieldCard(
                      child: TextFormField(
                        controller: _title,
                        style: const TextStyle(color: Colors.white),
                        decoration: _dec(
                          label: 'العنوان',
                          icon: Icons.title_rounded,
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _fieldCard(
                      child: TextFormField(
                        controller: _brand,
                        style: const TextStyle(color: Colors.white),
                        decoration: _dec(
                          label: 'العلامة',
                          icon: Icons.business_rounded,
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ✅ Category dropdown
                    _fieldCard(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategoryId,
                        dropdownColor: AppColors.cardDark,
                        iconEnabledColor: Colors.white70,
                        decoration: _dec(
                          label: 'القسم',
                          icon: Icons.category_outlined,
                          hint: 'اختر القسم',
                        ),
                        items: _categories
                            .map(
                              (c) => DropdownMenuItem<String>(
                                value: c['id'],
                                child: Text(
                                  c['name']!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            _selectedCategoryId = v;
                            if (v != null && v != 'other') {
                              _category.text = v;
                            } else {
                              _category.text = '';
                            }
                          });
                        },
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'مطلوب';
                          return null;
                        },
                      ),
                    ),

                    // لو other نخلي إدخال يدوي للقسم
                    if (_selectedCategoryId == 'other') ...[
                      const SizedBox(height: 12),
                      _fieldCard(
                        child: TextFormField(
                          controller: _category,
                          style: const TextStyle(color: Colors.white),
                          decoration: _dec(
                            label: 'اسم القسم (يدوي)',
                            icon: Icons.edit_note_rounded,
                            hint: 'مثال: accessories',
                          ),
                          validator: (v) =>
                              (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

                    _fieldCard(
                      child: TextFormField(
                        controller: _image,
                        style: const TextStyle(color: Colors.white),
                        decoration: _dec(
                          label: 'اسم الصورة',
                          icon: Icons.image_outlined,
                          hint: 'مثال: phone3.png',
                        ),
                        onChanged: (_) => setState(() {}),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _fieldCard(
                            child: TextFormField(
                              controller: _price,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              decoration: _dec(
                                label: 'السعر',
                                icon: Icons.payments_outlined,
                                hint: 'بالدينار',
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return 'مطلوب';
                                if (int.tryParse(v.trim()) == null)
                                  return 'لازم رقم';
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _fieldCard(
                            child: TextFormField(
                              controller: _stock,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.white),
                              decoration: _dec(
                                label: 'الكمية',
                                icon: Icons.inventory_2_outlined,
                                hint: 'stock',
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return 'مطلوب';
                                final n = int.tryParse(v.trim());
                                if (n == null) return 'لازم رقم';
                                if (n < 0) return 'مينفعش سالب';
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _saving ? null : save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6A00), Color(0xFFFFC107)],
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 16,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: _saving
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.4,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    isEdit ? 'حفظ التعديل' : 'إضافة المنتج',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      'ملاحظة: تأكد إن الصورة موجودة في assets/images/ وبنفس الاسم.',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 14,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _PreviewCard extends StatelessWidget {
  final String imageName;
  const _PreviewCard({required this.imageName});

  @override
  Widget build(BuildContext context) {
    final hasName = imageName.trim().isNotEmpty;
    final path = "assets/images/$imageName";

    return Container(
      height: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'معاينة الصورة',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  hasName ? imageName : 'اكتب اسم الصورة باش نشوفها هنا',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white.withOpacity(0.12)),
                  ),
                  child: const Text(
                    'assets/images/',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 120,
              height: 120,
              color: Colors.black.withOpacity(0.12),
              child: hasName
                  ? Image.asset(
                      path,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.white54,
                        ),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.image_outlined, color: Colors.white54),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
