class ReviewByStore<String, double, bool> {
  final String reviewId;
  final String userAlias;
  final double storeId;
  final double menuId;
  final double score;
  final String content;
  final String imagePath;
  final String? propose;
  final bool delete;
  final String registerDate;

  ReviewByStore({
    required this.reviewId,
    required this.userAlias,
    required this.storeId,
    required this.menuId,
    required this.score,
    required this.content,
    required this.imagePath,
    required this.propose,
    required this.delete,
    required this.registerDate,
  });

  factory ReviewByStore.fromJson(Map<String, dynamic> json) {
    return ReviewByStore(
      reviewId: json["reviewId"] as String,
      userAlias: json["userAlias"] as String,
      storeId: json["storeId"] as double,
      menuId: json['menuId'] as double,
      score: json['score'] as double,
      content: json['content'] as String,
      imagePath: json['imagePath'] as String,
      propose: json['propose'] as String?,
      delete: json['delete'] as bool,
      registerDate: json['registerDate'] as String,
    );
  }
}
