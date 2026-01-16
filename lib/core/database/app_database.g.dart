// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FriendsTableTable extends FriendsTable
    with TableInfo<$FriendsTableTable, FriendsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FriendsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, fullName, avatarUrl, username];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'friends_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<FriendsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FriendsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FriendsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
    );
  }

  @override
  $FriendsTableTable createAlias(String alias) {
    return $FriendsTableTable(attachedDatabase, alias);
  }
}

class FriendsTableData extends DataClass
    implements Insertable<FriendsTableData> {
  final String id;
  final String fullName;
  final String? avatarUrl;
  final String username;
  const FriendsTableData({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    required this.username,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['full_name'] = Variable<String>(fullName);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    map['username'] = Variable<String>(username);
    return map;
  }

  FriendsTableCompanion toCompanion(bool nullToAbsent) {
    return FriendsTableCompanion(
      id: Value(id),
      fullName: Value(fullName),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      username: Value(username),
    );
  }

  factory FriendsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FriendsTableData(
      id: serializer.fromJson<String>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      username: serializer.fromJson<String>(json['username']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fullName': serializer.toJson<String>(fullName),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'username': serializer.toJson<String>(username),
    };
  }

  FriendsTableData copyWith({
    String? id,
    String? fullName,
    Value<String?> avatarUrl = const Value.absent(),
    String? username,
  }) => FriendsTableData(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    username: username ?? this.username,
  );
  FriendsTableData copyWithCompanion(FriendsTableCompanion data) {
    return FriendsTableData(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      username: data.username.present ? data.username.value : this.username,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FriendsTableData(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('username: $username')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fullName, avatarUrl, username);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FriendsTableData &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.avatarUrl == this.avatarUrl &&
          other.username == this.username);
}

class FriendsTableCompanion extends UpdateCompanion<FriendsTableData> {
  final Value<String> id;
  final Value<String> fullName;
  final Value<String?> avatarUrl;
  final Value<String> username;
  final Value<int> rowid;
  const FriendsTableCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.username = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FriendsTableCompanion.insert({
    required String id,
    required String fullName,
    this.avatarUrl = const Value.absent(),
    required String username,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fullName = Value(fullName),
       username = Value(username);
  static Insertable<FriendsTableData> custom({
    Expression<String>? id,
    Expression<String>? fullName,
    Expression<String>? avatarUrl,
    Expression<String>? username,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (username != null) 'username': username,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FriendsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? fullName,
    Value<String?>? avatarUrl,
    Value<String>? username,
    Value<int>? rowid,
  }) {
    return FriendsTableCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      username: username ?? this.username,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FriendsTableCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('username: $username, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FriendsTableTable friendsTable = $FriendsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [friendsTable];
}

typedef $$FriendsTableTableCreateCompanionBuilder =
    FriendsTableCompanion Function({
      required String id,
      required String fullName,
      Value<String?> avatarUrl,
      required String username,
      Value<int> rowid,
    });
typedef $$FriendsTableTableUpdateCompanionBuilder =
    FriendsTableCompanion Function({
      Value<String> id,
      Value<String> fullName,
      Value<String?> avatarUrl,
      Value<String> username,
      Value<int> rowid,
    });

class $$FriendsTableTableFilterComposer
    extends Composer<_$AppDatabase, $FriendsTableTable> {
  $$FriendsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FriendsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FriendsTableTable> {
  $$FriendsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FriendsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FriendsTableTable> {
  $$FriendsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);
}

class $$FriendsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FriendsTableTable,
          FriendsTableData,
          $$FriendsTableTableFilterComposer,
          $$FriendsTableTableOrderingComposer,
          $$FriendsTableTableAnnotationComposer,
          $$FriendsTableTableCreateCompanionBuilder,
          $$FriendsTableTableUpdateCompanionBuilder,
          (
            FriendsTableData,
            BaseReferences<_$AppDatabase, $FriendsTableTable, FriendsTableData>,
          ),
          FriendsTableData,
          PrefetchHooks Function()
        > {
  $$FriendsTableTableTableManager(_$AppDatabase db, $FriendsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FriendsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FriendsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FriendsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FriendsTableCompanion(
                id: id,
                fullName: fullName,
                avatarUrl: avatarUrl,
                username: username,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fullName,
                Value<String?> avatarUrl = const Value.absent(),
                required String username,
                Value<int> rowid = const Value.absent(),
              }) => FriendsTableCompanion.insert(
                id: id,
                fullName: fullName,
                avatarUrl: avatarUrl,
                username: username,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FriendsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FriendsTableTable,
      FriendsTableData,
      $$FriendsTableTableFilterComposer,
      $$FriendsTableTableOrderingComposer,
      $$FriendsTableTableAnnotationComposer,
      $$FriendsTableTableCreateCompanionBuilder,
      $$FriendsTableTableUpdateCompanionBuilder,
      (
        FriendsTableData,
        BaseReferences<_$AppDatabase, $FriendsTableTable, FriendsTableData>,
      ),
      FriendsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FriendsTableTableTableManager get friendsTable =>
      $$FriendsTableTableTableManager(_db, _db.friendsTable);
}
