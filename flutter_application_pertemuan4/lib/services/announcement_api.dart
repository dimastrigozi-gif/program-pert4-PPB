import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/announcement.dart';

class AnnouncementApi {
  final http.Client _client;
  final String baseUrl;
  final Duration batasWaktu;

  AnnouncementApi({
    http.Client? client,
   this.baseUrl = 'https://jsonplaceholder.typicode.com',
    this.batasWaktu = const Duration(seconds: 10),
  }) : _client = client ?? http.Client();

  Future<List<Announcement>> ambilPengumuman() async {
    try {
      final response = await _client
          .get(Uri.parse('$baseUrl/posts'))
          .timeout(batasWaktu);

      if (response.statusCode != 200) {
        throw Exception('Gagal memuat: ${response.statusCode}');
      }

      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Announcement.fromJson(json)).toList();
    } on TimeoutException {
      throw Exception('Koneksi timeout. Periksa jaringan Anda.');
    } on http.ClientException {
      throw Exception('Gagal terhubung ke server.');
    }
  }

  void dispose() {
    _client.close();
  }
}