import 'package:get_it/get_it.dart';
import 'package:movies_app/config/database/app_database.dart';
import 'package:movies_app/data/datasource/sqlite_movie_list_data_source.dart';
import 'package:movies_app/data/repository/sqlite_movie_repository.dart';
import 'package:movies_app/domain/dao/movie_dao.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerSingletonAsync(
    () => $FloorAppDatabase.databaseBuilder('movies.db').build(),
  );

  getIt.registerSingletonWithDependencies(
    () {
      return GetIt.instance.get<AppDatabase>().movieDao;
    },
    dependsOn: [AppDatabase],
  );

  getIt.registerSingletonWithDependencies(
    () => SQLiteMovieRepository(),
    dependsOn: [AppDatabase, MovieDao],
  );

  getIt.registerSingletonWithDependencies(
    () => SQLiteMovieListDataSource(),
    dependsOn: [SQLiteMovieRepository],
  );
}
