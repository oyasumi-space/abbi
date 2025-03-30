import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pod/omori_path_pod.dart';

class TestPage extends ConsumerWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final o = ref.watch(omoriPathPod);
    return Center(
      child: Column(
        children: [
          Text(o.toString()),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(omoriPathPod);
            },
            child: const Text("Refresh"),
          ),
        ],
      ),
    );
  }
}
