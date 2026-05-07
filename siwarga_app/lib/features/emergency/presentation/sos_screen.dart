import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/firestore_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/application/auth_providers.dart';

class SosScreen extends ConsumerStatefulWidget {
  const SosScreen({super.key});

  @override
  ConsumerState<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends ConsumerState<SosScreen> {
  final _lainnya = TextEditingController();

  Future<void> _logEmergency(String jenis, String? deskripsi) async {
    final profile = ref.read(userProfileProvider).valueOrNull;
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;

    await FirebaseFirestore.instance.collection(FirestorePaths.emergencies()).add({
      'user_id': user.uid,
      'nama_pelapor': profile?.nama ?? '',
      'nomor_rumah': profile?.nomorRumah ?? '',
      'jenis_darurat': jenis,
      'deskripsi': deskripsi ?? '',
      'is_active': true,
      'rt_id': AppConstants.rtId,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _wa(String jenis, String pesanBody) async {
    final wa = AppConstants.legacyWhatsAppAdmin;
    final uri = Uri.parse('https://wa.me/$wa?text=${Uri.encodeComponent(pesanBody)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _kirim(String jenis, {String? detail}) async {
    final profile = ref.read(userProfileProvider).valueOrNull;
    final label = switch (jenis) {
      'maling' => '🚨 DARURAT - ADA MALING!',
      'kebakaran' => '🔥 DARURAT - KEBAKARAN!',
      'medis' => '🏥 DARURAT - BANTUAN MEDIS!',
      _ => '⚠️ DARURAT!',
    };
    var body =
        '$label\n\n👤 Pelapor: ${profile?.nama ?? ''}\n📍 No rumah: ${profile?.nomorRumah ?? '-'}\n🕐 ${DateTime.now()}';
    if (detail != null && detail.isNotEmpty) {
      body += '\n\nKeterangan: $detail';
    }
    await _logEmergency(jenis, detail);
    await _wa(jenis, body);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alert dicatat & WhatsApp dibuka.')),
      );
    }
  }

  @override
  void dispose() {
    _lainnya.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Darurat SOS')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Tekan jenis darurat. Log tersimpan di Firestore dan WhatsApp ketua.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 200,
              height: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: AppColors.danger,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(24),
                ),
                onPressed: () => _kirim('lainnya', detail: 'Tombol utama darurat'),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 48),
                    SizedBox(height: 8),
                    Text('DARURAT', style: TextStyle(fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _SosChip(
                  label: 'Maling',
                  color: Colors.orange.shade100,
                  onTap: () => _kirim('maling'),
                ),
                _SosChip(
                  label: 'Kebakaran',
                  color: Colors.red.shade100,
                  onTap: () => _kirim('kebakaran'),
                ),
                _SosChip(
                  label: 'Medis',
                  color: Colors.green.shade100,
                  onTap: () => _kirim('medis'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _lainnya,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Lainnya — jelaskan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                final t = _lainnya.text.trim();
                if (t.isEmpty) return;
                _kirim('lainnya', detail: t);
              },
              child: const Text('Kirim lainnya'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SosChip extends StatelessWidget {
  const _SosChip({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}
