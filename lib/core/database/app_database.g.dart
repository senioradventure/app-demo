// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CircleMessagesTable extends CircleMessages
    with TableInfo<$CircleMessagesTable, CircleMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CircleMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _circleIdMeta = const VerificationMeta(
    'circleId',
  );
  @override
  late final GeneratedColumn<String> circleId = GeneratedColumn<String>(
    'circle_id',
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
  static const VerificationMeta _senderNameMeta = const VerificationMeta(
    'senderName',
  );
  @override
  late final GeneratedColumn<String> senderName = GeneratedColumn<String>(
    'sender_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaTypeMeta = const VerificationMeta(
    'mediaType',
  );
  @override
  late final GeneratedColumn<String> mediaType = GeneratedColumn<String>(
    'media_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('text'),
  );
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
    'avatar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mediaUrlMeta = const VerificationMeta(
    'mediaUrl',
  );
  @override
  late final GeneratedColumn<String> mediaUrl = GeneratedColumn<String>(
    'media_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _replyToMessageIdMeta = const VerificationMeta(
    'replyToMessageId',
  );
  @override
  late final GeneratedColumn<String> replyToMessageId = GeneratedColumn<String>(
    'reply_to_message_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isStarredMeta = const VerificationMeta(
    'isStarred',
  );
  @override
  late final GeneratedColumn<bool> isStarred = GeneratedColumn<bool>(
    'is_starred',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_starred" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reactionsJsonMeta = const VerificationMeta(
    'reactionsJson',
  );
  @override
  late final GeneratedColumn<String> reactionsJson = GeneratedColumn<String>(
    'reactions_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _repliesJsonMeta = const VerificationMeta(
    'repliesJson',
  );
  @override
  late final GeneratedColumn<String> repliesJson = GeneratedColumn<String>(
    'replies_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    circleId,
    senderId,
    senderName,
    mediaType,
    avatar,
    content,
    mediaUrl,
    createdAt,
    replyToMessageId,
    isStarred,
    reactionsJson,
    repliesJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'circle_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<CircleMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('circle_id')) {
      context.handle(
        _circleIdMeta,
        circleId.isAcceptableOrUnknown(data['circle_id']!, _circleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_circleIdMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(
        _senderIdMeta,
        senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('sender_name')) {
      context.handle(
        _senderNameMeta,
        senderName.isAcceptableOrUnknown(data['sender_name']!, _senderNameMeta),
      );
    } else if (isInserting) {
      context.missing(_senderNameMeta);
    }
    if (data.containsKey('media_type')) {
      context.handle(
        _mediaTypeMeta,
        mediaType.isAcceptableOrUnknown(data['media_type']!, _mediaTypeMeta),
      );
    }
    if (data.containsKey('avatar')) {
      context.handle(
        _avatarMeta,
        avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('media_url')) {
      context.handle(
        _mediaUrlMeta,
        mediaUrl.isAcceptableOrUnknown(data['media_url']!, _mediaUrlMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('reply_to_message_id')) {
      context.handle(
        _replyToMessageIdMeta,
        replyToMessageId.isAcceptableOrUnknown(
          data['reply_to_message_id']!,
          _replyToMessageIdMeta,
        ),
      );
    }
    if (data.containsKey('is_starred')) {
      context.handle(
        _isStarredMeta,
        isStarred.isAcceptableOrUnknown(data['is_starred']!, _isStarredMeta),
      );
    }
    if (data.containsKey('reactions_json')) {
      context.handle(
        _reactionsJsonMeta,
        reactionsJson.isAcceptableOrUnknown(
          data['reactions_json']!,
          _reactionsJsonMeta,
        ),
      );
    }
    if (data.containsKey('replies_json')) {
      context.handle(
        _repliesJsonMeta,
        repliesJson.isAcceptableOrUnknown(
          data['replies_json']!,
          _repliesJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CircleMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CircleMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      circleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}circle_id'],
      )!,
      senderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_id'],
      )!,
      senderName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_name'],
      )!,
      mediaType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_type'],
      )!,
      avatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      mediaUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_url'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      replyToMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reply_to_message_id'],
      ),
      isStarred: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_starred'],
      )!,
      reactionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reactions_json'],
      )!,
      repliesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}replies_json'],
      )!,
    );
  }

  @override
  $CircleMessagesTable createAlias(String alias) {
    return $CircleMessagesTable(attachedDatabase, alias);
  }
}

