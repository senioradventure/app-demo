// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ChatRoomsTable extends ChatRooms
    with TableInfo<$ChatRoomsTable, ChatRoom> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatRoomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _roomIdMeta = const VerificationMeta('roomId');
  @override
  late final GeneratedColumn<String> roomId = GeneratedColumn<String>(
    'room_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userCountMeta = const VerificationMeta(
    'userCount',
  );
  @override
  late final GeneratedColumn<int> userCount = GeneratedColumn<int>(
    'user_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isLiveMeta = const VerificationMeta('isLive');
  @override
  late final GeneratedColumn<bool> isLive = GeneratedColumn<bool>(
    'is_live',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_live" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    roomId,
    name,
    location,
    userCount,
    isLive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_rooms';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatRoom> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('room_id')) {
      context.handle(
        _roomIdMeta,
        roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roomIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('user_count')) {
      context.handle(
        _userCountMeta,
        userCount.isAcceptableOrUnknown(data['user_count']!, _userCountMeta),
      );
    }
    if (data.containsKey('is_live')) {
      context.handle(
        _isLiveMeta,
        isLive.isAcceptableOrUnknown(data['is_live']!, _isLiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {roomId};
  @override
  ChatRoom map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatRoom(
      roomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      userCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_count'],
      )!,
      isLive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_live'],
      )!,
    );
  }

  @override
  $ChatRoomsTable createAlias(String alias) {
    return $ChatRoomsTable(attachedDatabase, alias);
  }
}

class ChatRoom extends DataClass implements Insertable<ChatRoom> {
  final String roomId;
  final String name;
  final String? location;
  final int userCount;
  final bool isLive;
  const ChatRoom({
    required this.roomId,
    required this.name,
    this.location,
    required this.userCount,
    required this.isLive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['room_id'] = Variable<String>(roomId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    map['user_count'] = Variable<int>(userCount);
    map['is_live'] = Variable<bool>(isLive);
    return map;
  }

  ChatRoomsCompanion toCompanion(bool nullToAbsent) {
    return ChatRoomsCompanion(
      roomId: Value(roomId),
      name: Value(name),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      userCount: Value(userCount),
      isLive: Value(isLive),
    );
  }

  factory ChatRoom.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatRoom(
      roomId: serializer.fromJson<String>(json['roomId']),
      name: serializer.fromJson<String>(json['name']),
      location: serializer.fromJson<String?>(json['location']),
      userCount: serializer.fromJson<int>(json['userCount']),
      isLive: serializer.fromJson<bool>(json['isLive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'roomId': serializer.toJson<String>(roomId),
      'name': serializer.toJson<String>(name),
      'location': serializer.toJson<String?>(location),
      'userCount': serializer.toJson<int>(userCount),
      'isLive': serializer.toJson<bool>(isLive),
    };
  }

  ChatRoom copyWith({
    String? roomId,
    String? name,
    Value<String?> location = const Value.absent(),
    int? userCount,
    bool? isLive,
  }) => ChatRoom(
    roomId: roomId ?? this.roomId,
    name: name ?? this.name,
    location: location.present ? location.value : this.location,
    userCount: userCount ?? this.userCount,
    isLive: isLive ?? this.isLive,
  );
  ChatRoom copyWithCompanion(ChatRoomsCompanion data) {
    return ChatRoom(
      roomId: data.roomId.present ? data.roomId.value : this.roomId,
      name: data.name.present ? data.name.value : this.name,
      location: data.location.present ? data.location.value : this.location,
      userCount: data.userCount.present ? data.userCount.value : this.userCount,
      isLive: data.isLive.present ? data.isLive.value : this.isLive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatRoom(')
          ..write('roomId: $roomId, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('userCount: $userCount, ')
          ..write('isLive: $isLive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(roomId, name, location, userCount, isLive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatRoom &&
          other.roomId == this.roomId &&
          other.name == this.name &&
          other.location == this.location &&
          other.userCount == this.userCount &&
          other.isLive == this.isLive);
}

class ChatRoomsCompanion extends UpdateCompanion<ChatRoom> {
  final Value<String> roomId;
  final Value<String> name;
  final Value<String?> location;
  final Value<int> userCount;
  final Value<bool> isLive;
  final Value<int> rowid;
  const ChatRoomsCompanion({
    this.roomId = const Value.absent(),
    this.name = const Value.absent(),
    this.location = const Value.absent(),
    this.userCount = const Value.absent(),
    this.isLive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatRoomsCompanion.insert({
    required String roomId,
    required String name,
    this.location = const Value.absent(),
    this.userCount = const Value.absent(),
    this.isLive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : roomId = Value(roomId),
       name = Value(name);
  static Insertable<ChatRoom> custom({
    Expression<String>? roomId,
    Expression<String>? name,
    Expression<String>? location,
    Expression<int>? userCount,
    Expression<bool>? isLive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (roomId != null) 'room_id': roomId,
      if (name != null) 'name': name,
      if (location != null) 'location': location,
      if (userCount != null) 'user_count': userCount,
      if (isLive != null) 'is_live': isLive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatRoomsCompanion copyWith({
    Value<String>? roomId,
    Value<String>? name,
    Value<String?>? location,
    Value<int>? userCount,
    Value<bool>? isLive,
    Value<int>? rowid,
  }) {
    return ChatRoomsCompanion(
      roomId: roomId ?? this.roomId,
      name: name ?? this.name,
      location: location ?? this.location,
      userCount: userCount ?? this.userCount,
      isLive: isLive ?? this.isLive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (roomId.present) {
      map['room_id'] = Variable<String>(roomId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (userCount.present) {
      map['user_count'] = Variable<int>(userCount.value);
    }
    if (isLive.present) {
      map['is_live'] = Variable<bool>(isLive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatRoomsCompanion(')
          ..write('roomId: $roomId, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('userCount: $userCount, ')
          ..write('isLive: $isLive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages with TableInfo<$MessagesTable, Message> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roomIdMeta = const VerificationMeta('roomId');
  @override
  late final GeneratedColumn<String> roomId = GeneratedColumn<String>(
    'room_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderIdMeta = const VerificationMeta(
    'senderId',
  );
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
    'sender_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    roomId,
    senderId,
    content,
    isSynced,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<Message> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('room_id')) {
      context.handle(
        _roomIdMeta,
        roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roomIdMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(
        _senderIdMeta,
        senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Message map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Message(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      roomId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}room_id'],
      )!,
      senderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }
}

class Message extends DataClass implements Insertable<Message> {
  /// Message ID (Supabase id or locally generated)
  final String id;

  /// Chat room ID
  final String roomId;

  /// Sender user ID
  final String senderId;

  /// Message content (text only for now)
  final String content;

  /// Whether message is synced with Supabase
  final bool isSynced;

  /// Created time
  final DateTime createdAt;
  const Message({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.content,
    required this.isSynced,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['room_id'] = Variable<String>(roomId);
    map['sender_id'] = Variable<String>(senderId);
    map['content'] = Variable<String>(content);
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      roomId: Value(roomId),
      senderId: Value(senderId),
      content: Value(content),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
    );
  }

  factory Message.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Message(
      id: serializer.fromJson<String>(json['id']),
      roomId: serializer.fromJson<String>(json['roomId']),
      senderId: serializer.fromJson<String>(json['senderId']),
      content: serializer.fromJson<String>(json['content']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'roomId': serializer.toJson<String>(roomId),
      'senderId': serializer.toJson<String>(senderId),
      'content': serializer.toJson<String>(content),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Message copyWith({
    String? id,
    String? roomId,
    String? senderId,
    String? content,
    bool? isSynced,
    DateTime? createdAt,
  }) => Message(
    id: id ?? this.id,
    roomId: roomId ?? this.roomId,
    senderId: senderId ?? this.senderId,
    content: content ?? this.content,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
  );
  Message copyWithCompanion(MessagesCompanion data) {
    return Message(
      id: data.id.present ? data.id.value : this.id,
      roomId: data.roomId.present ? data.roomId.value : this.roomId,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      content: data.content.present ? data.content.value : this.content,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Message(')
          ..write('id: $id, ')
          ..write('roomId: $roomId, ')
          ..write('senderId: $senderId, ')
          ..write('content: $content, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, roomId, senderId, content, isSynced, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          other.id == this.id &&
          other.roomId == this.roomId &&
          other.senderId == this.senderId &&
          other.content == this.content &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt);
}

class MessagesCompanion extends UpdateCompanion<Message> {
  final Value<String> id;
  final Value<String> roomId;
  final Value<String> senderId;
  final Value<String> content;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.roomId = const Value.absent(),
    this.senderId = const Value.absent(),
    this.content = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessagesCompanion.insert({
    required String id,
    required String roomId,
    required String senderId,
    required String content,
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       roomId = Value(roomId),
       senderId = Value(senderId),
       content = Value(content);
  static Insertable<Message> custom({
    Expression<String>? id,
    Expression<String>? roomId,
    Expression<String>? senderId,
    Expression<String>? content,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (roomId != null) 'room_id': roomId,
      if (senderId != null) 'sender_id': senderId,
      if (content != null) 'content': content,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? roomId,
    Value<String>? senderId,
    Value<String>? content,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MessagesCompanion(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (roomId.present) {
      map['room_id'] = Variable<String>(roomId.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('roomId: $roomId, ')
          ..write('senderId: $senderId, ')
          ..write('content: $content, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatDetailsTableTable extends ChatDetailsTable
    with TableInfo<$ChatDetailsTableTable, ChatDetailsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatDetailsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _adminIdMeta = const VerificationMeta(
    'adminId',
  );
  @override
  late final GeneratedColumn<String> adminId = GeneratedColumn<String>(
    'admin_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    imageUrl,
    adminId,
    type,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_details_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatDetailsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('admin_id')) {
      context.handle(
        _adminIdMeta,
        adminId.isAcceptableOrUnknown(data['admin_id']!, _adminIdMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatDetailsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatDetailsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      adminId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}admin_id'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $ChatDetailsTableTable createAlias(String alias) {
    return $ChatDetailsTableTable(attachedDatabase, alias);
  }
}

class ChatDetailsTableData extends DataClass
    implements Insertable<ChatDetailsTableData> {
  final String id;
  final String name;
  final String? imageUrl;
  final String? adminId;
  final String type;
  final String? description;
  const ChatDetailsTableData({
    required this.id,
    required this.name,
    this.imageUrl,
    this.adminId,
    required this.type,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || adminId != null) {
      map['admin_id'] = Variable<String>(adminId);
    }
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  ChatDetailsTableCompanion toCompanion(bool nullToAbsent) {
    return ChatDetailsTableCompanion(
      id: Value(id),
      name: Value(name),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      adminId: adminId == null && nullToAbsent
          ? const Value.absent()
          : Value(adminId),
      type: Value(type),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory ChatDetailsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatDetailsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      adminId: serializer.fromJson<String?>(json['adminId']),
      type: serializer.fromJson<String>(json['type']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'adminId': serializer.toJson<String?>(adminId),
      'type': serializer.toJson<String>(type),
      'description': serializer.toJson<String?>(description),
    };
  }

  ChatDetailsTableData copyWith({
    String? id,
    String? name,
    Value<String?> imageUrl = const Value.absent(),
    Value<String?> adminId = const Value.absent(),
    String? type,
    Value<String?> description = const Value.absent(),
  }) => ChatDetailsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    adminId: adminId.present ? adminId.value : this.adminId,
    type: type ?? this.type,
    description: description.present ? description.value : this.description,
  );
  ChatDetailsTableData copyWithCompanion(ChatDetailsTableCompanion data) {
    return ChatDetailsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      adminId: data.adminId.present ? data.adminId.value : this.adminId,
      type: data.type.present ? data.type.value : this.type,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatDetailsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('adminId: $adminId, ')
          ..write('type: $type, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, imageUrl, adminId, type, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatDetailsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.imageUrl == this.imageUrl &&
          other.adminId == this.adminId &&
          other.type == this.type &&
          other.description == this.description);
}

class ChatDetailsTableCompanion extends UpdateCompanion<ChatDetailsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> imageUrl;
  final Value<String?> adminId;
  final Value<String> type;
  final Value<String?> description;
  final Value<int> rowid;
  const ChatDetailsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.adminId = const Value.absent(),
    this.type = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatDetailsTableCompanion.insert({
    required String id,
    required String name,
    this.imageUrl = const Value.absent(),
    this.adminId = const Value.absent(),
    required String type,
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type);
  static Insertable<ChatDetailsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? imageUrl,
    Expression<String>? adminId,
    Expression<String>? type,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (imageUrl != null) 'image_url': imageUrl,
      if (adminId != null) 'admin_id': adminId,
      if (type != null) 'type': type,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatDetailsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? imageUrl,
    Value<String?>? adminId,
    Value<String>? type,
    Value<String?>? description,
    Value<int>? rowid,
  }) {
    return ChatDetailsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      adminId: adminId ?? this.adminId,
      type: type ?? this.type,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (adminId.present) {
      map['admin_id'] = Variable<String>(adminId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatDetailsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('adminId: $adminId, ')
          ..write('type: $type, ')
          ..write('description: $description, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChatMembersTableTable extends ChatMembersTable
    with TableInfo<$ChatMembersTableTable, ChatMembersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMembersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chatIdMeta = const VerificationMeta('chatId');
  @override
  late final GeneratedColumn<String> chatId = GeneratedColumn<String>(
    'chat_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chat_details_table (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [userId, chatId, name, avatarUrl, role];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chat_members_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatMembersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('chat_id')) {
      context.handle(
        _chatIdMeta,
        chatId.isAcceptableOrUnknown(data['chat_id']!, _chatIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chatIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, chatId};
  @override
  ChatMembersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMembersTableData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      chatId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chat_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
    );
  }

  @override
  $ChatMembersTableTable createAlias(String alias) {
    return $ChatMembersTableTable(attachedDatabase, alias);
  }
}

class ChatMembersTableData extends DataClass
    implements Insertable<ChatMembersTableData> {
  final String userId;
  final String chatId;
  final String? name;
  final String? avatarUrl;
  final String role;
  const ChatMembersTableData({
    required this.userId,
    required this.chatId,
    this.name,
    this.avatarUrl,
    required this.role,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['chat_id'] = Variable<String>(chatId);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    map['role'] = Variable<String>(role);
    return map;
  }

  ChatMembersTableCompanion toCompanion(bool nullToAbsent) {
    return ChatMembersTableCompanion(
      userId: Value(userId),
      chatId: Value(chatId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      role: Value(role),
    );
  }

  factory ChatMembersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMembersTableData(
      userId: serializer.fromJson<String>(json['userId']),
      chatId: serializer.fromJson<String>(json['chatId']),
      name: serializer.fromJson<String?>(json['name']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      role: serializer.fromJson<String>(json['role']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'chatId': serializer.toJson<String>(chatId),
      'name': serializer.toJson<String?>(name),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'role': serializer.toJson<String>(role),
    };
  }

  ChatMembersTableData copyWith({
    String? userId,
    String? chatId,
    Value<String?> name = const Value.absent(),
    Value<String?> avatarUrl = const Value.absent(),
    String? role,
  }) => ChatMembersTableData(
    userId: userId ?? this.userId,
    chatId: chatId ?? this.chatId,
    name: name.present ? name.value : this.name,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    role: role ?? this.role,
  );
  ChatMembersTableData copyWithCompanion(ChatMembersTableCompanion data) {
    return ChatMembersTableData(
      userId: data.userId.present ? data.userId.value : this.userId,
      chatId: data.chatId.present ? data.chatId.value : this.chatId,
      name: data.name.present ? data.name.value : this.name,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      role: data.role.present ? data.role.value : this.role,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChatMembersTableData(')
          ..write('userId: $userId, ')
          ..write('chatId: $chatId, ')
          ..write('name: $name, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('role: $role')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, chatId, name, avatarUrl, role);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMembersTableData &&
          other.userId == this.userId &&
          other.chatId == this.chatId &&
          other.name == this.name &&
          other.avatarUrl == this.avatarUrl &&
          other.role == this.role);
}

class ChatMembersTableCompanion extends UpdateCompanion<ChatMembersTableData> {
  final Value<String> userId;
  final Value<String> chatId;
  final Value<String?> name;
  final Value<String?> avatarUrl;
  final Value<String> role;
  final Value<int> rowid;
  const ChatMembersTableCompanion({
    this.userId = const Value.absent(),
    this.chatId = const Value.absent(),
    this.name = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.role = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChatMembersTableCompanion.insert({
    required String userId,
    required String chatId,
    this.name = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    required String role,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       chatId = Value(chatId),
       role = Value(role);
  static Insertable<ChatMembersTableData> custom({
    Expression<String>? userId,
    Expression<String>? chatId,
    Expression<String>? name,
    Expression<String>? avatarUrl,
    Expression<String>? role,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (chatId != null) 'chat_id': chatId,
      if (name != null) 'name': name,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (role != null) 'role': role,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChatMembersTableCompanion copyWith({
    Value<String>? userId,
    Value<String>? chatId,
    Value<String?>? name,
    Value<String?>? avatarUrl,
    Value<String>? role,
    Value<int>? rowid,
  }) {
    return ChatMembersTableCompanion(
      userId: userId ?? this.userId,
      chatId: chatId ?? this.chatId,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (chatId.present) {
      map['chat_id'] = Variable<String>(chatId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMembersTableCompanion(')
          ..write('userId: $userId, ')
          ..write('chatId: $chatId, ')
          ..write('name: $name, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('role: $role, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ChatRoomsTable chatRooms = $ChatRoomsTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  late final $ChatDetailsTableTable chatDetailsTable = $ChatDetailsTableTable(
    this,
  );
  late final $ChatMembersTableTable chatMembersTable = $ChatMembersTableTable(
    this,
  );
  late final ChatRoomsDao chatRoomsDao = ChatRoomsDao(this as AppDatabase);
  late final MessagesDao messagesDao = MessagesDao(this as AppDatabase);
  late final ChatDetailsDao chatDetailsDao = ChatDetailsDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    chatRooms,
    messages,
    chatDetailsTable,
    chatMembersTable,
  ];
}

typedef $$ChatRoomsTableCreateCompanionBuilder =
    ChatRoomsCompanion Function({
      required String roomId,
      required String name,
      Value<String?> location,
      Value<int> userCount,
      Value<bool> isLive,
      Value<int> rowid,
    });
typedef $$ChatRoomsTableUpdateCompanionBuilder =
    ChatRoomsCompanion Function({
      Value<String> roomId,
      Value<String> name,
      Value<String?> location,
      Value<int> userCount,
      Value<bool> isLive,
      Value<int> rowid,
    });

class $$ChatRoomsTableFilterComposer
    extends Composer<_$AppDatabase, $ChatRoomsTable> {
  $$ChatRoomsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get roomId => $composableBuilder(
    column: $table.roomId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userCount => $composableBuilder(
    column: $table.userCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLive => $composableBuilder(
    column: $table.isLive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChatRoomsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatRoomsTable> {
  $$ChatRoomsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get roomId => $composableBuilder(
    column: $table.roomId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userCount => $composableBuilder(
    column: $table.userCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLive => $composableBuilder(
    column: $table.isLive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatRoomsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatRoomsTable> {
  $$ChatRoomsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get roomId =>
      $composableBuilder(column: $table.roomId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<int> get userCount =>
      $composableBuilder(column: $table.userCount, builder: (column) => column);

  GeneratedColumn<bool> get isLive =>
      $composableBuilder(column: $table.isLive, builder: (column) => column);
}

class $$ChatRoomsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatRoomsTable,
          ChatRoom,
          $$ChatRoomsTableFilterComposer,
          $$ChatRoomsTableOrderingComposer,
          $$ChatRoomsTableAnnotationComposer,
          $$ChatRoomsTableCreateCompanionBuilder,
          $$ChatRoomsTableUpdateCompanionBuilder,
          (ChatRoom, BaseReferences<_$AppDatabase, $ChatRoomsTable, ChatRoom>),
          ChatRoom,
          PrefetchHooks Function()
        > {
  $$ChatRoomsTableTableManager(_$AppDatabase db, $ChatRoomsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatRoomsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatRoomsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatRoomsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> roomId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<int> userCount = const Value.absent(),
                Value<bool> isLive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatRoomsCompanion(
                roomId: roomId,
                name: name,
                location: location,
                userCount: userCount,
                isLive: isLive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String roomId,
                required String name,
                Value<String?> location = const Value.absent(),
                Value<int> userCount = const Value.absent(),
                Value<bool> isLive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatRoomsCompanion.insert(
                roomId: roomId,
                name: name,
                location: location,
                userCount: userCount,
                isLive: isLive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChatRoomsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatRoomsTable,
      ChatRoom,
      $$ChatRoomsTableFilterComposer,
      $$ChatRoomsTableOrderingComposer,
      $$ChatRoomsTableAnnotationComposer,
      $$ChatRoomsTableCreateCompanionBuilder,
      $$ChatRoomsTableUpdateCompanionBuilder,
      (ChatRoom, BaseReferences<_$AppDatabase, $ChatRoomsTable, ChatRoom>),
      ChatRoom,
      PrefetchHooks Function()
    >;
typedef $$MessagesTableCreateCompanionBuilder =
    MessagesCompanion Function({
      required String id,
      required String roomId,
      required String senderId,
      required String content,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$MessagesTableUpdateCompanionBuilder =
    MessagesCompanion Function({
      Value<String> id,
      Value<String> roomId,
      Value<String> senderId,
      Value<String> content,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$MessagesTableFilterComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableFilterComposer({
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

  ColumnFilters<String> get roomId => $composableBuilder(
    column: $table.roomId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableOrderingComposer({
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

  ColumnOrderings<String> get roomId => $composableBuilder(
    column: $table.roomId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get roomId =>
      $composableBuilder(column: $table.roomId, builder: (column) => column);

  GeneratedColumn<String> get senderId =>
      $composableBuilder(column: $table.senderId, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessagesTable,
          Message,
          $$MessagesTableFilterComposer,
          $$MessagesTableOrderingComposer,
          $$MessagesTableAnnotationComposer,
          $$MessagesTableCreateCompanionBuilder,
          $$MessagesTableUpdateCompanionBuilder,
          (Message, BaseReferences<_$AppDatabase, $MessagesTable, Message>),
          Message,
          PrefetchHooks Function()
        > {
  $$MessagesTableTableManager(_$AppDatabase db, $MessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> roomId = const Value.absent(),
                Value<String> senderId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessagesCompanion(
                id: id,
                roomId: roomId,
                senderId: senderId,
                content: content,
                isSynced: isSynced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String roomId,
                required String senderId,
                required String content,
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessagesCompanion.insert(
                id: id,
                roomId: roomId,
                senderId: senderId,
                content: content,
                isSynced: isSynced,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessagesTable,
      Message,
      $$MessagesTableFilterComposer,
      $$MessagesTableOrderingComposer,
      $$MessagesTableAnnotationComposer,
      $$MessagesTableCreateCompanionBuilder,
      $$MessagesTableUpdateCompanionBuilder,
      (Message, BaseReferences<_$AppDatabase, $MessagesTable, Message>),
      Message,
      PrefetchHooks Function()
    >;
typedef $$ChatDetailsTableTableCreateCompanionBuilder =
    ChatDetailsTableCompanion Function({
      required String id,
      required String name,
      Value<String?> imageUrl,
      Value<String?> adminId,
      required String type,
      Value<String?> description,
      Value<int> rowid,
    });
typedef $$ChatDetailsTableTableUpdateCompanionBuilder =
    ChatDetailsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> imageUrl,
      Value<String?> adminId,
      Value<String> type,
      Value<String?> description,
      Value<int> rowid,
    });

final class $$ChatDetailsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ChatDetailsTableTable,
          ChatDetailsTableData
        > {
  $$ChatDetailsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ChatMembersTableTable, List<ChatMembersTableData>>
  _chatMembersTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.chatMembersTable,
    aliasName: $_aliasNameGenerator(
      db.chatDetailsTable.id,
      db.chatMembersTable.chatId,
    ),
  );

  $$ChatMembersTableTableProcessedTableManager get chatMembersTableRefs {
    final manager = $$ChatMembersTableTableTableManager(
      $_db,
      $_db.chatMembersTable,
    ).filter((f) => f.chatId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _chatMembersTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChatDetailsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChatDetailsTableTable> {
  $$ChatDetailsTableTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get adminId => $composableBuilder(
    column: $table.adminId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> chatMembersTableRefs(
    Expression<bool> Function($$ChatMembersTableTableFilterComposer f) f,
  ) {
    final $$ChatMembersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chatMembersTable,
      getReferencedColumn: (t) => t.chatId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatMembersTableTableFilterComposer(
            $db: $db,
            $table: $db.chatMembersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChatDetailsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatDetailsTableTable> {
  $$ChatDetailsTableTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get adminId => $composableBuilder(
    column: $table.adminId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChatDetailsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatDetailsTableTable> {
  $$ChatDetailsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get adminId =>
      $composableBuilder(column: $table.adminId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  Expression<T> chatMembersTableRefs<T extends Object>(
    Expression<T> Function($$ChatMembersTableTableAnnotationComposer a) f,
  ) {
    final $$ChatMembersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chatMembersTable,
      getReferencedColumn: (t) => t.chatId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatMembersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.chatMembersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChatDetailsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatDetailsTableTable,
          ChatDetailsTableData,
          $$ChatDetailsTableTableFilterComposer,
          $$ChatDetailsTableTableOrderingComposer,
          $$ChatDetailsTableTableAnnotationComposer,
          $$ChatDetailsTableTableCreateCompanionBuilder,
          $$ChatDetailsTableTableUpdateCompanionBuilder,
          (ChatDetailsTableData, $$ChatDetailsTableTableReferences),
          ChatDetailsTableData,
          PrefetchHooks Function({bool chatMembersTableRefs})
        > {
  $$ChatDetailsTableTableTableManager(
    _$AppDatabase db,
    $ChatDetailsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatDetailsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatDetailsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatDetailsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> adminId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatDetailsTableCompanion(
                id: id,
                name: name,
                imageUrl: imageUrl,
                adminId: adminId,
                type: type,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> adminId = const Value.absent(),
                required String type,
                Value<String?> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatDetailsTableCompanion.insert(
                id: id,
                name: name,
                imageUrl: imageUrl,
                adminId: adminId,
                type: type,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChatDetailsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chatMembersTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (chatMembersTableRefs) db.chatMembersTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (chatMembersTableRefs)
                    await $_getPrefetchedData<
                      ChatDetailsTableData,
                      $ChatDetailsTableTable,
                      ChatMembersTableData
                    >(
                      currentTable: table,
                      referencedTable: $$ChatDetailsTableTableReferences
                          ._chatMembersTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ChatDetailsTableTableReferences(
                            db,
                            table,
                            p0,
                          ).chatMembersTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.chatId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ChatDetailsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatDetailsTableTable,
      ChatDetailsTableData,
      $$ChatDetailsTableTableFilterComposer,
      $$ChatDetailsTableTableOrderingComposer,
      $$ChatDetailsTableTableAnnotationComposer,
      $$ChatDetailsTableTableCreateCompanionBuilder,
      $$ChatDetailsTableTableUpdateCompanionBuilder,
      (ChatDetailsTableData, $$ChatDetailsTableTableReferences),
      ChatDetailsTableData,
      PrefetchHooks Function({bool chatMembersTableRefs})
    >;
typedef $$ChatMembersTableTableCreateCompanionBuilder =
    ChatMembersTableCompanion Function({
      required String userId,
      required String chatId,
      Value<String?> name,
      Value<String?> avatarUrl,
      required String role,
      Value<int> rowid,
    });
typedef $$ChatMembersTableTableUpdateCompanionBuilder =
    ChatMembersTableCompanion Function({
      Value<String> userId,
      Value<String> chatId,
      Value<String?> name,
      Value<String?> avatarUrl,
      Value<String> role,
      Value<int> rowid,
    });

final class $$ChatMembersTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ChatMembersTableTable,
          ChatMembersTableData
        > {
  $$ChatMembersTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ChatDetailsTableTable _chatIdTable(_$AppDatabase db) =>
      db.chatDetailsTable.createAlias(
        $_aliasNameGenerator(
          db.chatMembersTable.chatId,
          db.chatDetailsTable.id,
        ),
      );

  $$ChatDetailsTableTableProcessedTableManager get chatId {
    final $_column = $_itemColumn<String>('chat_id')!;

    final manager = $$ChatDetailsTableTableTableManager(
      $_db,
      $_db.chatDetailsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chatIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChatMembersTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChatMembersTableTable> {
  $$ChatMembersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  $$ChatDetailsTableTableFilterComposer get chatId {
    final $$ChatDetailsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chatDetailsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatDetailsTableTableFilterComposer(
            $db: $db,
            $table: $db.chatDetailsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChatMembersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatMembersTableTable> {
  $$ChatMembersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChatDetailsTableTableOrderingComposer get chatId {
    final $$ChatDetailsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chatDetailsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatDetailsTableTableOrderingComposer(
            $db: $db,
            $table: $db.chatDetailsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChatMembersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatMembersTableTable> {
  $$ChatMembersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  $$ChatDetailsTableTableAnnotationComposer get chatId {
    final $$ChatDetailsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chatDetailsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatDetailsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.chatDetailsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChatMembersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatMembersTableTable,
          ChatMembersTableData,
          $$ChatMembersTableTableFilterComposer,
          $$ChatMembersTableTableOrderingComposer,
          $$ChatMembersTableTableAnnotationComposer,
          $$ChatMembersTableTableCreateCompanionBuilder,
          $$ChatMembersTableTableUpdateCompanionBuilder,
          (ChatMembersTableData, $$ChatMembersTableTableReferences),
          ChatMembersTableData,
          PrefetchHooks Function({bool chatId})
        > {
  $$ChatMembersTableTableTableManager(
    _$AppDatabase db,
    $ChatMembersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatMembersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatMembersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatMembersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> chatId = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChatMembersTableCompanion(
                userId: userId,
                chatId: chatId,
                name: name,
                avatarUrl: avatarUrl,
                role: role,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String chatId,
                Value<String?> name = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                required String role,
                Value<int> rowid = const Value.absent(),
              }) => ChatMembersTableCompanion.insert(
                userId: userId,
                chatId: chatId,
                name: name,
                avatarUrl: avatarUrl,
                role: role,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChatMembersTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chatId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (chatId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chatId,
                                referencedTable:
                                    $$ChatMembersTableTableReferences
                                        ._chatIdTable(db),
                                referencedColumn:
                                    $$ChatMembersTableTableReferences
                                        ._chatIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ChatMembersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatMembersTableTable,
      ChatMembersTableData,
      $$ChatMembersTableTableFilterComposer,
      $$ChatMembersTableTableOrderingComposer,
      $$ChatMembersTableTableAnnotationComposer,
      $$ChatMembersTableTableCreateCompanionBuilder,
      $$ChatMembersTableTableUpdateCompanionBuilder,
      (ChatMembersTableData, $$ChatMembersTableTableReferences),
      ChatMembersTableData,
      PrefetchHooks Function({bool chatId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ChatRoomsTableTableManager get chatRooms =>
      $$ChatRoomsTableTableManager(_db, _db.chatRooms);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db, _db.messages);
  $$ChatDetailsTableTableTableManager get chatDetailsTable =>
      $$ChatDetailsTableTableTableManager(_db, _db.chatDetailsTable);
  $$ChatMembersTableTableTableManager get chatMembersTable =>
      $$ChatMembersTableTableTableManager(_db, _db.chatMembersTable);
}
