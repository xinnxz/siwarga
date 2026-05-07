import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../auth/application/auth_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nama = TextEditingController();
  final _hp = TextEditingController();
  final _rumah = TextEditingController();
  final _passLama = TextEditingController();
  final _passBaru = TextEditingController();
  bool _seeded = false;

  @override
  void dispose() {
    _nama.dispose();
    _hp.dispose();
    _rumah.dispose();
    _passLama.dispose();
    _passBaru.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final user = ref.watch(authStateProvider).valueOrNull;

    if (!_seeded && profile != null) {
      _nama.text = profile.nama;
      _hp.text = profile.noHp ?? '';
      _rumah.text = profile.nomorRumah ?? '';
      _seeded = true;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            user?.email ?? '',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          AppTextField(controller: _nama, label: 'Nama'),
          AppTextField(controller: _hp, label: 'No HP', keyboardType: TextInputType.phone),
          AppTextField(controller: _rumah, label: 'No rumah'),
          AppButton(
            label: 'Simpan profil',
            onPressed: user == null
                ? null
                : () async {
                    await ref.read(authRepositoryProvider).updateProfile(
                          uid: user.uid,
                          nama: _nama.text.trim(),
                          noHp: _hp.text.trim(),
                          nomorRumah: _rumah.text.trim(),
                        );
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profil diperbarui.')),
                      );
                    }
                  },
          ),
          const Divider(height: 48),
          Text(
            'Ganti password',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          AppTextField(
            controller: _passLama,
            label: 'Password saat ini',
            obscure: true,
          ),
          AppTextField(
            controller: _passBaru,
            label: 'Password baru',
            obscure: true,
          ),
          AppButton(
            label: 'Update password',
            onPressed: () async {
              try {
                await ref.read(authRepositoryProvider).updatePassword(
                      currentPassword: _passLama.text,
                      newPassword: _passBaru.text,
                    );
                _passLama.clear();
                _passBaru.clear();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password diganti.')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$e')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
