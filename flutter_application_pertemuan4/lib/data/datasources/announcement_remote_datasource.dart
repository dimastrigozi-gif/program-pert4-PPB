import 'package:dio/dio.dart';
import '../../models/announcement.dart';

class AnnouncementRemoteDataSource {
  final Dio _dio;

  AnnouncementRemoteDataSource(this._dio);

  Future<List<Announcement>> fetchAnnouncements() async {
    try {
      final response = await _dio.get(
        'https://jsonplaceholder.typicode.com/posts',
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Announcement.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Dio punya jenis error yang lebih spesifik
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Koneksi timeout. Periksa jaringan Anda.');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Gagal terhubung ke server.');
      }
      throw Exception('Terjadi kesalahan: ${e.message}');
    }
  }
}