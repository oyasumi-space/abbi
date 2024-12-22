class Profile {
  final String name;
  final List<String> mods;

  Profile(this.name, this.mods);

  Profile.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        mods = List<String>.from(json['mods'] ?? []);

  Map<String, dynamic> toJson() => {
        'name': name,
        'mods': mods,
      };
}
