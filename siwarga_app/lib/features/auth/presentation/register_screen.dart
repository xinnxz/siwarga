import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../application/auth_providers.dart';

/// Hanya admin / super_admin boleh membuat akun baru (cek server-side rules juga).
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _nama = TextEditingController();
  final _rumah = TextEditingController();
  final _hp = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String _role = 'warga';

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _nama.dispose();
    _rumah.dispose();
    _hp.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final profile = ref.read(userProfileProvider).valueOrNull;
    if (profile == null || !profile.isAdmin) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hanya admin yang dapat mendaftarkan akun.'),
          ),
        );
      }
      return;
    }

    setState(() => _loading = true);
    try {
      await ref.read(authRepositoryProvider).registerWithEmail(
            email: _email.text,
            password: _password.text,
            nama: _nama.text.trim(),
            role: _role,
            nomorRumah: _rumah.text.trim().isEmpty ? null : _rumah.text.trim(),
            noHp: _hp.text.trim().isEmpty ? null : _hp.text.trim(),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Akun berhasil dibuat.')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar akun warga')),
      body: LoadingOverlay(
        loading: _loading,
        child: profile.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (p) {
            if (p == null || !p.isAdmin) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Akses ditolak. Hanya ketua/pengurus yang dapat menambah akun.',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      controller: _nama,
                      label: 'Nama lengkap',
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Wajib' : null,
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _email,
                      label: 'Email login',
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Wajib' : null,
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _password,
                      label: 'Password awal',
                      obscure: true,
                      validator: (v) =>
                          (v == null || v.length < 6) ? 'Min 6 karakter' : null,
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _rumah,
                      label: 'No rumah',
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _hp,
                      label: 'No HP',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _role,
                      decoration: const InputDecoration(labelText: 'Peran'),
                      items: const [
                        DropdownMenuItem(value: 'warga', child: Text('Warga')),
                        DropdownMenuItem(value: 'admin', child: Text('Admin RT')),
                      ],
                      onChanged: (v) => setState(() => _role = v ?? 'warga'),
                    ),
                    const SizedBox(height: 24),
                    AppButton(label: 'Simpan akun', onPressed: _submit),
                    Text(
                      'Setelah dibuat, minta warga melakukan login dan ganti password.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
