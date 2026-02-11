import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';

// Simple preferences provider (can be persisted with shared_preferences)
final whatsappOptInProvider = StateProvider<bool>((ref) => true);
final selectedThemeProvider = StateProvider<String>((ref) => 'light');
final selectedLanguageProvider = StateProvider<String>((ref) => 'english');

class PreferencesScreen extends ConsumerWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final whatsappOptIn = ref.watch(whatsappOptInProvider);
    final selectedTheme = ref.watch(selectedThemeProvider);
    final selectedLanguage = ref.watch(selectedLanguageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Notifications section
          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.chat),
              title: const Text('WhatsApp Notifications'),
              subtitle:
                  const Text('Receive reminders and updates via WhatsApp'),
              value: whatsappOptIn,
              onChanged: (value) {
                ref.read(whatsappOptInProvider.notifier).state = value;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      value
                          ? 'WhatsApp notifications enabled'
                          : 'WhatsApp notifications disabled',
                    ),
                  ),
                );
              },
              activeColor: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 24),

          // Theme section
          const Text(
            'Appearance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                RadioListTile<String>(
                  secondary: const Icon(Icons.light_mode),
                  title: const Text('Light Theme'),
                  value: 'light',
                  groupValue: selectedTheme,
                  onChanged: (value) {
                    ref.read(selectedThemeProvider.notifier).state = value!;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Theme updated to Light')),
                    );
                  },
                  activeColor: AppColors.primaryGreen,
                ),
                RadioListTile<String>(
                  secondary: const Icon(Icons.dark_mode),
                  title: const Text('Dark Theme'),
                  value: 'dark',
                  groupValue: selectedTheme,
                  onChanged: (value) {
                    ref.read(selectedThemeProvider.notifier).state = value!;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Theme updated to Dark (not implemented yet)')),
                    );
                  },
                  activeColor: AppColors.primaryGreen,
                ),
                RadioListTile<String>(
                  secondary: const Icon(Icons.auto_mode),
                  title: const Text('System Default'),
                  value: 'system',
                  groupValue: selectedTheme,
                  onChanged: (value) {
                    ref.read(selectedThemeProvider.notifier).state = value!;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Theme set to System Default')),
                    );
                  },
                  activeColor: AppColors.primaryGreen,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Language section
          const Text(
            'Language',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                RadioListTile<String>(
                  secondary: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
                  title: const Text('English'),
                  value: 'english',
                  groupValue: selectedLanguage,
                  onChanged: (value) {
                    ref.read(selectedLanguageProvider.notifier).state = value!;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Language set to English')),
                    );
                  },
                  activeColor: AppColors.primaryGreen,
                ),
                RadioListTile<String>(
                  secondary: const Text('🇹🇿', style: TextStyle(fontSize: 24)),
                  title: const Text('Swahili'),
                  value: 'swahili',
                  groupValue: selectedLanguage,
                  onChanged: (value) {
                    ref.read(selectedLanguageProvider.notifier).state = value!;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Lugha imewekwa kwa Kiswahili (not implemented yet)')),
                    );
                  },
                  activeColor: AppColors.primaryGreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
