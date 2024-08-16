class Profile {
  Profile({
    required this.name,
    required this.mods,
  });

  final String name;
  final List<String> mods;

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      mods: List<String>.from(json['mods']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mods': mods,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Profile && other.name == name && other.mods == mods;
  }

  @override
  int get hashCode => name.hashCode ^ mods.hashCode;
}
