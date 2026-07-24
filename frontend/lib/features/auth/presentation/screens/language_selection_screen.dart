import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/core/theme/app_theme.dart';
import 'package:krishios/shared/presentation/providers/language_provider.dart';
import 'package:krishios/shared/services/translation_service.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends ConsumerState<LanguageSelectionScreen> {
  String _selectedLang = 'en';

  final List<Map<String, String>> _langs = [
    {'code': 'en', 'name': 'English', 'native': 'English'},
    {'code': 'hi', 'name': 'Hindi', 'native': 'हिन्दी'},
    {'code': 'te', 'name': 'Telugu', 'native': 'తెలుగు'},
    {'code': 'ta', 'name': 'Tamil', 'native': 'தமிழ்'},
    {'code': 'kn', 'name': 'Kannada', 'native': 'ಕನ್ನಡ'},
    {'code': 'mr', 'name': 'Marathi', 'native': 'मराठी'},
    {'code': 'bn', 'name': 'Bengali', 'native': 'বাংলা'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedLang = ref.read(languageProvider);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
               Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/brand/app_icon.png',
                    width: 96,
                    height: 96,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'KrishiOS',
                  style: AppTextStyles.headlineLg.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Choose your language / भाषा चुनें / భాషను ఎంచుకోండి',
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: _langs.length,
                  itemBuilder: (context, index) {
                    final lang = _langs[index];
                    final code = lang['code']!;
                    final isSelected = _selectedLang == code;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedLang = code;
                          });
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.08)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.outlineVariant.withValues(alpha: 0.5),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                lang['native']!,
                                style: AppTextStyles.bodyLg.copyWith(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? AppColors.primary : AppColors.onSurface,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '(${lang['name']!})',
                                style: AppTextStyles.bodySm.copyWith(
                                  color: AppColors.outline,
                                ),
                              ),
                              const Spacer(),
                              if (isSelected)
                                 Icon(
                                  Icons.check_circle,
                                  color: AppColors.primary,
                                )
                              else
                                Icon(
                                  Icons.circle_outlined,
                                  color: AppColors.outlineVariant,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(languageProvider.notifier).setLanguage(_selectedLang);
                    if (kDebugMode) {
                      ref.read(debugLanguageBypassProvider.notifier).state = true;
                    }
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    TranslationService.translate('Continue', _selectedLang),
                    style: AppTextStyles.labelMd.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