class CircleMessage extends DataClass implements Insertable<CircleMessage> {
  final String id;
  final String circleId;
  final String senderId;
  final String senderName;
  final String mediaType;
  final String? avatar;
  final String? content;
  final String? mediaUrl;
  final DateTime createdAt;
  final String? replyToMessageId;
  final bool isStarred;
  final String reactionsJson;
  final String repliesJson;
  const CircleMessage({
    required this.id,
    required this.circleId,
    required this.senderId,
    required this.senderName,
    required this.mediaType,
    this.avatar,
    this.content,
    this.mediaUrl,
    required this.createdAt,
    this.replyToMessageId,
    required this.isStarred,
    required this.reactionsJson,
    required this.repliesJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['circle_id'] = Variable<String>(circleId);
    map['sender_id'] = Variable<String>(senderId);
    map['sender_name'] = Variable<String>(senderName);
    map['media_type'] = Variable<String>(mediaType);
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    if (!nullToAbsent || mediaUrl != null) {
      map['media_url'] = Variable<String>(mediaUrl);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || replyToMessageId != null) {
      map['reply_to_message_id'] = Variable<String>(replyToMessageId);
    }
    map['is_starred'] = Variable<bool>(isStarred);
    map['reactions_json'] = Variable<String>(reactionsJson);
    map['replies_json'] = Variable<String>(repliesJson);
    return map;
  }

  CircleMessagesCompanion toCompanion(bool nullToAbsent) {
    return CircleMessagesCompanion(
      id: Value(id),
      circleId: Value(circleId),
      senderId: Value(senderId),
      senderName: Value(senderName),
      mediaType: Value(mediaType),
      avatar: avatar == null && nullToAbsent
          ? const Value.absent()
          : Value(avatar),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      mediaUrl: mediaUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaUrl),
      createdAt: Value(createdAt),
      replyToMessageId: replyToMessageId == null && nullToAbsent
          ? const Value.absent()
          : Value(replyToMessageId),
      isStarred: Value(isStarred),
      reactionsJson: Value(reactionsJson),
      repliesJson: Value(repliesJson),
    );
  }

