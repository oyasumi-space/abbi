class ModManifest {
  final String id;
  final String name;
  final String version;

  ModManifest({
    required this.id,
    required this.name,
    required this.version,
  });

  factory ModManifest.fromJson(Map<String, dynamic> json) {
    return ModManifest(
      id: json['id'],
      name: json['name'],
      version: json['version'],
    );
  }
}
