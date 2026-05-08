import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/preference.dart';
import '../riverpod/stunting_food_providers.dart';
import '../widgets/stunting_food_ui.dart';

class PreferencesPage extends ConsumerStatefulWidget {
  final int? predictionId;
  const PreferencesPage({super.key, this.predictionId});

  @override
  ConsumerState<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends ConsumerState<PreferencesPage> {
  final _notesCtrl = TextEditingController();
  String? _budget;
  String? _dietStyle;
  bool _avoidSpicy = false;
  final _preferredCtrl = TextEditingController();
  final _excludedCtrl = TextEditingController();
  final _allergiesCtrl = TextEditingController();
  final _keywordsCtrl = TextEditingController();

  List<String> _splitCsv(String text) => text
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(preferenceProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    _preferredCtrl.dispose();
    _excludedCtrl.dispose();
    _allergiesCtrl.dispose();
    _keywordsCtrl.dispose();
    super.dispose();
  }

  InputDecoration _inputDeco({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: StuntingFoodTypo.body14(color: StuntingFoodColors.textSecondary),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: StuntingFoodColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: StuntingFoodColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: StuntingFoodColors.primaryPink, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(preferenceProvider);

    final pref = state.preference;
    if (_notesCtrl.text.isEmpty && state.loading == false) {
      _notesCtrl.text = pref.notes ?? '';
      _budget = pref.budgetLevel;
      _dietStyle = pref.dietStyle;
      _avoidSpicy = pref.avoidSpicy ?? false;
      _preferredCtrl.text = pref.preferredCategories.join(', ');
      _excludedCtrl.text = pref.excludedCategories.join(', ');
      _allergiesCtrl.text = pref.allergies.join(', ');
      _keywordsCtrl.text = pref.excludedKeywords.join(', ');
    }

    return Scaffold(
      appBar: stuntingAppBar(title: 'Preferensi Makan'),
      body: state.loading
          ? const LoadingShimmerList()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SectionHeader(
                  title: 'Atur preferensi harian',
                  subtitle:
                      'Bantu sistem menyesuaikan rekomendasi makanan sesuai kebutuhan Anda.',
                ),
                const SizedBox(height: 16),
                if (state.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ErrorStateView(
                      title: 'Gagal memuat preferensi',
                      subtitle: state.error!,
                      onRetry: () => ref.read(preferenceProvider.notifier).load(),
                    ),
                  ),

                // Budget
                _buildSection(
                  'Budget',
                  Icons.wallet_outlined,
                  DropdownMenu<String>(
                    initialSelection: _budget,
                    width: double.infinity,
                    textStyle: StuntingFoodTypo.body14(),
                    inputDecorationTheme: InputDecorationTheme(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: StuntingFoodColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: StuntingFoodColors.border),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: 'low', label: 'Hemat'),
                      DropdownMenuEntry(value: 'mid', label: 'Sedang'),
                      DropdownMenuEntry(value: 'high', label: 'Leluasa'),
                    ],
                    onSelected: (v) => setState(() => _budget = v),
                  ),
                ),

                // Diet Style
                _buildSection(
                  'Diet Style',
                  Icons.eco_outlined,
                  DropdownMenu<String>(
                    initialSelection: _dietStyle,
                    width: double.infinity,
                    textStyle: StuntingFoodTypo.body14(),
                    inputDecorationTheme: InputDecorationTheme(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: StuntingFoodColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: StuntingFoodColors.border),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: 'omnivore', label: 'Omnivore'),
                      DropdownMenuEntry(value: 'vegetarian', label: 'Vegetarian'),
                      DropdownMenuEntry(value: 'pescatarian', label: 'Pescatarian'),
                    ],
                    onSelected: (v) => setState(() => _dietStyle = v),
                  ),
                ),

                // Hindari pedas toggle
                AppCard(
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _avoidSpicy,
                    activeThumbColor: StuntingFoodColors.primaryPink,
                    title: Text(
                      'Hindari pedas',
                      style: StuntingFoodTypo.body14(weight: FontWeight.w600),
                    ),
                    onChanged: (v) => setState(() => _avoidSpicy = v),
                  ),
                ),
                const SizedBox(height: 12),

                // Kategori disukai
                _buildSection(
                  'Kategori disukai (pisahkan koma)',
                  Icons.favorite_outline_rounded,
                  TextField(
                    controller: _preferredCtrl,
                    style: StuntingFoodTypo.body14(),
                    decoration: _inputDeco(hint: 'ayam, ikan, telur'),
                  ),
                ),

                // Kategori dihindari
                _buildSection(
                  'Kategori dihindari (pisahkan koma)',
                  Icons.block_outlined,
                  TextField(
                    controller: _excludedCtrl,
                    style: StuntingFoodTypo.body14(),
                    decoration: _inputDeco(hint: 'udang, jeroan'),
                  ),
                ),

                // Alergi
                _buildSection(
                  'Alergi (pisahkan koma)',
                  Icons.warning_amber_outlined,
                  TextField(
                    controller: _allergiesCtrl,
                    style: StuntingFoodTypo.body14(),
                    decoration: _inputDeco(hint: 'kacang, tahu'),
                  ),
                ),

                // Kata kunci dihindari
                _buildSection(
                  'Kata kunci dihindari (pisahkan koma)',
                  Icons.search_off_outlined,
                  TextField(
                    controller: _keywordsCtrl,
                    style: StuntingFoodTypo.body14(),
                    decoration: _inputDeco(hint: 'santan, goreng'),
                  ),
                ),

                // Catatan
                _buildSection(
                  'Catatan',
                  Icons.edit_note_outlined,
                  TextField(
                    controller: _notesCtrl,
                    maxLines: 3,
                    style: StuntingFoodTypo.body14(),
                    decoration: _inputDeco(hint: 'Contoh: tidak suka santan'),
                  ),
                ),

                const SizedBox(height: 16),
                PrimaryButton(
                  text: state.saving ? 'Menyimpan...' : 'Simpan Preferensi',
                  loading: state.saving,
                  onPressed: state.saving
                      ? null
                      : () async {
                          final value = StuntingPreference(
                            budgetLevel: _budget,
                            dietStyle: _dietStyle,
                            avoidSpicy: _avoidSpicy,
                            preferredCategories: _splitCsv(_preferredCtrl.text),
                            excludedCategories: _splitCsv(_excludedCtrl.text),
                            allergies: _splitCsv(_allergiesCtrl.text),
                            excludedKeywords: _splitCsv(_keywordsCtrl.text),
                            notes: _notesCtrl.text.trim(),
                          );

                          if (!value.hasAnyValue) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Isi minimal satu preferensi.'),
                              ),
                            );
                            return;
                          }

                          ref.read(preferenceProvider.notifier).update(value);
                          final ok = await ref.read(preferenceProvider.notifier).save();
                          if (!context.mounted) return;
                          if (ok) {
                            if (widget.predictionId != null) {
                              context.go(
                                '/stunting-food/recommendations',
                                extra: widget.predictionId,
                              );
                            } else {
                              context.pop();
                            }
                          }
                        },
                ),
                const SizedBox(height: 10),
                SecondaryButton(
                  text: 'Nanti saja',
                  onPressed: state.saving ? null : () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 16),
              ],
            ),
    );
  }

  Widget _buildSection(String title, IconData icon, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: StuntingFoodColors.primaryPink),
                const SizedBox(width: 8),
                Text(title, style: StuntingFoodTypo.body14(weight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
