import 'package:flutter/material.dart';
import '../models/announcement.dart';
import '../services/announcement_api.dart';
import '../widgets/announcement_card.dart';
import 'announcement_detail_screen.dart';

class AnnouncementListScreen extends StatefulWidget {
  const AnnouncementListScreen({super.key});

  @override
  State<AnnouncementListScreen> createState() => _AnnouncementListScreenState();
}

class _AnnouncementListScreenState extends State<AnnouncementListScreen> {
  late AnnouncementApi _api;
  late Future<List<Announcement>> _futurePengumuman;

  @override
  void initState() {
    super.initState();
    _api = AnnouncementApi();
    // PENTING: Future dibuat di sini, bukan di dalam build()
    _futurePengumuman = _api.ambilPengumuman();
  }

  void _muatUlang() {
    setState(() {
      _futurePengumuman = _api.ambilPengumuman();
    });
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portal Pengumuman'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _muatUlang,
          ),
        ],
      ),
      body: FutureBuilder<List<Announcement>>(
        future: _futurePengumuman,
        builder: (context, snapshot) {
          // 1. KEADAAN MEMUAT
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat pengumuman...'),
                ],
              ),
            );
          }

          // 2. KEADAAN GAGAL
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Gagal memuat: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _muatUlang,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          // 3. KEADAAN KOSONG
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
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

          // 4. KEADAAN BERHASIL
          return RefreshIndicator(
            onRefresh: () async => _muatUlang(),
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