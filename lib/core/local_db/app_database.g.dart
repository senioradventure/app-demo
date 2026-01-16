// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $IndividualMessagesTable extends IndividualMessages
    with TableInfo<$IndividualMessagesTable, IndividualMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IndividualMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _mediaTypeMeta = const VerificationMeta(
    'mediaType',
  );
  @override
  late final GeneratedColumn<String> mediaType = GeneratedColumn<String>(
    'media_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
  static const VerificationMeta _forwardedFromMessageIdMeta =
      const VerificationMeta('forwardedFromMessageId');
  @override
  late final GeneratedColumn<String> forwardedFromMessageId =
      GeneratedColumn<String>(
        'forwarded_from_message_id',
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    senderId,
    content,
    mediaUrl,
    mediaType,
    conversationId,
    replyToMessageId,
    forwardedFromMessageId,
    createdAt,
    updatedAt,
    expiresAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'individual_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<IndividualMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('media_url')) {
      context.handle(
        _mediaUrlMeta,
        mediaUrl.isAcceptableOrUnknown(data['media_url']!, _mediaUrlMeta),
      );
    }
    if (data.containsKey('media_type')) {
      context.handle(
        _mediaTypeMeta,
        mediaType.isAcceptableOrUnknown(data['media_type']!, _mediaTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaTypeMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
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
    if (data.containsKey('forwarded_from_message_id')) {
      context.handle(
        _forwardedFromMessageIdMeta,
        forwardedFromMessageId.isAcceptableOrUnknown(
          data['forwarded_from_message_id']!,
          _forwardedFromMessageIdMeta,
        ),
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
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IndividualMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IndividualMessage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      senderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      mediaUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_url'],
      ),
      mediaType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_type'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      replyToMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reply_to_message_id'],
      ),
      forwardedFromMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}forwarded_from_message_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $IndividualMessagesTable createAlias(String alias) {
    return $IndividualMessagesTable(attachedDatabase, alias);
  }
}

class IndividualMessage extends DataClass
    implements Insertable<IndividualMessage> {
  final String id;
  final String senderId;
  final String content;
  final String? mediaUrl;
  final String mediaType;
  final String conversationId;
  final String? replyToMessageId;
  final String? forwardedFromMessageId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? expiresAt;
  final DateTime? deletedAt;
  const IndividualMessage({
    required this.id,
    required this.senderId,
    required this.content,
    this.mediaUrl,
    required this.mediaType,
    required this.conversationId,
    this.replyToMessageId,
    this.forwardedFromMessageId,
    required this.createdAt,
    this.updatedAt,
    this.expiresAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sender_id'] = Variable<String>(senderId);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || mediaUrl != null) {
      map['media_url'] = Variable<String>(mediaUrl);
    }
    map['media_type'] = Variable<String>(mediaType);
    map['conversation_id'] = Variable<String>(conversationId);
    if (!nullToAbsent || replyToMessageId != null) {
      map['reply_to_message_id'] = Variable<String>(replyToMessageId);
    }
    if (!nullToAbsent || forwardedFromMessageId != null) {
      map['forwarded_from_message_id'] = Variable<String>(
        forwardedFromMessageId,
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  IndividualMessagesCompanion toCompanion(bool nullToAbsent) {
    return IndividualMessagesCompanion(
      id: Value(id),
      senderId: Value(senderId),
      content: Value(content),
      mediaUrl: mediaUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaUrl),
      mediaType: Value(mediaType),
      conversationId: Value(conversationId),
      replyToMessageId: replyToMessageId == null && nullToAbsent
          ? const Value.absent()
          : Value(replyToMessageId),
      forwardedFromMessageId: forwardedFromMessageId == null && nullToAbsent
          ? const Value.absent()
          : Value(forwardedFromMessageId),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory IndividualMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IndividualMessage(
      id: serializer.fromJson<String>(json['id']),
      senderId: serializer.fromJson<String>(json['senderId']),
      content: serializer.fromJson<String>(json['content']),
      mediaUrl: serializer.fromJson<String?>(json['mediaUrl']),
      mediaType: serializer.fromJson<String>(json['mediaType']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      replyToMessageId: serializer.fromJson<String?>(json['replyToMessageId']),
      forwardedFromMessageId: serializer.fromJson<String?>(
        json['forwardedFromMessageId'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'senderId': serializer.toJson<String>(senderId),
      'content': serializer.toJson<String>(content),
      'mediaUrl': serializer.toJson<String?>(mediaUrl),
      'mediaType': serializer.toJson<String>(mediaType),
      'conversationId': serializer.toJson<String>(conversationId),
      'replyToMessageId': serializer.toJson<String?>(replyToMessageId),
      'forwardedFromMessageId': serializer.toJson<String?>(
        forwardedFromMessageId,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  IndividualMessage copyWith({
    String? id,
    String? senderId,
    String? content,
    Value<String?> mediaUrl = const Value.absent(),
    String? mediaType,
    String? conversationId,
    Value<String?> replyToMessageId = const Value.absent(),
    Value<String?> forwardedFromMessageId = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
    Value<DateTime?> expiresAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => IndividualMessage(
    id: id ?? this.id,
    senderId: senderId ?? this.senderId,
    content: content ?? this.content,
    mediaUrl: mediaUrl.present ? mediaUrl.value : this.mediaUrl,
    mediaType: mediaType ?? this.mediaType,
    conversationId: conversationId ?? this.conversationId,
    replyToMessageId: replyToMessageId.present
        ? replyToMessageId.value
        : this.replyToMessageId,
    forwardedFromMessageId: forwardedFromMessageId.present
        ? forwardedFromMessageId.value
        : this.forwardedFromMessageId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  IndividualMessage copyWithCompanion(IndividualMessagesCompanion data) {
    return IndividualMessage(
      id: data.id.present ? data.id.value : this.id,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      content: data.content.present ? data.content.value : this.content,
      mediaUrl: data.mediaUrl.present ? data.mediaUrl.value : this.mediaUrl,
      mediaType: data.mediaType.present ? data.mediaType.value : this.mediaType,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      replyToMessageId: data.replyToMessageId.present
          ? data.replyToMessageId.value
          : this.replyToMessageId,
      forwardedFromMessageId: data.forwardedFromMessageId.present
          ? data.forwardedFromMessageId.value
          : this.forwardedFromMessageId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IndividualMessage(')
          ..write('id: $id, ')
          ..write('senderId: $senderId, ')
          ..write('content: $content, ')
          ..write('mediaUrl: $mediaUrl, ')
          ..write('mediaType: $mediaType, ')
          ..write('conversationId: $conversationId, ')
          ..write('replyToMessageId: $replyToMessageId, ')
          ..write('forwardedFromMessageId: $forwardedFromMessageId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    senderId,
    content,
    mediaUrl,
    mediaType,
    conversationId,
    replyToMessageId,
    forwardedFromMessageId,
    createdAt,
    updatedAt,
    expiresAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IndividualMessage &&
          other.id == this.id &&
          other.senderId == this.senderId &&
          other.content == this.content &&
          other.mediaUrl == this.mediaUrl &&
          other.mediaType == this.mediaType &&
          other.conversationId == this.conversationId &&
          other.replyToMessageId == this.replyToMessageId &&
          other.forwardedFromMessageId == this.forwardedFromMessageId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.expiresAt == this.expiresAt &&
          other.deletedAt == this.deletedAt);
}

class IndividualMessagesCompanion extends UpdateCompanion<IndividualMessage> {
  final Value<String> id;
  final Value<String> senderId;
  final Value<String> content;
  final Value<String?> mediaUrl;
  final Value<String> mediaType;
  final Value<String> conversationId;
  final Value<String?> replyToMessageId;
  final Value<String?> forwardedFromMessageId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime?> expiresAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const IndividualMessagesCompanion({
    this.id = const Value.absent(),
    this.senderId = const Value.absent(),
    this.content = const Value.absent(),
    this.mediaUrl = const Value.absent(),
    this.mediaType = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.replyToMessageId = const Value.absent(),
    this.forwardedFromMessageId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IndividualMessagesCompanion.insert({
    required String id,
    required String senderId,
    required String content,
    this.mediaUrl = const Value.absent(),
    required String mediaType,
    required String conversationId,
    this.replyToMessageId = const Value.absent(),
    this.forwardedFromMessageId = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       senderId = Value(senderId),
       content = Value(content),
       mediaType = Value(mediaType),
       conversationId = Value(conversationId),
       createdAt = Value(createdAt);
  static Insertable<IndividualMessage> custom({
    Expression<String>? id,
    Expression<String>? senderId,
    Expression<String>? content,
    Expression<String>? mediaUrl,
    Expression<String>? mediaType,
    Expression<String>? conversationId,
    Expression<String>? replyToMessageId,
    Expression<String>? forwardedFromMessageId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? expiresAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (senderId != null) 'sender_id': senderId,
      if (content != null) 'content': content,
      if (mediaUrl != null) 'media_url': mediaUrl,
      if (mediaType != null) 'media_type': mediaType,
      if (conversationId != null) 'conversation_id': conversationId,
      if (replyToMessageId != null) 'reply_to_message_id': replyToMessageId,
      if (forwardedFromMessageId != null)
        'forwarded_from_message_id': forwardedFromMessageId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IndividualMessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? senderId,
    Value<String>? content,
    Value<String?>? mediaUrl,
    Value<String>? mediaType,
    Value<String>? conversationId,
    Value<String?>? replyToMessageId,
    Value<String?>? forwardedFromMessageId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime?>? expiresAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return IndividualMessagesCompanion(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      conversationId: conversationId ?? this.conversationId,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      forwardedFromMessageId:
          forwardedFromMessageId ?? this.forwardedFromMessageId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (mediaUrl.present) {
      map['media_url'] = Variable<String>(mediaUrl.value);
    }
    if (mediaType.present) {
      map['media_type'] = Variable<String>(mediaType.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (replyToMessageId.present) {
      map['reply_to_message_id'] = Variable<String>(replyToMessageId.value);
    }
    if (forwardedFromMessageId.present) {
      map['forwarded_from_message_id'] = Variable<String>(
        forwardedFromMessageId.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IndividualMessagesCompanion(')
          ..write('id: $id, ')
          ..write('senderId: $senderId, ')
          ..write('content: $content, ')
          ..write('mediaUrl: $mediaUrl, ')
          ..write('mediaType: $mediaType, ')
          ..write('conversationId: $conversationId, ')
          ..write('replyToMessageId: $replyToMessageId, ')
          ..write('forwardedFromMessageId: $forwardedFromMessageId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MessageReactionsTable extends MessageReactions
    with TableInfo<$MessageReactionsTable, MessageReaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessageReactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
    'message_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reactionMeta = const VerificationMeta(
    'reaction',
  );
  @override
  late final GeneratedColumn<String> reaction = GeneratedColumn<String>(
    'reaction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    messageId,
    userId,
    reaction,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'message_reactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<MessageReaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('reaction')) {
      context.handle(
        _reactionMeta,
        reaction.isAcceptableOrUnknown(data['reaction']!, _reactionMeta),
      );
    } else if (isInserting) {
      context.missing(_reactionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {messageId, userId, reaction},
  ];
  @override
  MessageReaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageReaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      reaction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reaction'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MessageReactionsTable createAlias(String alias) {
    return $MessageReactionsTable(attachedDatabase, alias);
  }
}

class MessageReaction extends DataClass implements Insertable<MessageReaction> {
  final String id;
  final String messageId;
  final String userId;
  final String reaction;
  final DateTime createdAt;
  const MessageReaction({
    required this.id,
    required this.messageId,
    required this.userId,
    required this.reaction,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['message_id'] = Variable<String>(messageId);
    map['user_id'] = Variable<String>(userId);
    map['reaction'] = Variable<String>(reaction);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MessageReactionsCompanion toCompanion(bool nullToAbsent) {
    return MessageReactionsCompanion(
      id: Value(id),
      messageId: Value(messageId),
      userId: Value(userId),
      reaction: Value(reaction),
      createdAt: Value(createdAt),
    );
  }

  factory MessageReaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageReaction(
      id: serializer.fromJson<String>(json['id']),
      messageId: serializer.fromJson<String>(json['messageId']),
      userId: serializer.fromJson<String>(json['userId']),
      reaction: serializer.fromJson<String>(json['reaction']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'messageId': serializer.toJson<String>(messageId),
      'userId': serializer.toJson<String>(userId),
      'reaction': serializer.toJson<String>(reaction),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MessageReaction copyWith({
    String? id,
    String? messageId,
    String? userId,
    String? reaction,
    DateTime? createdAt,
  }) => MessageReaction(
    id: id ?? this.id,
    messageId: messageId ?? this.messageId,
    userId: userId ?? this.userId,
    reaction: reaction ?? this.reaction,
    createdAt: createdAt ?? this.createdAt,
  );
  MessageReaction copyWithCompanion(MessageReactionsCompanion data) {
    return MessageReaction(
      id: data.id.present ? data.id.value : this.id,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      userId: data.userId.present ? data.userId.value : this.userId,
      reaction: data.reaction.present ? data.reaction.value : this.reaction,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessageReaction(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('userId: $userId, ')
          ..write('reaction: $reaction, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, messageId, userId, reaction, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageReaction &&
          other.id == this.id &&
          other.messageId == this.messageId &&
          other.userId == this.userId &&
          other.reaction == this.reaction &&
          other.createdAt == this.createdAt);
}

class MessageReactionsCompanion extends UpdateCompanion<MessageReaction> {
  final Value<String> id;
  final Value<String> messageId;
  final Value<String> userId;
  final Value<String> reaction;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MessageReactionsCompanion({
    this.id = const Value.absent(),
    this.messageId = const Value.absent(),
    this.userId = const Value.absent(),
    this.reaction = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessageReactionsCompanion.insert({
    required String id,
    required String messageId,
    required String userId,
    required String reaction,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       messageId = Value(messageId),
       userId = Value(userId),
       reaction = Value(reaction),
       createdAt = Value(createdAt);
  static Insertable<MessageReaction> custom({
    Expression<String>? id,
    Expression<String>? messageId,
    Expression<String>? userId,
    Expression<String>? reaction,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageId != null) 'message_id': messageId,
      if (userId != null) 'user_id': userId,
      if (reaction != null) 'reaction': reaction,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessageReactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? messageId,
    Value<String>? userId,
    Value<String>? reaction,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MessageReactionsCompanion(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      userId: userId ?? this.userId,
      reaction: reaction ?? this.reaction,
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
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (reaction.present) {
      map['reaction'] = Variable<String>(reaction.value);
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
    return (StringBuffer('MessageReactionsCompanion(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('userId: $userId, ')
          ..write('reaction: $reaction, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $IndividualMessagesTable individualMessages =
      $IndividualMessagesTable(this);
  late final $MessageReactionsTable messageReactions = $MessageReactionsTable(
    this,
  );
  late final IndividualMessagesDao individualMessagesDao =
      IndividualMessagesDao(this as AppDatabase);
  late final MessageReactionsDao messageReactionsDao = MessageReactionsDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    individualMessages,
    messageReactions,
  ];
}

typedef $$IndividualMessagesTableCreateCompanionBuilder =
    IndividualMessagesCompanion Function({
      required String id,
      required String senderId,
      required String content,
      Value<String?> mediaUrl,
      required String mediaType,
      required String conversationId,
      Value<String?> replyToMessageId,
      Value<String?> forwardedFromMessageId,
      required DateTime createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> expiresAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$IndividualMessagesTableUpdateCompanionBuilder =
    IndividualMessagesCompanion Function({
      Value<String> id,
      Value<String> senderId,
      Value<String> content,
      Value<String?> mediaUrl,
      Value<String> mediaType,
      Value<String> conversationId,
      Value<String?> replyToMessageId,
      Value<String?> forwardedFromMessageId,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime?> expiresAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$IndividualMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $IndividualMessagesTable> {
  $$IndividualMessagesTableFilterComposer({
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

  ColumnFilters<String> get senderId => $composableBuilder(
    column: $table.senderId,
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

  ColumnFilters<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get replyToMessageId => $composableBuilder(
    column: $table.replyToMessageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get forwardedFromMessageId => $composableBuilder(
    column: $table.forwardedFromMessageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$IndividualMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $IndividualMessagesTable> {
  $$IndividualMessagesTableOrderingComposer({
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

  ColumnOrderings<String> get senderId => $composableBuilder(
    column: $table.senderId,
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

  ColumnOrderings<String> get mediaType => $composableBuilder(
    column: $table.mediaType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get replyToMessageId => $composableBuilder(
    column: $table.replyToMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get forwardedFromMessageId => $composableBuilder(
    column: $table.forwardedFromMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IndividualMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IndividualMessagesTable> {
  $$IndividualMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get senderId =>
      $composableBuilder(column: $table.senderId, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get mediaUrl =>
      $composableBuilder(column: $table.mediaUrl, builder: (column) => column);

  GeneratedColumn<String> get mediaType =>
      $composableBuilder(column: $table.mediaType, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get replyToMessageId => $composableBuilder(
    column: $table.replyToMessageId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get forwardedFromMessageId => $composableBuilder(
    column: $table.forwardedFromMessageId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$IndividualMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IndividualMessagesTable,
          IndividualMessage,
          $$IndividualMessagesTableFilterComposer,
          $$IndividualMessagesTableOrderingComposer,
          $$IndividualMessagesTableAnnotationComposer,
          $$IndividualMessagesTableCreateCompanionBuilder,
          $$IndividualMessagesTableUpdateCompanionBuilder,
          (
            IndividualMessage,
            BaseReferences<
              _$AppDatabase,
              $IndividualMessagesTable,
              IndividualMessage
            >,
          ),
          IndividualMessage,
          PrefetchHooks Function()
        > {
  $$IndividualMessagesTableTableManager(
    _$AppDatabase db,
    $IndividualMessagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IndividualMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IndividualMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IndividualMessagesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> senderId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> mediaUrl = const Value.absent(),
                Value<String> mediaType = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String?> replyToMessageId = const Value.absent(),
                Value<String?> forwardedFromMessageId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IndividualMessagesCompanion(
                id: id,
                senderId: senderId,
                content: content,
                mediaUrl: mediaUrl,
                mediaType: mediaType,
                conversationId: conversationId,
                replyToMessageId: replyToMessageId,
                forwardedFromMessageId: forwardedFromMessageId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                expiresAt: expiresAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String senderId,
                required String content,
                Value<String?> mediaUrl = const Value.absent(),
                required String mediaType,
                required String conversationId,
                Value<String?> replyToMessageId = const Value.absent(),
                Value<String?> forwardedFromMessageId = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IndividualMessagesCompanion.insert(
                id: id,
                senderId: senderId,
                content: content,
                mediaUrl: mediaUrl,
                mediaType: mediaType,
                conversationId: conversationId,
                replyToMessageId: replyToMessageId,
                forwardedFromMessageId: forwardedFromMessageId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                expiresAt: expiresAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IndividualMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IndividualMessagesTable,
      IndividualMessage,
      $$IndividualMessagesTableFilterComposer,
      $$IndividualMessagesTableOrderingComposer,
      $$IndividualMessagesTableAnnotationComposer,
      $$IndividualMessagesTableCreateCompanionBuilder,
      $$IndividualMessagesTableUpdateCompanionBuilder,
      (
        IndividualMessage,
        BaseReferences<
          _$AppDatabase,
          $IndividualMessagesTable,
          IndividualMessage
        >,
      ),
      IndividualMessage,
      PrefetchHooks Function()
    >;
typedef $$MessageReactionsTableCreateCompanionBuilder =
    MessageReactionsCompanion Function({
      required String id,
      required String messageId,
      required String userId,
      required String reaction,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$MessageReactionsTableUpdateCompanionBuilder =
    MessageReactionsCompanion Function({
      Value<String> id,
      Value<String> messageId,
      Value<String> userId,
      Value<String> reaction,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$MessageReactionsTableFilterComposer
    extends Composer<_$AppDatabase, $MessageReactionsTable> {
  $$MessageReactionsTableFilterComposer({
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

  ColumnFilters<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reaction => $composableBuilder(
    column: $table.reaction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MessageReactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $MessageReactionsTable> {
  $$MessageReactionsTableOrderingComposer({
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

  ColumnOrderings<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reaction => $composableBuilder(
    column: $table.reaction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MessageReactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessageReactionsTable> {
  $$MessageReactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get reaction =>
      $composableBuilder(column: $table.reaction, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MessageReactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessageReactionsTable,
          MessageReaction,
          $$MessageReactionsTableFilterComposer,
          $$MessageReactionsTableOrderingComposer,
          $$MessageReactionsTableAnnotationComposer,
          $$MessageReactionsTableCreateCompanionBuilder,
          $$MessageReactionsTableUpdateCompanionBuilder,
          (
            MessageReaction,
            BaseReferences<
              _$AppDatabase,
              $MessageReactionsTable,
              MessageReaction
            >,
          ),
          MessageReaction,
          PrefetchHooks Function()
        > {
  $$MessageReactionsTableTableManager(
    _$AppDatabase db,
    $MessageReactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessageReactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessageReactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessageReactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> messageId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> reaction = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MessageReactionsCompanion(
                id: id,
                messageId: messageId,
                userId: userId,
                reaction: reaction,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String messageId,
                required String userId,
                required String reaction,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => MessageReactionsCompanion.insert(
                id: id,
                messageId: messageId,
                userId: userId,
                reaction: reaction,
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

typedef $$MessageReactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessageReactionsTable,
      MessageReaction,
      $$MessageReactionsTableFilterComposer,
      $$MessageReactionsTableOrderingComposer,
      $$MessageReactionsTableAnnotationComposer,
      $$MessageReactionsTableCreateCompanionBuilder,
      $$MessageReactionsTableUpdateCompanionBuilder,
      (
        MessageReaction,
        BaseReferences<_$AppDatabase, $MessageReactionsTable, MessageReaction>,
      ),
      MessageReaction,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$IndividualMessagesTableTableManager get individualMessages =>
      $$IndividualMessagesTableTableManager(_db, _db.individualMessages);
  $$MessageReactionsTableTableManager get messageReactions =>
      $$MessageReactionsTableTableManager(_db, _db.messageReactions);
}
