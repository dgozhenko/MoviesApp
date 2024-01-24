import 'package:floor/floor.dart';

@Entity(tableName: 'movie')
class Movie {
  @PrimaryKey(autoGenerate: true)
  int? id;
  @ColumnInfo(name: 'title')
  String title;
  @ColumnInfo(name: 'image_url')
  String? imageUrl;
  @ColumnInfo(name: 'creation_time')
  DateTime creationTime;
  @ColumnInfo(name: 'is_watched')
  bool isWatched;

  Movie({
    this.id,
    required this.title,
    this.imageUrl,
    required this.creationTime,
    required this.isWatched,
  });

  Movie copyWith({int? id, String? title, String? imageUrl, bool? isWatched}) {
    return Movie(
      title: title ?? this.title,
      creationTime: creationTime,
      isWatched: isWatched ?? this.isWatched,
      imageUrl: imageUrl,
    );
  }
}
