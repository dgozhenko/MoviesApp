import 'package:floor/floor.dart';
import 'package:movies_app/domain/dao/movie_dao.dart';
import 'package:movies_app/domain/entity/movie_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';
import '../../util/date_time_converter.dart';

part 'app_database.g.dart';

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [Movie])
abstract class AppDatabase extends FloorDatabase {
  MovieDao get movieDao;
}
