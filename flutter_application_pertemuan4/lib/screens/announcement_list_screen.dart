import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/announcement_providers.dart';
import '../widgets/announcement_card.dart';
import 'announcement_detail_screen.dart';

// 1. Ubah dari StatefulWidget menjadi ConsumerWidget
class AnnouncementListScreen extends ConsumerWidget {
  const AnnouncementListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 2. Pantau state dari provider
    final announcementsAsync = ref.watch(announcementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Portal Pengumuman'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            // 3. Cara refresh di Riverpod
            onPressed: () => ref.invalidate(announcementsProvider),
          ),
        ],
      ),
      // 4. Gunakan .when() untuk menangani 4 keadaan secara otomatis
      body: announcementsAsync.when(
        // Keadaan MEMUAT
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Memuat pengumuman...'),
            ],
          ),
        ),

        // Keadaan GAGAL
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Gagal memuat: $error',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(announcementsProvider),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),

        // Keadaan BERHASIL (termasuk Kosong)
        data: (data) {
          if (data.isEmpty) {
            // Keadaan KOSONG
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Belum ada pengumuman untuk saat ini.'),
                ],
              ),
            );
          }

          // Keadaan BERHASIL (Ada data)
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(announcementsProvider.future),
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return AnnouncementCard(
                  announcement: item,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnnouncementDetailScreen(
                          announcement: item,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}