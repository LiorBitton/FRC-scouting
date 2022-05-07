class TeamData {
  String name;
  String getName() {
    return name;
  }

  void setName(String nickname) {
    name = nickname;
  }

  ///base64 avatar image
  String avatar;
  String getAvatar() {
    return avatar;
  }

  void setAvatar(String avatar) {
    this.avatar = avatar;
  }
  //final int id;
  // final String title;

  TeamData({
    required this.name,
    required this.avatar,
    // required this.title,
  });
  Map<String, dynamic> toJson() => {
        'name': name,
        'avatar': avatar,
      };

  factory TeamData.fromJson(Map<String, dynamic> json) {
    try {
      return TeamData(
        name: json['name'],
        avatar: json['avatar'],
        // title: json['title'],
      );
    } catch (e) {
      print(e);
      return TeamData(avatar: "", name: "failed");
    }
  }
}
