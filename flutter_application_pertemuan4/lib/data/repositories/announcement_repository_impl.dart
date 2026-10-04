import '../../domain/repositories/announcement_repository.dart';
import '../../models/announcement.dart';
import '../datasources/announcement_remote_datasource.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementRemoteDataSource _remoteDataSource;

  AnnouncementRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Announcement>> getAnnouncements() {
    return _remoteDataSource.fetchAnnouncements();
  }
}