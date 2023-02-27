part of 'user.dart';

extension UserRepositories on Database {
  UserRepository get users => UserRepository._(this);
}

abstract class UserRepository
    implements
        ModelRepository,
        KeyedModelRepositoryInsert<UserInsertRequest>,
        ModelRepositoryUpdate<UserUpdateRequest>,
        ModelRepositoryDelete<int> {
  factory UserRepository._(Database db) = _UserRepository;

  Future<User?> queryUser(int id);
  Future<List<User>> queryUsers([QueryParams? params]);
}

class _UserRepository extends BaseRepository
    with
        KeyedRepositoryInsertMixin<UserInsertRequest>,
        RepositoryUpdateMixin<UserUpdateRequest>,
        RepositoryDeleteMixin<int>
    implements UserRepository {
  _UserRepository(super.db) : super(tableName: 'users', keyName: 'id');

  @override
  Future<User?> queryUser(int id) {
    return queryOne(id, UserQueryable());
  }

  @override
  Future<List<User>> queryUsers([QueryParams? params]) {
    return queryMany(UserQueryable(), params);
  }

  @override
  Future<List<int>> insert(List<UserInsertRequest> requests) async {
    if (requests.isEmpty) return [];
    var values = QueryValues();
    var rows = await db.query(
      'INSERT INTO "users" ( "first_name", "posts", "last_name", "username", "email", "bio", "image_url", "cover_url", "followers", "following" )\n'
      'VALUES ${requests.map((r) => '( ${values.add(r.firstName)}:text, ${values.add(r.posts)}:_int8, ${values.add(r.lastName)}:text, ${values.add(r.username)}:text, ${values.add(r.email)}:text, ${values.add(r.bio)}:text, ${values.add(r.imageURL)}:text, ${values.add(r.coverURL)}:text, ${values.add(r.followers)}:_int8, ${values.add(r.following)}:_int8 )').join(', ')}\n'
      'RETURNING "id"',
      values.values,
    );
    var result = rows.map<int>((r) => TextEncoder.i.decode(r.toColumnMap()['id'])).toList();

    return result;
  }

  @override
  Future<void> update(List<UserUpdateRequest> requests) async {
    if (requests.isEmpty) return;
    var values = QueryValues();
    await db.query(
      'UPDATE "users"\n'
      'SET "first_name" = COALESCE(UPDATED."first_name", "users"."first_name"), "posts" = COALESCE(UPDATED."posts", "users"."posts"), "last_name" = COALESCE(UPDATED."last_name", "users"."last_name"), "username" = COALESCE(UPDATED."username", "users"."username"), "email" = COALESCE(UPDATED."email", "users"."email"), "bio" = COALESCE(UPDATED."bio", "users"."bio"), "image_url" = COALESCE(UPDATED."image_url", "users"."image_url"), "cover_url" = COALESCE(UPDATED."cover_url", "users"."cover_url"), "followers" = COALESCE(UPDATED."followers", "users"."followers"), "following" = COALESCE(UPDATED."following", "users"."following")\n'
      'FROM ( VALUES ${requests.map((r) => '( ${values.add(r.id)}:int8, ${values.add(r.firstName)}:text, ${values.add(r.posts)}:_int8, ${values.add(r.lastName)}:text, ${values.add(r.username)}:text, ${values.add(r.email)}:text, ${values.add(r.bio)}:text, ${values.add(r.imageURL)}:text, ${values.add(r.coverURL)}:text, ${values.add(r.followers)}:_int8, ${values.add(r.following)}:_int8 )').join(', ')} )\n'
      'AS UPDATED("id", "first_name", "posts", "last_name", "username", "email", "bio", "image_url", "cover_url", "followers", "following")\n'
      'WHERE "users"."id" = UPDATED."id"',
      values.values,
    );
  }
}

class UserInsertRequest {
  UserInsertRequest({
    required this.firstName,
    required this.posts,
    required this.lastName,
    required this.username,
    required this.email,
    required this.bio,
    required this.imageURL,
    required this.coverURL,
    required this.followers,
    required this.following,
  });

  String firstName;
  List<int> posts;
  String lastName;
  String username;
  String email;
  String bio;
  String imageURL;
  String coverURL;
  List<int> followers;
  List<int> following;
}

class UserUpdateRequest {
  UserUpdateRequest({
    required this.id,
    this.firstName,
    this.posts,
    this.lastName,
    this.username,
    this.email,
    this.bio,
    this.imageURL,
    this.coverURL,
    this.followers,
    this.following,
  });

  int id;
  String? firstName;
  List<int>? posts;
  String? lastName;
  String? username;
  String? email;
  String? bio;
  String? imageURL;
  String? coverURL;
  List<int>? followers;
  List<int>? following;
}

class UserQueryable extends KeyedViewQueryable<User, int> {
  @override
  String get keyName => 'id';

  @override
  String encodeKey(int key) => TextEncoder.i.encode(key);

  @override
  String get query => 'SELECT "users".*'
      'FROM "users"';

  @override
  String get tableAlias => 'users';

  @override
  User decode(TypedMap map) => UserView(
      id: map.get('id'),
      firstName: map.get('first_name'),
      posts: map.getListOpt('posts') ?? const [],
      lastName: map.get('last_name'),
      username: map.get('username'),
      email: map.get('email'),
      bio: map.get('bio'),
      imageURL: map.get('image_url'),
      coverURL: map.get('cover_url'),
      followers: map.getListOpt('followers') ?? const [],
      following: map.getListOpt('following') ?? const []);
}

class UserView with User {
  UserView({
    required this.id,
    required this.firstName,
    required this.posts,
    required this.lastName,
    required this.username,
    required this.email,
    required this.bio,
    required this.imageURL,
    required this.coverURL,
    required this.followers,
    required this.following,
  });

  @override
  final int id;
  @override
  final String firstName;
  @override
  final List<int> posts;
  @override
  final String lastName;
  @override
  final String username;
  @override
  final String email;
  @override
  final String bio;
  @override
  final String imageURL;
  @override
  final String coverURL;
  @override
  final List<int> followers;
  @override
  final List<int> following;
}
