class TeamData {
  String getName() {
    return name;
  }

  void setName(String nickname) {
    name = nickname;
  }

  String name;

  ///base64 avatar image
  String avatar;
  String getAvatar() {
    return avatar;
  }

  void setAvatar(String avatar) {
    this.avatar = avatar;
  }

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
      );
    } catch (e) {
      print(e);
      return TeamData(avatar: "", name: "");
    }
  }
}
