class CheckUserStatus<String> {
  final String uid;
  final String userAlias;
  CheckUserStatus({
    required this.uid,
    required this.userAlias,
  });

  factory CheckUserStatus.fromJson(Map<String, dynamic> json) {
    return CheckUserStatus(
      uid: json["uid"] as String,
      userAlias: json["userAlias"] as String,
    );
  }
}
