import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../auth/application/auth_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static final _menu = <_MenuItem>[
    _MenuItem('Warga', Icons.people, '/warga'),
    _MenuItem('Kontrakan', Icons.home_work_outlined, '/kontrakan'),
    _MenuItem('Info RT', Icons.info_outline, '/info-rt'),
    _MenuItem('Yatim', Icons.favorite, '/yatim'),
    _MenuItem('Buku Tamu', Icons.book_outlined, '/tamu'),
    _MenuItem('Uang Kematian', Icons.account_balance_wallet_outlined, '/finance'),
    _MenuItem('UMKM', Icons.storefront_outlined, '/umkm'),
    _MenuItem('Ronda', Icons.nightlight_round, '/ronda'),
    _MenuItem('Iuran', Icons.payments_outlined, '/dues'),
    _MenuItem('Agenda', Icons.calendar_month_outlined, '/agenda'),
    _MenuItem('Galeri', Icons.photo_library_outlined, '/gallery'),
    _MenuItem('Dashboard', Icons.dashboard_outlined, '/dashboard'),
    _MenuItem('Presensi Ronda', Icons.fact_check_outlined, '/patrol-attendance'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider).valueOrNull;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColors.headerGradient,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sistem Informasi',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 12,
                                  letterSpacing: 1,
                                ),
                              ),
                              Text(
                                AppConstants.appName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.person, color: Colors.white),
                          onPressed: () => context.push('/profile'),
                          tooltip: 'Profil',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      profile?.nama ?? '...',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (profile?.nomorRumah != null &&
                        profile!.nomorRumah!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Chip(
                          label: Text('No. ${profile.nomorRumah}'),
                          backgroundColor: Colors.white24,
                          labelStyle: const TextStyle(color: Colors.white),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    Text(
                      profile?.role ?? '',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Menu Utama',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.82,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = _menu[index];
                        return InkWell(
                          onTap: () {
                            if (item.route == '/dashboard' &&
                                !(profile?.isAdmin ?? false)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Khusus pengurus RT.'),
                                ),
                              );
                              return;
                            }
                            context.push(item.route);
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Column(
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withValues(alpha: 0.06),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Icon(item.icon, color: AppColors.primary),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.label,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.labelSmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: _menu.length,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Pengumuman terkini',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                _AnnouncementList(admin: profile?.isAdmin ?? false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem(this.label, this.icon, this.route);
  final String label;
  final IconData icon;
  final String route;
}

class _AnnouncementList extends ConsumerWidget {
  const _AnnouncementList({required this.admin});

  final bool admin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final q = FirebaseFirestore.instance
        .collection('announcements')
        .orderBy('created_at', descending: true)
        .limit(15);

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: q.snapshots(),
      builder: (context, snap) {
        if (snap.hasError) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Error memuat pengumuman: ${snap.error}\n'
                'Pastikan indeks Firestore dan field created_at ada.',
              ),
            ),
          );
        }
        if (!snap.hasData) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        final docs = snap.data!.docs
            .where((doc) =>
                (doc.data()['rt_id'] as String?) == AppConstants.rtId ||
                doc.data()['rt_id'] == null)
            .toList();
        if (docs.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('Belum ada pengumuman.'),
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) {
              final d = docs[i].data();
              final judul = d['judul'] as String? ?? '';
              final konten = d['konten'] as String? ?? '';
              final nama = d['nama_admin'] as String? ?? '';
              final ts = d['created_at'];
              var tgl = '';
              if (ts is Timestamp) {
                tgl = ts.toDate().toLocal().toString().substring(0, 16);
              }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nama,
                          style: Theme.of(context).textTheme.titleSmall),
                      Text(
                        tgl,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).hintColor,
                            ),
                      ),
                      if (judul.isNotEmpty)
                        Text(
                          judul,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      const SizedBox(height: 8),
                      Text(konten),
                    ],
                  ),
                ),
              );
            },
            childCount: docs.length,
          ),
        );
      },
    );
  }
}
