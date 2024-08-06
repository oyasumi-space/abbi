class ModManifest {
  ModManifest({
    required this.id,
    required this.name,
    required this.version,
    required this.description,
  });

  final String id;
  final String name;
  final String version;
  final String description;

  factory ModManifest.fromJson(Map<String, dynamic> json) {
    try {
      return ModManifest(
        id: json['id'] as String,
        name: json['name'] as String,
        version: json['version'] as String,
        description: json['description'] as String,
      );
    } catch (e) {
      throw Exception('Failed to parse manifest.json');
    }
  }
}
