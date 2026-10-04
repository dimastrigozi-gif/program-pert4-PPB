import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/announcement_remote_datasource.dart';
import '../data/repositories/announcement_repository_impl.dart';
import '../domain/repositories/announcement_repository.dart';
import '../models/announcement.dart';

// 1. Provider untuk Dio
final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

// 2. Provider untuk Data Source
final remoteDataSourceProvider = Provider<AnnouncementRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AnnouncementRemoteDataSource(dio);
});

// 3. Provider untuk Repository
final announcementRepositoryProvider = Provider<AnnouncementRepository>((ref) {
  final dataSource = ref.watch(remoteDataSourceProvider);
  return AnnouncementRepositoryImpl(dataSource);
});

// 4. Provider untuk mengambil data (FutureProvider)
final announcementsProvider = FutureProvider<List<Announcement>>((ref) async {
  final repository = ref.watch(announcementRepositoryProvider);
  return repository.getAnnouncements();
});