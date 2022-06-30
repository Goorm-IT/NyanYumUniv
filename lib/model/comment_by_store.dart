class CommentByStore<int, String> {
  final int reviewId;
  final String content;
  CommentByStore({
    required this.reviewId,
    required this.content,
  });

  factory CommentByStore.fromJson(Map<String, dynamic> json) {
    return CommentByStore(
      reviewId: json["reviewId"] as int,
      content: json["content"] as String,
    );
  }
}
