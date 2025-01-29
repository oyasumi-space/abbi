class ModManifest {
  final String id;
  final String name;
  final String version;
  final int priority;

  ModManifest({
    required this.id,
    required this.name,
    required this.version,
    required this.priority,
  });

  factory ModManifest.fromJson(Map<String, dynamic> json) {
    return ModManifest(
      id: json['id'],
      name: json['name'],
      version: json['version'],
      priority: json['priority'] ?? 0,
    );
  }
}
