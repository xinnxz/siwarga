import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/firestore_paths.dart';
import '../../../core/widgets/app_card.dart';
import '../../auth/application/auth_providers.dart';

class AgendaScreen extends ConsumerWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admin = ref.watch(userProfileProvider).valueOrNull?.isAdmin ?? false;

    final stream = FirebaseFirestore.instance
        .collection(FirestorePaths.agenda())
        .orderBy('tanggal_mulai')
        .limit(200)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda RT'),
        actions: [
          if (admin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => AgendaScreen._addEvent(context),
            ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snap.data!.docs
              .where((doc) =>
                  (doc.data()['rt_id'] as String?) == AppConstants.rtId ||
                  doc.data()['rt_id'] == null)
              .toList();
          if (items.isEmpty) {
            return const Center(child: Text('Belum ada agenda.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final doc = items[i];
              final d = doc.data();
              final judul = d['judul'] as String? ?? '';
              final lokasi = d['lokasi'] as String? ?? '';
              final ts = d['tanggal_mulai'];
              var when = '';
              if (ts is Timestamp) {
                when =
                    ts.toDate().toLocal().toString().substring(0, 16);
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        judul,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(when),
                      if (lokasi.isNotEmpty) Text('📍 $lokasi'),
                      Text(d['deskripsi'] as String? ?? ''),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  static Future<void> _addEvent(BuildContext context) async {
    final judul = TextEditingController();
    final lokasi = TextEditingController();
    final desc = TextEditingController();
    var start = DateTime.now();

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          title: const Text('Agenda baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: judul,
                  decoration: const InputDecoration(labelText: 'Judul'),
                ),
                TextField(
                  controller: lokasi,
                  decoration: const InputDecoration(labelText: 'Lokasi'),
                ),
                TextField(
                  controller: desc,
                  decoration: const InputDecoration(labelText: 'Deskripsi'),
                ),
                ListTile(
                  title: Text('${start.toLocal()}'.substring(0, 16)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final d = await showDatePicker(
                      context: ctx,
                      initialDate: start,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2035),
                    );
                    if (d != null) {
                      setSt(() => start = DateTime(
                            d.year,
                            d.month,
                            d.day,
                            start.hour,
                            start.minute,
                          ));
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection(FirestorePaths.agenda())
                    .add({
                  'judul': judul.text.trim(),
                  'lokasi': lokasi.text.trim(),
                  'deskripsi': desc.text.trim(),
                  'tanggal_mulai': Timestamp.fromDate(start),
                  'tanggal_selesai': Timestamp.fromDate(start),
                  'kategori': 'sosial',
                  'rt_id': AppConstants.rtId,
                  'created_at': FieldValue.serverTimestamp(),
                });
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
