import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/firestore_paths.dart';
import '../../auth/application/auth_providers.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();

  Future<void> _kirim() async {
    final text = _controller.text.trim();
    final profile = ref.read(userProfileProvider).valueOrNull;
    final user = ref.read(authStateProvider).valueOrNull;
    if (text.isEmpty || user == null || profile == null) return;

    await FirebaseFirestore.instance.collection(FirestorePaths.discussions()).add({
      'user_id': user.uid,
      'nama_pengirim': profile.nama,
      'nomor_rumah': profile.nomorRumah ?? '',
      'pesan': text,
      'tipe': 'text',
      'rt_id': AppConstants.rtId,
      'created_at': FieldValue.serverTimestamp(),
    });
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(authStateProvider).valueOrNull?.uid;

    final stream = FirebaseFirestore.instance
        .collection(FirestorePaths.discussions())
        .orderBy('created_at', descending: false)
        .limit(200)
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text('Diskusi Warga')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: stream,
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snap.data!.docs
                    .where((doc) =>
                        (doc.data()['rt_id'] as String?) == AppConstants.rtId ||
                        doc.data()['rt_id'] == null)
                    .toList();
                return ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final d = docs[i].data();
                    final mine = d['user_id'] == uid;
                    final nama = d['nama_pengirim'] as String? ?? '';
                    final rumah = d['nomor_rumah'] as String? ?? '';
                    final pesan = d['pesan'] as String? ?? '';
                    return Align(
                      alignment:
                          mine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.85,
                        ),
                        decoration: BoxDecoration(
                          color: mine
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!mine)
                              Text(
                                '$nama (${rumah.isEmpty ? '-' : rumah})',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: mine ? Colors.white : null,
                                ),
                              ),
                            Text(
                              pesan,
                              style: TextStyle(
                                color: mine ? Colors.white : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Tulis pesan...',
                        border: OutlineInputBorder(),
                      ),
                      minLines: 1,
                      maxLines: 4,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _kirim,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
