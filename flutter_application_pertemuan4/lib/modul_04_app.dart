import 'package:flutter/material.dart';
import 'screens/announcement_list_screen.dart';

class Modul04App extends StatelessWidget {
  const Modul04App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modul 4 - Portal Pengumuman',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AnnouncementListScreen(),
    );
  }
}