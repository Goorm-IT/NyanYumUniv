class YumUser {
  String uid;
  String userAlias;
  String userLevel;
  String? imagePath;
  String registerDate;

  YumUser({
    required this.uid,
    required this.userAlias,
    required this.userLevel,
    required this.imagePath,
    required this.registerDate,
  });
  @override
  String toString() =>
      '$uid, $userAlias, $userLevel, $imagePath, $registerDate ';
}
