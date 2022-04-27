class TBATeam {
  final String name;
  // final int id;
  // final String title;

  const TBATeam({
    required this.name,
    // required this.id,
    // required this.title,
  });

  factory TBATeam.fromJson(Map<String, dynamic> json) {
    return TBATeam(
      name: json['nickname'],
      // id: json['id'],
      // title: json['title'],
    );
  }
}
