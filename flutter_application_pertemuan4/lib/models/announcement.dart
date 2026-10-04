class Announcement {
  final int id;
  final String title;
  final String content;
  final String author;
  final String category;
  final String date;
  final int readCount;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.category,
    required this.date,
    required this.readCount,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Tanpa Judul',
      // Endpoint contoh cuma nyediain 'body', jadi kita akali
      content: json['content'] ?? json['body'] ?? 'Tidak ada konten',
      author: 'Admin',
      category: 'Umum',
      date: DateTime.now().toString(),
      readCount: 0,
    );
  }

  // Data simulasi (kalau butuh untuk testing keadaan kosong)
  static List<Announcement> getSampleAnnouncements() {
    return List.generate(
      5,
      (i) => Announcement(
        id: i + 1,
        title: 'Pengumuman Contoh ${i + 1}',
        content: 'Ini adalah konten pengumuman contoh.',
        author: 'Admin',
        category: 'Umum',
        date: '2024-01-01',
        readCount: 0,
      ),
    );
  }
}