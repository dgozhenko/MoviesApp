class Movie {
  int? id;
  String title;
  String? imageUrl;
  int creationTime;
  bool isWatched;

  Movie({
    this.id,
    required this.title,
    this.imageUrl,
    required this.creationTime,
    required this.isWatched,
  });

  factory Movie.fromDatabaseJson(Map<String, dynamic> data) => Movie(
        id: data['id'],
        title: data['title'],
        creationTime: data['creation_time'],
        isWatched: data['is_watched'] == 0 ? false : true,
        imageUrl: data['image_url'],
      );

  Map<String, dynamic> toDatabaseJson() => {
        'id': id,
        'title': title,
        'creation_time': creationTime,
        'is_watched': isWatched == false ? 0 : 1,
        'image_url': imageUrl
      };

  Movie copyWith({int? id, String? title, String? imageUrl, bool? isWatched}) {
    return Movie(
      title: title ?? this.title,
      creationTime: creationTime,
      isWatched: isWatched ?? this.isWatched,
      imageUrl: imageUrl,
    );
  }
}
