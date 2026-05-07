import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/firestore_paths.dart';
import '../../../core/widgets/app_card.dart';
import '../../auth/application/auth_providers.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider).valueOrNull;
    if (profile == null || !profile.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        body: const Center(child: Text('Akses pengurus saja.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Admin')),
      body: FutureBuilder<Map<String, int>>(
        future: _stats(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final s = snap.data!;
          return GridView.count(
            padding: const EdgeInsets.all(16),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _StatCard(title: 'Warga (users)', value: '${s['users']}'),
              _StatCard(title: 'Laporan pending', value: '${s['reports']}'),
              _StatCard(title: 'SOS aktif', value: '${s['sos']}'),
              _StatCard(title: 'Tamu (30 hari)', value: '${s['guests']}'),
            ],
          );
        },
      ),
    );
  }

  static Future<Map<String, int>> _stats() async {
    final fs = FirebaseFirestore.instance;

    final usersSnap = await fs.collection(FirestorePaths.users()).get();
    final usersCount = usersSnap.docs.where((d) {
      final r = d.data()['rt_id'];
      return r == AppConstants.rtId || r == null;
    }).length;

    final reportsSnap = await fs.collection(FirestorePaths.reports()).get();
    final reportsPending = reportsSnap.docs.where((d) {
      final data = d.data();
      final rt = data['rt_id'];
      final okRt = rt == AppConstants.rtId || rt == null;
      final st = data['status'] as String? ?? 'pending';
      return okRt && (st == 'pending');
    }).length;

    final sosSnap = await fs.collection(FirestorePaths.emergencies()).get();
    final sosActive = sosSnap.docs.where((d) {
      final data = d.data();
      final rt = data['rt_id'];
      final okRt = rt == AppConstants.rtId || rt == null;
      return okRt && data['is_active'] == true;
    }).length;

    final guestSnap =
        await fs.collection(FirestorePaths.bukuTamu()).limit(300).get();
    final since = DateTime.now().subtract(const Duration(days: 30));
    final guests = guestSnap.docs.where((d) {
      final c = d.data()['check_in'];
      if (c is Timestamp) return c.toDate().isAfter(since);
      return false;
    }).length;

    return {
      'users': usersCount,
      'reports': reportsPending,
      'sos': sosActive,
      'guests': guests,
    };
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}