  factory CircleMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CircleMessage(
      id: serializer.fromJson<String>(json['id']),
      circleId: serializer.fromJson<String>(json['circleId']),
      senderId: serializer.fromJson<String>(json['senderId']),
      senderName: serializer.fromJson<String>(json['senderName']),
      mediaType: serializer.fromJson<String>(json['mediaType']),
      avatar: serializer.fromJson<String?>(json['avatar']),
      content: serializer.fromJson<String?>(json['content']),
      mediaUrl: serializer.fromJson<String?>(json['mediaUrl']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      replyToMessageId: serializer.fromJson<String?>(json['replyToMessageId']),
      isStarred: serializer.fromJson<bool>(json['isStarred']),
      reactionsJson: serializer.fromJson<String>(json['reactionsJson']),
      repliesJson: serializer.fromJson<String>(json['repliesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'circleId': serializer.toJson<String>(circleId),
      'senderId': serializer.toJson<String>(senderId),
      'senderName': serializer.toJson<String>(senderName),
      'mediaType': serializer.toJson<String>(mediaType),
      'avatar': serializer.toJson<String?>(avatar),
      'content': serializer.toJson<String?>(content),
      'mediaUrl': serializer.toJson<String?>(mediaUrl),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'replyToMessageId': serializer.toJson<String?>(replyToMessageId),
      'isStarred': serializer.toJson<bool>(isStarred),
      'reactionsJson': serializer.toJson<String>(reactionsJson),
      'repliesJson': serializer.toJson<String>(repliesJson),
    };
  }

  CircleMessage copyWith({
    String? id,
    String? circleId,
    String? senderId,
    String? senderName,
    String? mediaType,
    Value<String?> avatar = const Value.absent(),
    Value<String?> content = const Value.absent(),
    Value<String?> mediaUrl = const Value.absent(),
    DateTime? createdAt,
    Value<String?> replyToMessageId = const Value.absent(),
    bool? isStarred,
    String? reactionsJson,
    String? repliesJson,
  }) => CircleMessage(
    id: id ?? this.id,
    circleId: circleId ?? this.circleId,
    senderId: senderId ?? this.senderId,
    senderName: senderName ?? this.senderName,
    mediaType: mediaType ?? this.mediaType,
    avatar: avatar.present ? avatar.value : this.avatar,
    content: content.present ? content.value : this.content,
    mediaUrl: mediaUrl.present ? mediaUrl.value : this.mediaUrl,
    createdAt: createdAt ?? this.createdAt,
    replyToMessageId: replyToMessageId.present
        ? replyToMessageId.value
        : this.replyToMessageId,
    isStarred: isStarred ?? this.isStarred,
    reactionsJson: reactionsJson ?? this.reactionsJson,
    repliesJson: repliesJson ?? this.repliesJson,
  );
  CircleMessage copyWithCompanion(CircleMessagesCompanion data) {
    return CircleMessage(
      id: data.id.present ? data.id.value : this.id,
      circleId: data.circleId.present ? data.circleId.value : this.circleId,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      senderName: data.senderName.present
          ? data.senderName.value
          : this.senderName,
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
      content: data.content.present ? data.content.value : this.content,
      mediaUrl: data.mediaUrl.present ? data.mediaUrl.value : this.mediaUrl,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      replyToMessageId: data.replyToMessageId.present
          ? data.replyToMessageId.value
          : this.replyToMessageId,
      isStarred: data.isStarred.present ? data.isStarred.value : this.isStarred,
      reactionsJson: data.reactionsJson.present
          ? data.reactionsJson.value
          : this.reactionsJson,
      repliesJson: data.repliesJson.present
          ? data.repliesJson.value
          : this.repliesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CircleMessage(')
          ..write('id: $id, ')
          ..write('circleId: $circleId, ')
          ..write('senderId: $senderId, ')
          ..write('senderName: $senderName, ')
          ..write('mediaType: $mediaType, ')
          ..write('avatar: $avatar, ')
          ..write('content: $content, ')
          ..write('mediaUrl: $mediaUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('replyToMessageId: $replyToMessageId, ')
          ..write('isStarred: $isStarred, ')
          ..write('reactionsJson: $reactionsJson, ')
          ..write('repliesJson: $repliesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    circleId,
    senderId,
    senderName,
    mediaType,
    avatar,
    content,
    mediaUrl,
    createdAt,
    replyToMessageId,
    isStarred,
    reactionsJson,
    repliesJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CircleMessage &&
          other.id == this.id &&
          other.circleId == this.circleId &&
          other.senderId == this.senderId &&
          other.senderName == this.senderName &&
          other.mediaType == this.mediaType &&
          other.avatar == this.avatar &&
          other.content == this.content &&
          other.mediaUrl == this.mediaUrl &&
          other.createdAt == this.createdAt &&
          other.replyToMessageId == this.replyToMessageId &&
          other.isStarred == this.isStarred &&
          other.reactionsJson == this.reactionsJson &&
          other.repliesJson == this.repliesJson);
}

class CircleMessagesCompanion extends UpdateCompanion<CircleMessage> {
  final Value<String> id;
  final Value<String> circleId;
  final Value<String> senderId;
  final Value<String> senderName;
  final Value<String> mediaType;
  final Value<String?> avatar;
  final Value<String?> content;
  final Value<String?> mediaUrl;
  final Value<DateTime> createdAt;
  final Value<String?> replyToMessageId;
  final Value<bool> isStarred;
  final Value<String> reactionsJson;
  final Value<String> repliesJson;
  final Value<int> rowid;
  const CircleMessagesCompanion({
    this.id = const Value.absent(),
    this.circleId = const Value.absent(),
    this.senderId = const Value.absent(),
    this.senderName = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.avatar = const Value.absent(),
    this.content = const Value.absent(),
    this.mediaUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.replyToMessageId = const Value.absent(),
    this.isStarred = const Value.absent(),
    this.reactionsJson = const Value.absent(),
    this.repliesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CircleMessagesCompanion.insert({
    required String id,
    required String circleId,
    required String senderId,
    required String senderName,
    this.mediaType = const Value.absent(),
    this.avatar = const Value.absent(),
    this.content = const Value.absent(),
    this.mediaUrl = const Value.absent(),
    required DateTime createdAt,
    this.replyToMessageId = const Value.absent(),
    this.isStarred = const Value.absent(),
    this.reactionsJson = const Value.absent(),
    this.repliesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       circleId = Value(circleId),
       senderId = Value(senderId),
       senderName = Value(senderName),
       createdAt = Value(createdAt);
  static Insertable<CircleMessage> custom({
    Expression<String>? id,
    Expression<String>? circleId,
    Expression<String>? senderId,
    Expression<String>? senderName,
    Expression<String>? mediaType,
    Expression<String>? avatar,
    Expression<String>? content,
    Expression<String>? mediaUrl,
    Expression<DateTime>? createdAt,
    Expression<String>? replyToMessageId,
    Expression<bool>? isStarred,
    Expression<String>? reactionsJson,
    Expression<String>? repliesJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (circleId != null) 'circle_id': circleId,
      if (senderId != null) 'sender_id': senderId,
      if (senderName != null) 'sender_name': senderName,
      if (mediaType != null) 'media_type': mediaType,
      if (avatar != null) 'avatar': avatar,
      if (content != null) 'content': content,
      if (mediaUrl != null) 'media_url': mediaUrl,
      if (createdAt != null) 'created_at': createdAt,
      if (replyToMessageId != null) 'reply_to_message_id': replyToMessageId,
      if (isStarred != null) 'is_starred': isStarred,
      if (reactionsJson != null) 'reactions_json': reactionsJson,
      if (repliesJson != null) 'replies_json': repliesJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CircleMessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? circleId,
    Value<String>? senderId,
    Value<String>? senderName,
    Value<String>? mediaType,
    Value<String?>? avatar,
    Value<String?>? content,
    Value<String?>? mediaUrl,
    Value<DateTime>? createdAt,
    Value<String?>? replyToMessageId,
    Value<bool>? isStarred,
    Value<String>? reactionsJson,
    Value<String>? repliesJson,
    Value<int>? rowid,
  }) {
    return CircleMessagesCompanion(
      id: id ?? this.id,
      circleId: circleId ?? this.circleId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      mediaType: mediaType ?? this.mediaType,
      avatar: avatar ?? this.avatar,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      createdAt: createdAt ?? this.createdAt,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      isStarred: isStarred ?? this.isStarred,
      reactionsJson: reactionsJson ?? this.reactionsJson,
      repliesJson: repliesJson ?? this.repliesJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (circleId.present) {
      map['circle_id'] = Variable<String>(circleId.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (senderName.present) {
      map['sender_name'] = Variable<String>(senderName.value);
    }
    if (mediaType.present) {
      map['media_type'] = Variable<String>(mediaType.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (mediaUrl.present) {
      map['media_url'] = Variable<String>(mediaUrl.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (replyToMessageId.present) {
      map['reply_to_message_id'] = Variable<String>(replyToMessageId.value);
    }
    if (isStarred.present) {
      map['is_starred'] = Variable<bool>(isStarred.value);
    }
    if (reactionsJson.present) {
      map['reactions_json'] = Variable<String>(reactionsJson.value);
    }
    if (repliesJson.present) {
      map['replies_json'] = Variable<String>(repliesJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CircleMessagesCompanion(')
          ..write('id: $id, ')
          ..write('circleId: $circleId, ')
          ..write('senderId: $senderId, ')
          ..write('senderName: $senderName, ')
          ..write('mediaType: $mediaType, ')
          ..write('avatar: $avatar, ')
          ..write('content: $content, ')
          ..write('mediaUrl: $mediaUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('replyToMessageId: $replyToMessageId, ')
          ..write('isStarred: $isStarred, ')
          ..write('reactionsJson: $reactionsJson, ')
          ..write('repliesJson: $repliesJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CircleMessagesTable circleMessages = $CircleMessagesTable(this);
  late final CircleMessagesDao circleMessagesDao = CircleMessagesDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [circleMessages];
}

typedef $$CircleMessagesTableCreateCompanionBuilder =
    CircleMessagesCompanion Function({
      required String id,
      required String circleId,
      required String senderId,
      required String senderName,
      Value<String> mediaType,
      Value<String?> avatar,
      Value<String?> content,
      Value<String?> mediaUrl,
      required DateTime createdAt,
      Value<String?> replyToMessageId,
      Value<bool> isStarred,
      Value<String> reactionsJson,
      Value<String> repliesJson,
      Value<int> rowid,
    });
typedef $$CircleMessagesTableUpdateCompanionBuilder =
    CircleMessagesCompanion Function({
      Value<String> id,
      Value<String> circleId,
      Value<String> senderId,
      Value<String> senderName,
      Value<String> mediaType,
      Value<String?> avatar,
      Value<String?> content,
      Value<String?> mediaUrl,
      Value<DateTime> createdAt,
      Value<String?> replyToMessageId,
      Value<bool> isStarred,
      Value<String> reactionsJson,
      Value<String> repliesJson,
      Value<int> rowid,
    });

class $$CircleMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $CircleMessagesTable> {
  $$CircleMessagesTableFilterComposer({
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

  ColumnFilters<String> get circleId => $composableBuilder(
    column: $table.circleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderName => $composableBuilder(
    column: $table.senderName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaUrl => $composableBuilder(
    column: $table.mediaUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get replyToMessageId => $composableBuilder(
    column: $table.replyToMessageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStarred => $composableBuilder(
    column: $table.isStarred,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reactionsJson => $composableBuilder(
    column: $table.reactionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repliesJson => $composableBuilder(
    column: $table.repliesJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CircleMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $CircleMessagesTable> {
  $$CircleMessagesTableOrderingComposer({
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

  ColumnOrderings<String> get circleId => $composableBuilder(
    column: $table.circleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderName => $composableBuilder(
    column: $table.senderName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaUrl => $composableBuilder(
    column: $table.mediaUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get replyToMessageId => $composableBuilder(
    column: $table.replyToMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStarred => $composableBuilder(
    column: $table.isStarred,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reactionsJson => $composableBuilder(
    column: $table.reactionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repliesJson => $composableBuilder(
    column: $table.repliesJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CircleMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CircleMessagesTable> {
  $$CircleMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get circleId =>
      $composableBuilder(column: $table.circleId, builder: (column) => column);

  GeneratedColumn<String> get senderId =>
      $composableBuilder(column: $table.senderId, builder: (column) => column);

  GeneratedColumn<String> get senderName => $composableBuilder(
    column: $table.senderName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get mediaUrl =>
      $composableBuilder(column: $table.mediaUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get replyToMessageId => $composableBuilder(
    column: $table.replyToMessageId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isStarred =>
      $composableBuilder(column: $table.isStarred, builder: (column) => column);

  GeneratedColumn<String> get reactionsJson => $composableBuilder(
    column: $table.reactionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repliesJson => $composableBuilder(
    column: $table.repliesJson,
    builder: (column) => column,
  );
}

class $$CircleMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CircleMessagesTable,
          CircleMessage,
          $$CircleMessagesTableFilterComposer,
          $$CircleMessagesTableOrderingComposer,
          $$CircleMessagesTableAnnotationComposer,
          $$CircleMessagesTableCreateCompanionBuilder,
          $$CircleMessagesTableUpdateCompanionBuilder,
          (
            CircleMessage,
            BaseReferences<_$AppDatabase, $CircleMessagesTable, CircleMessage>,
          ),
          CircleMessage,
          PrefetchHooks Function()
        > {
  $$CircleMessagesTableTableManager(
    _$AppDatabase db,
    $CircleMessagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CircleMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CircleMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CircleMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> circleId = const Value.absent(),
                Value<String> senderId = const Value.absent(),
                Value<String> senderName = const Value.absent(),
                Value<String> mediaType = const Value.absent(),
                Value<String?> avatar = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<String?> mediaUrl = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> replyToMessageId = const Value.absent(),
                Value<bool> isStarred = const Value.absent(),
                Value<String> reactionsJson = const Value.absent(),
                Value<String> repliesJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CircleMessagesCompanion(
                id: id,
                circleId: circleId,
                senderId: senderId,
                senderName: senderName,
                mediaType: mediaType,
                avatar: avatar,
                content: content,
                mediaUrl: mediaUrl,
                createdAt: createdAt,
                replyToMessageId: replyToMessageId,
                isStarred: isStarred,
                reactionsJson: reactionsJson,
                repliesJson: repliesJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String circleId,
                required String senderId,
                required String senderName,
                Value<String> mediaType = const Value.absent(),
                Value<String?> avatar = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<String?> mediaUrl = const Value.absent(),
                required DateTime createdAt,
                Value<String?> replyToMessageId = const Value.absent(),
                Value<bool> isStarred = const Value.absent(),
                Value<String> reactionsJson = const Value.absent(),
                Value<String> repliesJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CircleMessagesCompanion.insert(
                id: id,
                circleId: circleId,
                senderId: senderId,
                senderName: senderName,
                mediaType: mediaType,
                avatar: avatar,
                content: content,
                mediaUrl: mediaUrl,
                createdAt: createdAt,
                replyToMessageId: replyToMessageId,
                isStarred: isStarred,
                reactionsJson: reactionsJson,
                repliesJson: repliesJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CircleMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CircleMessagesTable,
      CircleMessage,
      $$CircleMessagesTableFilterComposer,
      $$CircleMessagesTableOrderingComposer,
      $$CircleMessagesTableAnnotationComposer,
      $$CircleMessagesTableCreateCompanionBuilder,
      $$CircleMessagesTableUpdateCompanionBuilder,
      (
        CircleMessage,
        BaseReferences<_$AppDatabase, $CircleMessagesTable, CircleMessage>,
      ),
      CircleMessage,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CircleMessagesTableTableManager get circleMessages =>
      $$CircleMessagesTableTableManager(_db, _db.circleMessages);
}
