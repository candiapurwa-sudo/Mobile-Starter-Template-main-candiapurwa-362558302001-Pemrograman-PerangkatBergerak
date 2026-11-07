import 'package:flutter/material.dart';

import 'screens/announcement_list_screen.dart';

class Modul04App extends StatelessWidget {
  const Modul04App({super.key});

  @override
  Widget build(BuildContext context) {
    // Langsung panggil tanpa parameter api karena sudah dikelola oleh Riverpod
    return const AnnouncementListScreen();
  }
}
