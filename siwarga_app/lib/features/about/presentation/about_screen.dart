import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../auth/application/auth_providers.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Tentang')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            AppConstants.appName,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const Text(
            'Versi 2.0 (Flutter + Firebase)',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(profile?.nama ?? '-'),
            subtitle: Text(profile?.email ?? ''),
          ),
          ListTile(
            leading: const Icon(Icons.badge),
            title: Text(profile?.role ?? '-'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Profil & pengaturan'),
            onTap: () => context.push('/profile'),
          ),
          if (profile?.isAdmin ?? false)
            ListTile(
              leading: const Icon(Icons.person_add_alt),
              title: const Text('Daftarkan akun warga'),
              onTap: () => context.push('/register'),
            ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Keluar'),
            onTap: () async {
              await ref.read(authRepositoryProvider).signOut();
              if (context.mounted) context.go('/login');
            },
          ),
          const SizedBox(height: 24),
          Text(
            'SiWarga meningkatkan keamanan dan komunikasi warga RT. '
            'Untuk bantuan hubungi pengurus RT.',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
