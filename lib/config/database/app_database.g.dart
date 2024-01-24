// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  MovieDao? _movieDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `movie` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `image_url` TEXT, `creation_time` INTEGER NOT NULL, `is_watched` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MovieDao get movieDao {
    return _movieDaoInstance ??= _$MovieDao(database, changeListener);
  }
}

class _$MovieDao extends MovieDao {
  _$MovieDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _movieInsertionAdapter = InsertionAdapter(
            database,
            'movie',
            (Movie item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'image_url': item.imageUrl,
                  'creation_time': _dateTimeConverter.encode(item.creationTime),
                  'is_watched': item.isWatched ? 1 : 0
                },
            changeListener),
        _movieUpdateAdapter = UpdateAdapter(
            database,
            'movie',
            ['id'],
            (Movie item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'image_url': item.imageUrl,
                  'creation_time': _dateTimeConverter.encode(item.creationTime),
                  'is_watched': item.isWatched ? 1 : 0
                },
            changeListener),
        _movieDeletionAdapter = DeletionAdapter(
            database,
            'movie',
            ['id'],
            (Movie item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'image_url': item.imageUrl,
                  'creation_time': _dateTimeConverter.encode(item.creationTime),
                  'is_watched': item.isWatched ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Movie> _movieInsertionAdapter;

  final UpdateAdapter<Movie> _movieUpdateAdapter;

  final DeletionAdapter<Movie> _movieDeletionAdapter;

  @override
  Future<List<Movie>> getAllMovies() async {
    return _queryAdapter.queryList('SELECT * FROM movie',
        mapper: (Map<String, Object?> row) => Movie(
            id: row['id'] as int?,
            title: row['title'] as String,
            imageUrl: row['image_url'] as String?,
            creationTime:
                _dateTimeConverter.decode(row['creation_time'] as int),
            isWatched: (row['is_watched'] as int) != 0));
  }

  @override
  Stream<List<Movie>> observeAllMovie() {
    return _queryAdapter.queryListStream('SELECT * FROM movie',
        mapper: (Map<String, Object?> row) => Movie(
            id: row['id'] as int?,
            title: row['title'] as String,
            imageUrl: row['image_url'] as String?,
            creationTime:
                _dateTimeConverter.decode(row['creation_time'] as int),
            isWatched: (row['is_watched'] as int) != 0),
        queryableName: 'movie',
        isView: false);
  }

  @override
  Stream<List<Movie>> findMoviesById(int id) {
    return _queryAdapter.queryListStream('SELECT * FROM movie WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Movie(
            id: row['id'] as int?,
            title: row['title'] as String,
            imageUrl: row['image_url'] as String?,
            creationTime:
                _dateTimeConverter.decode(row['creation_time'] as int),
            isWatched: (row['is_watched'] as int) != 0),
        arguments: [id],
        queryableName: 'movie',
        isView: false);
  }

  @override
  Future<int> insertMovie(Movie movie) {
    return _movieInsertionAdapter.insertAndReturnId(
        movie, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMovie(Movie movie) async {
    await _movieUpdateAdapter.update(movie, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteMovie(Movie movie) async {
    await _movieDeletionAdapter.delete(movie);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
