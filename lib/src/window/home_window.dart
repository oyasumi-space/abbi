import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../page/mods_page.dart';
import '../pod/mods_pod.dart';

class HomeWidndow extends ConsumerWidget {
  const HomeWidndow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(modsFSEPod);
            },
          ),
        ],
      ),
      body: ModsPage(),
    );
  }
}
