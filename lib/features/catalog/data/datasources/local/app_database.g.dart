// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MemberRowsTable extends MemberRows
    with TableInfo<$MemberRowsTable, MemberRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemberRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtitleKeyMeta = const VerificationMeta(
    'subtitleKey',
  );
  @override
  late final GeneratedColumn<String> subtitleKey = GeneratedColumn<String>(
    'subtitle_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarAssetMeta = const VerificationMeta(
    'avatarAsset',
  );
  @override
  late final GeneratedColumn<String> avatarAsset = GeneratedColumn<String>(
    'avatar_asset',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tierProgressKeyMeta = const VerificationMeta(
    'tierProgressKey',
  );
  @override
  late final GeneratedColumn<String> tierProgressKey = GeneratedColumn<String>(
    'tier_progress_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tierProgressKyatsMeta = const VerificationMeta(
    'tierProgressKyats',
  );
  @override
  late final GeneratedColumn<int> tierProgressKyats = GeneratedColumn<int>(
    'tier_progress_kyats',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notificationCountMeta = const VerificationMeta(
    'notificationCount',
  );
  @override
  late final GeneratedColumn<int> notificationCount = GeneratedColumn<int>(
    'notification_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tierCodeMeta = const VerificationMeta(
    'tierCode',
  );
  @override
  late final GeneratedColumn<String> tierCode = GeneratedColumn<String>(
    'tier_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointsBalanceMeta = const VerificationMeta(
    'pointsBalance',
  );
  @override
  late final GeneratedColumn<int> pointsBalance = GeneratedColumn<int>(
    'points_balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointsToNextTierMeta = const VerificationMeta(
    'pointsToNextTier',
  );
  @override
  late final GeneratedColumn<int> pointsToNextTier = GeneratedColumn<int>(
    'points_to_next_tier',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rewardsPillCountMeta = const VerificationMeta(
    'rewardsPillCount',
  );
  @override
  late final GeneratedColumn<int> rewardsPillCount = GeneratedColumn<int>(
    'rewards_pill_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _tierLadderFillBpMeta = const VerificationMeta(
    'tierLadderFillBp',
  );
  @override
  late final GeneratedColumn<int> tierLadderFillBp = GeneratedColumn<int>(
    'tier_ladder_fill_bp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    subtitleKey,
    avatarAsset,
    tierProgressKey,
    tierProgressKyats,
    notificationCount,
    tierCode,
    pointsBalance,
    pointsToNextTier,
    rewardsPillCount,
    tierLadderFillBp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'member_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemberRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('subtitle_key')) {
      context.handle(
        _subtitleKeyMeta,
        subtitleKey.isAcceptableOrUnknown(
          data['subtitle_key']!,
          _subtitleKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subtitleKeyMeta);
    }
    if (data.containsKey('avatar_asset')) {
      context.handle(
        _avatarAssetMeta,
        avatarAsset.isAcceptableOrUnknown(
          data['avatar_asset']!,
          _avatarAssetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_avatarAssetMeta);
    }
    if (data.containsKey('tier_progress_key')) {
      context.handle(
        _tierProgressKeyMeta,
        tierProgressKey.isAcceptableOrUnknown(
          data['tier_progress_key']!,
          _tierProgressKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tierProgressKeyMeta);
    }
    if (data.containsKey('tier_progress_kyats')) {
      context.handle(
        _tierProgressKyatsMeta,
        tierProgressKyats.isAcceptableOrUnknown(
          data['tier_progress_kyats']!,
          _tierProgressKyatsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tierProgressKyatsMeta);
    }
    if (data.containsKey('notification_count')) {
      context.handle(
        _notificationCountMeta,
        notificationCount.isAcceptableOrUnknown(
          data['notification_count']!,
          _notificationCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_notificationCountMeta);
    }
    if (data.containsKey('tier_code')) {
      context.handle(
        _tierCodeMeta,
        tierCode.isAcceptableOrUnknown(data['tier_code']!, _tierCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_tierCodeMeta);
    }
    if (data.containsKey('points_balance')) {
      context.handle(
        _pointsBalanceMeta,
        pointsBalance.isAcceptableOrUnknown(
          data['points_balance']!,
          _pointsBalanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pointsBalanceMeta);
    }
    if (data.containsKey('points_to_next_tier')) {
      context.handle(
        _pointsToNextTierMeta,
        pointsToNextTier.isAcceptableOrUnknown(
          data['points_to_next_tier']!,
          _pointsToNextTierMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pointsToNextTierMeta);
    }
    if (data.containsKey('rewards_pill_count')) {
      context.handle(
        _rewardsPillCountMeta,
        rewardsPillCount.isAcceptableOrUnknown(
          data['rewards_pill_count']!,
          _rewardsPillCountMeta,
        ),
      );
    }
    if (data.containsKey('tier_ladder_fill_bp')) {
      context.handle(
        _tierLadderFillBpMeta,
        tierLadderFillBp.isAcceptableOrUnknown(
          data['tier_ladder_fill_bp']!,
          _tierLadderFillBpMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemberRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemberRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      subtitleKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtitle_key'],
      )!,
      avatarAsset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_asset'],
      )!,
      tierProgressKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tier_progress_key'],
      )!,
      tierProgressKyats: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tier_progress_kyats'],
      )!,
      notificationCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notification_count'],
      )!,
      tierCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tier_code'],
      )!,
      pointsBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points_balance'],
      )!,
      pointsToNextTier: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points_to_next_tier'],
      )!,
      rewardsPillCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rewards_pill_count'],
      )!,
      tierLadderFillBp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tier_ladder_fill_bp'],
      )!,
    );
  }

  @override
  $MemberRowsTable createAlias(String alias) {
    return $MemberRowsTable(attachedDatabase, alias);
  }
}

class MemberRow extends DataClass implements Insertable<MemberRow> {
  final String id;
  final String displayName;
  final String subtitleKey;
  final String avatarAsset;
  final String tierProgressKey;
  final int tierProgressKyats;
  final int notificationCount;
  final String tierCode;
  final int pointsBalance;
  final int pointsToNextTier;
  final int rewardsPillCount;
  final int tierLadderFillBp;
  const MemberRow({
    required this.id,
    required this.displayName,
    required this.subtitleKey,
    required this.avatarAsset,
    required this.tierProgressKey,
    required this.tierProgressKyats,
    required this.notificationCount,
    required this.tierCode,
    required this.pointsBalance,
    required this.pointsToNextTier,
    required this.rewardsPillCount,
    required this.tierLadderFillBp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['display_name'] = Variable<String>(displayName);
    map['subtitle_key'] = Variable<String>(subtitleKey);
    map['avatar_asset'] = Variable<String>(avatarAsset);
    map['tier_progress_key'] = Variable<String>(tierProgressKey);
    map['tier_progress_kyats'] = Variable<int>(tierProgressKyats);
    map['notification_count'] = Variable<int>(notificationCount);
    map['tier_code'] = Variable<String>(tierCode);
    map['points_balance'] = Variable<int>(pointsBalance);
    map['points_to_next_tier'] = Variable<int>(pointsToNextTier);
    map['rewards_pill_count'] = Variable<int>(rewardsPillCount);
    map['tier_ladder_fill_bp'] = Variable<int>(tierLadderFillBp);
    return map;
  }

  MemberRowsCompanion toCompanion(bool nullToAbsent) {
    return MemberRowsCompanion(
      id: Value(id),
      displayName: Value(displayName),
      subtitleKey: Value(subtitleKey),
      avatarAsset: Value(avatarAsset),
      tierProgressKey: Value(tierProgressKey),
      tierProgressKyats: Value(tierProgressKyats),
      notificationCount: Value(notificationCount),
      tierCode: Value(tierCode),
      pointsBalance: Value(pointsBalance),
      pointsToNextTier: Value(pointsToNextTier),
      rewardsPillCount: Value(rewardsPillCount),
      tierLadderFillBp: Value(tierLadderFillBp),
    );
  }

  factory MemberRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemberRow(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      subtitleKey: serializer.fromJson<String>(json['subtitleKey']),
      avatarAsset: serializer.fromJson<String>(json['avatarAsset']),
      tierProgressKey: serializer.fromJson<String>(json['tierProgressKey']),
      tierProgressKyats: serializer.fromJson<int>(json['tierProgressKyats']),
      notificationCount: serializer.fromJson<int>(json['notificationCount']),
      tierCode: serializer.fromJson<String>(json['tierCode']),
      pointsBalance: serializer.fromJson<int>(json['pointsBalance']),
      pointsToNextTier: serializer.fromJson<int>(json['pointsToNextTier']),
      rewardsPillCount: serializer.fromJson<int>(json['rewardsPillCount']),
      tierLadderFillBp: serializer.fromJson<int>(json['tierLadderFillBp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String>(displayName),
      'subtitleKey': serializer.toJson<String>(subtitleKey),
      'avatarAsset': serializer.toJson<String>(avatarAsset),
      'tierProgressKey': serializer.toJson<String>(tierProgressKey),
      'tierProgressKyats': serializer.toJson<int>(tierProgressKyats),
      'notificationCount': serializer.toJson<int>(notificationCount),
      'tierCode': serializer.toJson<String>(tierCode),
      'pointsBalance': serializer.toJson<int>(pointsBalance),
      'pointsToNextTier': serializer.toJson<int>(pointsToNextTier),
      'rewardsPillCount': serializer.toJson<int>(rewardsPillCount),
      'tierLadderFillBp': serializer.toJson<int>(tierLadderFillBp),
    };
  }

  MemberRow copyWith({
    String? id,
    String? displayName,
    String? subtitleKey,
    String? avatarAsset,
    String? tierProgressKey,
    int? tierProgressKyats,
    int? notificationCount,
    String? tierCode,
    int? pointsBalance,
    int? pointsToNextTier,
    int? rewardsPillCount,
    int? tierLadderFillBp,
  }) => MemberRow(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    subtitleKey: subtitleKey ?? this.subtitleKey,
    avatarAsset: avatarAsset ?? this.avatarAsset,
    tierProgressKey: tierProgressKey ?? this.tierProgressKey,
    tierProgressKyats: tierProgressKyats ?? this.tierProgressKyats,
    notificationCount: notificationCount ?? this.notificationCount,
    tierCode: tierCode ?? this.tierCode,
    pointsBalance: pointsBalance ?? this.pointsBalance,
    pointsToNextTier: pointsToNextTier ?? this.pointsToNextTier,
    rewardsPillCount: rewardsPillCount ?? this.rewardsPillCount,
    tierLadderFillBp: tierLadderFillBp ?? this.tierLadderFillBp,
  );
  MemberRow copyWithCompanion(MemberRowsCompanion data) {
    return MemberRow(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      subtitleKey: data.subtitleKey.present
          ? data.subtitleKey.value
          : this.subtitleKey,
      avatarAsset: data.avatarAsset.present
          ? data.avatarAsset.value
          : this.avatarAsset,
      tierProgressKey: data.tierProgressKey.present
          ? data.tierProgressKey.value
          : this.tierProgressKey,
      tierProgressKyats: data.tierProgressKyats.present
          ? data.tierProgressKyats.value
          : this.tierProgressKyats,
      notificationCount: data.notificationCount.present
          ? data.notificationCount.value
          : this.notificationCount,
      tierCode: data.tierCode.present ? data.tierCode.value : this.tierCode,
      pointsBalance: data.pointsBalance.present
          ? data.pointsBalance.value
          : this.pointsBalance,
      pointsToNextTier: data.pointsToNextTier.present
          ? data.pointsToNextTier.value
          : this.pointsToNextTier,
      rewardsPillCount: data.rewardsPillCount.present
          ? data.rewardsPillCount.value
          : this.rewardsPillCount,
      tierLadderFillBp: data.tierLadderFillBp.present
          ? data.tierLadderFillBp.value
          : this.tierLadderFillBp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemberRow(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('subtitleKey: $subtitleKey, ')
          ..write('avatarAsset: $avatarAsset, ')
          ..write('tierProgressKey: $tierProgressKey, ')
          ..write('tierProgressKyats: $tierProgressKyats, ')
          ..write('notificationCount: $notificationCount, ')
          ..write('tierCode: $tierCode, ')
          ..write('pointsBalance: $pointsBalance, ')
          ..write('pointsToNextTier: $pointsToNextTier, ')
          ..write('rewardsPillCount: $rewardsPillCount, ')
          ..write('tierLadderFillBp: $tierLadderFillBp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    displayName,
    subtitleKey,
    avatarAsset,
    tierProgressKey,
    tierProgressKyats,
    notificationCount,
    tierCode,
    pointsBalance,
    pointsToNextTier,
    rewardsPillCount,
    tierLadderFillBp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemberRow &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.subtitleKey == this.subtitleKey &&
          other.avatarAsset == this.avatarAsset &&
          other.tierProgressKey == this.tierProgressKey &&
          other.tierProgressKyats == this.tierProgressKyats &&
          other.notificationCount == this.notificationCount &&
          other.tierCode == this.tierCode &&
          other.pointsBalance == this.pointsBalance &&
          other.pointsToNextTier == this.pointsToNextTier &&
          other.rewardsPillCount == this.rewardsPillCount &&
          other.tierLadderFillBp == this.tierLadderFillBp);
}

class MemberRowsCompanion extends UpdateCompanion<MemberRow> {
  final Value<String> id;
  final Value<String> displayName;
  final Value<String> subtitleKey;
  final Value<String> avatarAsset;
  final Value<String> tierProgressKey;
  final Value<int> tierProgressKyats;
  final Value<int> notificationCount;
  final Value<String> tierCode;
  final Value<int> pointsBalance;
  final Value<int> pointsToNextTier;
  final Value<int> rewardsPillCount;
  final Value<int> tierLadderFillBp;
  final Value<int> rowid;
  const MemberRowsCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.subtitleKey = const Value.absent(),
    this.avatarAsset = const Value.absent(),
    this.tierProgressKey = const Value.absent(),
    this.tierProgressKyats = const Value.absent(),
    this.notificationCount = const Value.absent(),
    this.tierCode = const Value.absent(),
    this.pointsBalance = const Value.absent(),
    this.pointsToNextTier = const Value.absent(),
    this.rewardsPillCount = const Value.absent(),
    this.tierLadderFillBp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MemberRowsCompanion.insert({
    required String id,
    required String displayName,
    required String subtitleKey,
    required String avatarAsset,
    required String tierProgressKey,
    required int tierProgressKyats,
    required int notificationCount,
    required String tierCode,
    required int pointsBalance,
    required int pointsToNextTier,
    this.rewardsPillCount = const Value.absent(),
    this.tierLadderFillBp = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       displayName = Value(displayName),
       subtitleKey = Value(subtitleKey),
       avatarAsset = Value(avatarAsset),
       tierProgressKey = Value(tierProgressKey),
       tierProgressKyats = Value(tierProgressKyats),
       notificationCount = Value(notificationCount),
       tierCode = Value(tierCode),
       pointsBalance = Value(pointsBalance),
       pointsToNextTier = Value(pointsToNextTier);
  static Insertable<MemberRow> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<String>? subtitleKey,
    Expression<String>? avatarAsset,
    Expression<String>? tierProgressKey,
    Expression<int>? tierProgressKyats,
    Expression<int>? notificationCount,
    Expression<String>? tierCode,
    Expression<int>? pointsBalance,
    Expression<int>? pointsToNextTier,
    Expression<int>? rewardsPillCount,
    Expression<int>? tierLadderFillBp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (subtitleKey != null) 'subtitle_key': subtitleKey,
      if (avatarAsset != null) 'avatar_asset': avatarAsset,
      if (tierProgressKey != null) 'tier_progress_key': tierProgressKey,
      if (tierProgressKyats != null) 'tier_progress_kyats': tierProgressKyats,
      if (notificationCount != null) 'notification_count': notificationCount,
      if (tierCode != null) 'tier_code': tierCode,
      if (pointsBalance != null) 'points_balance': pointsBalance,
      if (pointsToNextTier != null) 'points_to_next_tier': pointsToNextTier,
      if (rewardsPillCount != null) 'rewards_pill_count': rewardsPillCount,
      if (tierLadderFillBp != null) 'tier_ladder_fill_bp': tierLadderFillBp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MemberRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? displayName,
    Value<String>? subtitleKey,
    Value<String>? avatarAsset,
    Value<String>? tierProgressKey,
    Value<int>? tierProgressKyats,
    Value<int>? notificationCount,
    Value<String>? tierCode,
    Value<int>? pointsBalance,
    Value<int>? pointsToNextTier,
    Value<int>? rewardsPillCount,
    Value<int>? tierLadderFillBp,
    Value<int>? rowid,
  }) {
    return MemberRowsCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      subtitleKey: subtitleKey ?? this.subtitleKey,
      avatarAsset: avatarAsset ?? this.avatarAsset,
      tierProgressKey: tierProgressKey ?? this.tierProgressKey,
      tierProgressKyats: tierProgressKyats ?? this.tierProgressKyats,
      notificationCount: notificationCount ?? this.notificationCount,
      tierCode: tierCode ?? this.tierCode,
      pointsBalance: pointsBalance ?? this.pointsBalance,
      pointsToNextTier: pointsToNextTier ?? this.pointsToNextTier,
      rewardsPillCount: rewardsPillCount ?? this.rewardsPillCount,
      tierLadderFillBp: tierLadderFillBp ?? this.tierLadderFillBp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (subtitleKey.present) {
      map['subtitle_key'] = Variable<String>(subtitleKey.value);
    }
    if (avatarAsset.present) {
      map['avatar_asset'] = Variable<String>(avatarAsset.value);
    }
    if (tierProgressKey.present) {
      map['tier_progress_key'] = Variable<String>(tierProgressKey.value);
    }
    if (tierProgressKyats.present) {
      map['tier_progress_kyats'] = Variable<int>(tierProgressKyats.value);
    }
    if (notificationCount.present) {
      map['notification_count'] = Variable<int>(notificationCount.value);
    }
    if (tierCode.present) {
      map['tier_code'] = Variable<String>(tierCode.value);
    }
    if (pointsBalance.present) {
      map['points_balance'] = Variable<int>(pointsBalance.value);
    }
    if (pointsToNextTier.present) {
      map['points_to_next_tier'] = Variable<int>(pointsToNextTier.value);
    }
    if (rewardsPillCount.present) {
      map['rewards_pill_count'] = Variable<int>(rewardsPillCount.value);
    }
    if (tierLadderFillBp.present) {
      map['tier_ladder_fill_bp'] = Variable<int>(tierLadderFillBp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemberRowsCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('subtitleKey: $subtitleKey, ')
          ..write('avatarAsset: $avatarAsset, ')
          ..write('tierProgressKey: $tierProgressKey, ')
          ..write('tierProgressKyats: $tierProgressKyats, ')
          ..write('notificationCount: $notificationCount, ')
          ..write('tierCode: $tierCode, ')
          ..write('pointsBalance: $pointsBalance, ')
          ..write('pointsToNextTier: $pointsToNextTier, ')
          ..write('rewardsPillCount: $rewardsPillCount, ')
          ..write('tierLadderFillBp: $tierLadderFillBp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductRowsTable extends ProductRows
    with TableInfo<$ProductRowsTable, ProductRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameKeyMeta = const VerificationMeta(
    'nameKey',
  );
  @override
  late final GeneratedColumn<String> nameKey = GeneratedColumn<String>(
    'name_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMmkMeta = const VerificationMeta(
    'priceMmk',
  );
  @override
  late final GeneratedColumn<int> priceMmk = GeneratedColumn<int>(
    'price_mmk',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isNewMeta = const VerificationMeta('isNew');
  @override
  late final GeneratedColumn<bool> isNew = GeneratedColumn<bool>(
    'is_new',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_new" IN (0, 1))',
    ),
  );
  static const VerificationMeta _discountPercentMeta = const VerificationMeta(
    'discountPercent',
  );
  @override
  late final GeneratedColumn<int> discountPercent = GeneratedColumn<int>(
    'discount_percent',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageAssetMeta = const VerificationMeta(
    'imageAsset',
  );
  @override
  late final GeneratedColumn<String> imageAsset = GeneratedColumn<String>(
    'image_asset',
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
  static const VerificationMeta _descriptionKeyMeta = const VerificationMeta(
    'descriptionKey',
  );
  @override
  late final GeneratedColumn<String> descriptionKey = GeneratedColumn<String>(
    'description_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    nameKey,
    priceMmk,
    isNew,
    discountPercent,
    imageAsset,
    imageUrl,
    descriptionKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name_key')) {
      context.handle(
        _nameKeyMeta,
        nameKey.isAcceptableOrUnknown(data['name_key']!, _nameKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_nameKeyMeta);
    }
    if (data.containsKey('price_mmk')) {
      context.handle(
        _priceMmkMeta,
        priceMmk.isAcceptableOrUnknown(data['price_mmk']!, _priceMmkMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMmkMeta);
    }
    if (data.containsKey('is_new')) {
      context.handle(
        _isNewMeta,
        isNew.isAcceptableOrUnknown(data['is_new']!, _isNewMeta),
      );
    } else if (isInserting) {
      context.missing(_isNewMeta);
    }
    if (data.containsKey('discount_percent')) {
      context.handle(
        _discountPercentMeta,
        discountPercent.isAcceptableOrUnknown(
          data['discount_percent']!,
          _discountPercentMeta,
        ),
      );
    }
    if (data.containsKey('image_asset')) {
      context.handle(
        _imageAssetMeta,
        imageAsset.isAcceptableOrUnknown(data['image_asset']!, _imageAssetMeta),
      );
    } else if (isInserting) {
      context.missing(_imageAssetMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('description_key')) {
      context.handle(
        _descriptionKeyMeta,
        descriptionKey.isAcceptableOrUnknown(
          data['description_key']!,
          _descriptionKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      nameKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_key'],
      )!,
      priceMmk: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_mmk'],
      )!,
      isNew: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_new'],
      )!,
      discountPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_percent'],
      ),
      imageAsset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_asset'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      descriptionKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_key'],
      )!,
    );
  }

  @override
  $ProductRowsTable createAlias(String alias) {
    return $ProductRowsTable(attachedDatabase, alias);
  }
}

class ProductRow extends DataClass implements Insertable<ProductRow> {
  final String id;
  final String code;
  final String nameKey;
  final int priceMmk;
  final bool isNew;
  final int? discountPercent;
  final String imageAsset;
  final String? imageUrl;
  final String descriptionKey;
  const ProductRow({
    required this.id,
    required this.code,
    required this.nameKey,
    required this.priceMmk,
    required this.isNew,
    this.discountPercent,
    required this.imageAsset,
    this.imageUrl,
    required this.descriptionKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['name_key'] = Variable<String>(nameKey);
    map['price_mmk'] = Variable<int>(priceMmk);
    map['is_new'] = Variable<bool>(isNew);
    if (!nullToAbsent || discountPercent != null) {
      map['discount_percent'] = Variable<int>(discountPercent);
    }
    map['image_asset'] = Variable<String>(imageAsset);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['description_key'] = Variable<String>(descriptionKey);
    return map;
  }

  ProductRowsCompanion toCompanion(bool nullToAbsent) {
    return ProductRowsCompanion(
      id: Value(id),
      code: Value(code),
      nameKey: Value(nameKey),
      priceMmk: Value(priceMmk),
      isNew: Value(isNew),
      discountPercent: discountPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(discountPercent),
      imageAsset: Value(imageAsset),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      descriptionKey: Value(descriptionKey),
    );
  }

  factory ProductRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductRow(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      nameKey: serializer.fromJson<String>(json['nameKey']),
      priceMmk: serializer.fromJson<int>(json['priceMmk']),
      isNew: serializer.fromJson<bool>(json['isNew']),
      discountPercent: serializer.fromJson<int?>(json['discountPercent']),
      imageAsset: serializer.fromJson<String>(json['imageAsset']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      descriptionKey: serializer.fromJson<String>(json['descriptionKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'nameKey': serializer.toJson<String>(nameKey),
      'priceMmk': serializer.toJson<int>(priceMmk),
      'isNew': serializer.toJson<bool>(isNew),
      'discountPercent': serializer.toJson<int?>(discountPercent),
      'imageAsset': serializer.toJson<String>(imageAsset),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'descriptionKey': serializer.toJson<String>(descriptionKey),
    };
  }

  ProductRow copyWith({
    String? id,
    String? code,
    String? nameKey,
    int? priceMmk,
    bool? isNew,
    Value<int?> discountPercent = const Value.absent(),
    String? imageAsset,
    Value<String?> imageUrl = const Value.absent(),
    String? descriptionKey,
  }) => ProductRow(
    id: id ?? this.id,
    code: code ?? this.code,
    nameKey: nameKey ?? this.nameKey,
    priceMmk: priceMmk ?? this.priceMmk,
    isNew: isNew ?? this.isNew,
    discountPercent: discountPercent.present
        ? discountPercent.value
        : this.discountPercent,
    imageAsset: imageAsset ?? this.imageAsset,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    descriptionKey: descriptionKey ?? this.descriptionKey,
  );
  ProductRow copyWithCompanion(ProductRowsCompanion data) {
    return ProductRow(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      nameKey: data.nameKey.present ? data.nameKey.value : this.nameKey,
      priceMmk: data.priceMmk.present ? data.priceMmk.value : this.priceMmk,
      isNew: data.isNew.present ? data.isNew.value : this.isNew,
      discountPercent: data.discountPercent.present
          ? data.discountPercent.value
          : this.discountPercent,
      imageAsset: data.imageAsset.present
          ? data.imageAsset.value
          : this.imageAsset,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      descriptionKey: data.descriptionKey.present
          ? data.descriptionKey.value
          : this.descriptionKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductRow(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameKey: $nameKey, ')
          ..write('priceMmk: $priceMmk, ')
          ..write('isNew: $isNew, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('imageAsset: $imageAsset, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('descriptionKey: $descriptionKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    code,
    nameKey,
    priceMmk,
    isNew,
    discountPercent,
    imageAsset,
    imageUrl,
    descriptionKey,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductRow &&
          other.id == this.id &&
          other.code == this.code &&
          other.nameKey == this.nameKey &&
          other.priceMmk == this.priceMmk &&
          other.isNew == this.isNew &&
          other.discountPercent == this.discountPercent &&
          other.imageAsset == this.imageAsset &&
          other.imageUrl == this.imageUrl &&
          other.descriptionKey == this.descriptionKey);
}

class ProductRowsCompanion extends UpdateCompanion<ProductRow> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> nameKey;
  final Value<int> priceMmk;
  final Value<bool> isNew;
  final Value<int?> discountPercent;
  final Value<String> imageAsset;
  final Value<String?> imageUrl;
  final Value<String> descriptionKey;
  final Value<int> rowid;
  const ProductRowsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.nameKey = const Value.absent(),
    this.priceMmk = const Value.absent(),
    this.isNew = const Value.absent(),
    this.discountPercent = const Value.absent(),
    this.imageAsset = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.descriptionKey = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductRowsCompanion.insert({
    required String id,
    required String code,
    required String nameKey,
    required int priceMmk,
    required bool isNew,
    this.discountPercent = const Value.absent(),
    required String imageAsset,
    this.imageUrl = const Value.absent(),
    required String descriptionKey,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       nameKey = Value(nameKey),
       priceMmk = Value(priceMmk),
       isNew = Value(isNew),
       imageAsset = Value(imageAsset),
       descriptionKey = Value(descriptionKey);
  static Insertable<ProductRow> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? nameKey,
    Expression<int>? priceMmk,
    Expression<bool>? isNew,
    Expression<int>? discountPercent,
    Expression<String>? imageAsset,
    Expression<String>? imageUrl,
    Expression<String>? descriptionKey,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (nameKey != null) 'name_key': nameKey,
      if (priceMmk != null) 'price_mmk': priceMmk,
      if (isNew != null) 'is_new': isNew,
      if (discountPercent != null) 'discount_percent': discountPercent,
      if (imageAsset != null) 'image_asset': imageAsset,
      if (imageUrl != null) 'image_url': imageUrl,
      if (descriptionKey != null) 'description_key': descriptionKey,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String>? nameKey,
    Value<int>? priceMmk,
    Value<bool>? isNew,
    Value<int?>? discountPercent,
    Value<String>? imageAsset,
    Value<String?>? imageUrl,
    Value<String>? descriptionKey,
    Value<int>? rowid,
  }) {
    return ProductRowsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      nameKey: nameKey ?? this.nameKey,
      priceMmk: priceMmk ?? this.priceMmk,
      isNew: isNew ?? this.isNew,
      discountPercent: discountPercent ?? this.discountPercent,
      imageAsset: imageAsset ?? this.imageAsset,
      imageUrl: imageUrl ?? this.imageUrl,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (nameKey.present) {
      map['name_key'] = Variable<String>(nameKey.value);
    }
    if (priceMmk.present) {
      map['price_mmk'] = Variable<int>(priceMmk.value);
    }
    if (isNew.present) {
      map['is_new'] = Variable<bool>(isNew.value);
    }
    if (discountPercent.present) {
      map['discount_percent'] = Variable<int>(discountPercent.value);
    }
    if (imageAsset.present) {
      map['image_asset'] = Variable<String>(imageAsset.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (descriptionKey.present) {
      map['description_key'] = Variable<String>(descriptionKey.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductRowsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameKey: $nameKey, ')
          ..write('priceMmk: $priceMmk, ')
          ..write('isNew: $isNew, ')
          ..write('discountPercent: $discountPercent, ')
          ..write('imageAsset: $imageAsset, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('descriptionKey: $descriptionKey, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BannerRowsTable extends BannerRows
    with TableInfo<$BannerRowsTable, BannerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BannerRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageAssetMeta = const VerificationMeta(
    'imageAsset',
  );
  @override
  late final GeneratedColumn<String> imageAsset = GeneratedColumn<String>(
    'image_asset',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, imageAsset, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'banner_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<BannerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('image_asset')) {
      context.handle(
        _imageAssetMeta,
        imageAsset.isAcceptableOrUnknown(data['image_asset']!, _imageAssetMeta),
      );
    } else if (isInserting) {
      context.missing(_imageAssetMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BannerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BannerRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      imageAsset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_asset'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $BannerRowsTable createAlias(String alias) {
    return $BannerRowsTable(attachedDatabase, alias);
  }
}

class BannerRow extends DataClass implements Insertable<BannerRow> {
  final String id;
  final String imageAsset;
  final int sortOrder;
  const BannerRow({
    required this.id,
    required this.imageAsset,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['image_asset'] = Variable<String>(imageAsset);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  BannerRowsCompanion toCompanion(bool nullToAbsent) {
    return BannerRowsCompanion(
      id: Value(id),
      imageAsset: Value(imageAsset),
      sortOrder: Value(sortOrder),
    );
  }

  factory BannerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BannerRow(
      id: serializer.fromJson<String>(json['id']),
      imageAsset: serializer.fromJson<String>(json['imageAsset']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'imageAsset': serializer.toJson<String>(imageAsset),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  BannerRow copyWith({String? id, String? imageAsset, int? sortOrder}) =>
      BannerRow(
        id: id ?? this.id,
        imageAsset: imageAsset ?? this.imageAsset,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  BannerRow copyWithCompanion(BannerRowsCompanion data) {
    return BannerRow(
      id: data.id.present ? data.id.value : this.id,
      imageAsset: data.imageAsset.present
          ? data.imageAsset.value
          : this.imageAsset,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BannerRow(')
          ..write('id: $id, ')
          ..write('imageAsset: $imageAsset, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, imageAsset, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BannerRow &&
          other.id == this.id &&
          other.imageAsset == this.imageAsset &&
          other.sortOrder == this.sortOrder);
}

class BannerRowsCompanion extends UpdateCompanion<BannerRow> {
  final Value<String> id;
  final Value<String> imageAsset;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const BannerRowsCompanion({
    this.id = const Value.absent(),
    this.imageAsset = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BannerRowsCompanion.insert({
    required String id,
    required String imageAsset,
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       imageAsset = Value(imageAsset),
       sortOrder = Value(sortOrder);
  static Insertable<BannerRow> custom({
    Expression<String>? id,
    Expression<String>? imageAsset,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (imageAsset != null) 'image_asset': imageAsset,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BannerRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? imageAsset,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return BannerRowsCompanion(
      id: id ?? this.id,
      imageAsset: imageAsset ?? this.imageAsset,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (imageAsset.present) {
      map['image_asset'] = Variable<String>(imageAsset.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BannerRowsCompanion(')
          ..write('id: $id, ')
          ..write('imageAsset: $imageAsset, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SectionRowsTable extends SectionRows
    with TableInfo<$SectionRowsTable, SectionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SectionRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleKeyMeta = const VerificationMeta(
    'titleKey',
  );
  @override
  late final GeneratedColumn<String> titleKey = GeneratedColumn<String>(
    'title_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardStyleMeta = const VerificationMeta(
    'cardStyle',
  );
  @override
  late final GeneratedColumn<String> cardStyle = GeneratedColumn<String>(
    'card_style',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, titleKey, cardStyle, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'section_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<SectionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title_key')) {
      context.handle(
        _titleKeyMeta,
        titleKey.isAcceptableOrUnknown(data['title_key']!, _titleKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_titleKeyMeta);
    }
    if (data.containsKey('card_style')) {
      context.handle(
        _cardStyleMeta,
        cardStyle.isAcceptableOrUnknown(data['card_style']!, _cardStyleMeta),
      );
    } else if (isInserting) {
      context.missing(_cardStyleMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SectionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SectionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      titleKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_key'],
      )!,
      cardStyle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_style'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $SectionRowsTable createAlias(String alias) {
    return $SectionRowsTable(attachedDatabase, alias);
  }
}

class SectionRow extends DataClass implements Insertable<SectionRow> {
  final String id;
  final String titleKey;
  final String cardStyle;
  final int sortOrder;
  const SectionRow({
    required this.id,
    required this.titleKey,
    required this.cardStyle,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title_key'] = Variable<String>(titleKey);
    map['card_style'] = Variable<String>(cardStyle);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  SectionRowsCompanion toCompanion(bool nullToAbsent) {
    return SectionRowsCompanion(
      id: Value(id),
      titleKey: Value(titleKey),
      cardStyle: Value(cardStyle),
      sortOrder: Value(sortOrder),
    );
  }

  factory SectionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SectionRow(
      id: serializer.fromJson<String>(json['id']),
      titleKey: serializer.fromJson<String>(json['titleKey']),
      cardStyle: serializer.fromJson<String>(json['cardStyle']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'titleKey': serializer.toJson<String>(titleKey),
      'cardStyle': serializer.toJson<String>(cardStyle),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  SectionRow copyWith({
    String? id,
    String? titleKey,
    String? cardStyle,
    int? sortOrder,
  }) => SectionRow(
    id: id ?? this.id,
    titleKey: titleKey ?? this.titleKey,
    cardStyle: cardStyle ?? this.cardStyle,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  SectionRow copyWithCompanion(SectionRowsCompanion data) {
    return SectionRow(
      id: data.id.present ? data.id.value : this.id,
      titleKey: data.titleKey.present ? data.titleKey.value : this.titleKey,
      cardStyle: data.cardStyle.present ? data.cardStyle.value : this.cardStyle,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SectionRow(')
          ..write('id: $id, ')
          ..write('titleKey: $titleKey, ')
          ..write('cardStyle: $cardStyle, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, titleKey, cardStyle, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SectionRow &&
          other.id == this.id &&
          other.titleKey == this.titleKey &&
          other.cardStyle == this.cardStyle &&
          other.sortOrder == this.sortOrder);
}

class SectionRowsCompanion extends UpdateCompanion<SectionRow> {
  final Value<String> id;
  final Value<String> titleKey;
  final Value<String> cardStyle;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const SectionRowsCompanion({
    this.id = const Value.absent(),
    this.titleKey = const Value.absent(),
    this.cardStyle = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SectionRowsCompanion.insert({
    required String id,
    required String titleKey,
    required String cardStyle,
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       titleKey = Value(titleKey),
       cardStyle = Value(cardStyle),
       sortOrder = Value(sortOrder);
  static Insertable<SectionRow> custom({
    Expression<String>? id,
    Expression<String>? titleKey,
    Expression<String>? cardStyle,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titleKey != null) 'title_key': titleKey,
      if (cardStyle != null) 'card_style': cardStyle,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SectionRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? titleKey,
    Value<String>? cardStyle,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return SectionRowsCompanion(
      id: id ?? this.id,
      titleKey: titleKey ?? this.titleKey,
      cardStyle: cardStyle ?? this.cardStyle,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (titleKey.present) {
      map['title_key'] = Variable<String>(titleKey.value);
    }
    if (cardStyle.present) {
      map['card_style'] = Variable<String>(cardStyle.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SectionRowsCompanion(')
          ..write('id: $id, ')
          ..write('titleKey: $titleKey, ')
          ..write('cardStyle: $cardStyle, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SectionProductRowsTable extends SectionProductRows
    with TableInfo<$SectionProductRowsTable, SectionProductRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SectionProductRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sectionIdMeta = const VerificationMeta(
    'sectionId',
  );
  @override
  late final GeneratedColumn<String> sectionId = GeneratedColumn<String>(
    'section_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortIndexMeta = const VerificationMeta(
    'sortIndex',
  );
  @override
  late final GeneratedColumn<int> sortIndex = GeneratedColumn<int>(
    'sort_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [sectionId, productId, sortIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'section_product_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<SectionProductRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('section_id')) {
      context.handle(
        _sectionIdMeta,
        sectionId.isAcceptableOrUnknown(data['section_id']!, _sectionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sectionIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('sort_index')) {
      context.handle(
        _sortIndexMeta,
        sortIndex.isAcceptableOrUnknown(data['sort_index']!, _sortIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_sortIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sectionId, productId};
  @override
  SectionProductRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SectionProductRow(
      sectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      sortIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_index'],
      )!,
    );
  }

  @override
  $SectionProductRowsTable createAlias(String alias) {
    return $SectionProductRowsTable(attachedDatabase, alias);
  }
}

class SectionProductRow extends DataClass
    implements Insertable<SectionProductRow> {
  final String sectionId;
  final String productId;
  final int sortIndex;
  const SectionProductRow({
    required this.sectionId,
    required this.productId,
    required this.sortIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['section_id'] = Variable<String>(sectionId);
    map['product_id'] = Variable<String>(productId);
    map['sort_index'] = Variable<int>(sortIndex);
    return map;
  }

  SectionProductRowsCompanion toCompanion(bool nullToAbsent) {
    return SectionProductRowsCompanion(
      sectionId: Value(sectionId),
      productId: Value(productId),
      sortIndex: Value(sortIndex),
    );
  }

  factory SectionProductRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SectionProductRow(
      sectionId: serializer.fromJson<String>(json['sectionId']),
      productId: serializer.fromJson<String>(json['productId']),
      sortIndex: serializer.fromJson<int>(json['sortIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sectionId': serializer.toJson<String>(sectionId),
      'productId': serializer.toJson<String>(productId),
      'sortIndex': serializer.toJson<int>(sortIndex),
    };
  }

  SectionProductRow copyWith({
    String? sectionId,
    String? productId,
    int? sortIndex,
  }) => SectionProductRow(
    sectionId: sectionId ?? this.sectionId,
    productId: productId ?? this.productId,
    sortIndex: sortIndex ?? this.sortIndex,
  );
  SectionProductRow copyWithCompanion(SectionProductRowsCompanion data) {
    return SectionProductRow(
      sectionId: data.sectionId.present ? data.sectionId.value : this.sectionId,
      productId: data.productId.present ? data.productId.value : this.productId,
      sortIndex: data.sortIndex.present ? data.sortIndex.value : this.sortIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SectionProductRow(')
          ..write('sectionId: $sectionId, ')
          ..write('productId: $productId, ')
          ..write('sortIndex: $sortIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(sectionId, productId, sortIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SectionProductRow &&
          other.sectionId == this.sectionId &&
          other.productId == this.productId &&
          other.sortIndex == this.sortIndex);
}

class SectionProductRowsCompanion extends UpdateCompanion<SectionProductRow> {
  final Value<String> sectionId;
  final Value<String> productId;
  final Value<int> sortIndex;
  final Value<int> rowid;
  const SectionProductRowsCompanion({
    this.sectionId = const Value.absent(),
    this.productId = const Value.absent(),
    this.sortIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SectionProductRowsCompanion.insert({
    required String sectionId,
    required String productId,
    required int sortIndex,
    this.rowid = const Value.absent(),
  }) : sectionId = Value(sectionId),
       productId = Value(productId),
       sortIndex = Value(sortIndex);
  static Insertable<SectionProductRow> custom({
    Expression<String>? sectionId,
    Expression<String>? productId,
    Expression<int>? sortIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sectionId != null) 'section_id': sectionId,
      if (productId != null) 'product_id': productId,
      if (sortIndex != null) 'sort_index': sortIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SectionProductRowsCompanion copyWith({
    Value<String>? sectionId,
    Value<String>? productId,
    Value<int>? sortIndex,
    Value<int>? rowid,
  }) {
    return SectionProductRowsCompanion(
      sectionId: sectionId ?? this.sectionId,
      productId: productId ?? this.productId,
      sortIndex: sortIndex ?? this.sortIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sectionId.present) {
      map['section_id'] = Variable<String>(sectionId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (sortIndex.present) {
      map['sort_index'] = Variable<int>(sortIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SectionProductRowsCompanion(')
          ..write('sectionId: $sectionId, ')
          ..write('productId: $productId, ')
          ..write('sortIndex: $sortIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShopRowsTable extends ShopRows with TableInfo<$ShopRowsTable, ShopRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShopRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameKeyMeta = const VerificationMeta(
    'nameKey',
  );
  @override
  late final GeneratedColumn<String> nameKey = GeneratedColumn<String>(
    'name_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressKeyMeta = const VerificationMeta(
    'addressKey',
  );
  @override
  late final GeneratedColumn<String> addressKey = GeneratedColumn<String>(
    'address_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageAssetMeta = const VerificationMeta(
    'imageAsset',
  );
  @override
  late final GeneratedColumn<String> imageAsset = GeneratedColumn<String>(
    'image_asset',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nameKey,
    addressKey,
    imageAsset,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shop_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShopRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name_key')) {
      context.handle(
        _nameKeyMeta,
        nameKey.isAcceptableOrUnknown(data['name_key']!, _nameKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_nameKeyMeta);
    }
    if (data.containsKey('address_key')) {
      context.handle(
        _addressKeyMeta,
        addressKey.isAcceptableOrUnknown(data['address_key']!, _addressKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_addressKeyMeta);
    }
    if (data.containsKey('image_asset')) {
      context.handle(
        _imageAssetMeta,
        imageAsset.isAcceptableOrUnknown(data['image_asset']!, _imageAssetMeta),
      );
    } else if (isInserting) {
      context.missing(_imageAssetMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShopRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShopRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nameKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_key'],
      )!,
      addressKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_key'],
      )!,
      imageAsset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_asset'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $ShopRowsTable createAlias(String alias) {
    return $ShopRowsTable(attachedDatabase, alias);
  }
}

class ShopRow extends DataClass implements Insertable<ShopRow> {
  final String id;
  final String nameKey;
  final String addressKey;
  final String imageAsset;
  final int sortOrder;
  const ShopRow({
    required this.id,
    required this.nameKey,
    required this.addressKey,
    required this.imageAsset,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name_key'] = Variable<String>(nameKey);
    map['address_key'] = Variable<String>(addressKey);
    map['image_asset'] = Variable<String>(imageAsset);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  ShopRowsCompanion toCompanion(bool nullToAbsent) {
    return ShopRowsCompanion(
      id: Value(id),
      nameKey: Value(nameKey),
      addressKey: Value(addressKey),
      imageAsset: Value(imageAsset),
      sortOrder: Value(sortOrder),
    );
  }

  factory ShopRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShopRow(
      id: serializer.fromJson<String>(json['id']),
      nameKey: serializer.fromJson<String>(json['nameKey']),
      addressKey: serializer.fromJson<String>(json['addressKey']),
      imageAsset: serializer.fromJson<String>(json['imageAsset']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nameKey': serializer.toJson<String>(nameKey),
      'addressKey': serializer.toJson<String>(addressKey),
      'imageAsset': serializer.toJson<String>(imageAsset),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  ShopRow copyWith({
    String? id,
    String? nameKey,
    String? addressKey,
    String? imageAsset,
    int? sortOrder,
  }) => ShopRow(
    id: id ?? this.id,
    nameKey: nameKey ?? this.nameKey,
    addressKey: addressKey ?? this.addressKey,
    imageAsset: imageAsset ?? this.imageAsset,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  ShopRow copyWithCompanion(ShopRowsCompanion data) {
    return ShopRow(
      id: data.id.present ? data.id.value : this.id,
      nameKey: data.nameKey.present ? data.nameKey.value : this.nameKey,
      addressKey: data.addressKey.present
          ? data.addressKey.value
          : this.addressKey,
      imageAsset: data.imageAsset.present
          ? data.imageAsset.value
          : this.imageAsset,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShopRow(')
          ..write('id: $id, ')
          ..write('nameKey: $nameKey, ')
          ..write('addressKey: $addressKey, ')
          ..write('imageAsset: $imageAsset, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nameKey, addressKey, imageAsset, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShopRow &&
          other.id == this.id &&
          other.nameKey == this.nameKey &&
          other.addressKey == this.addressKey &&
          other.imageAsset == this.imageAsset &&
          other.sortOrder == this.sortOrder);
}

class ShopRowsCompanion extends UpdateCompanion<ShopRow> {
  final Value<String> id;
  final Value<String> nameKey;
  final Value<String> addressKey;
  final Value<String> imageAsset;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const ShopRowsCompanion({
    this.id = const Value.absent(),
    this.nameKey = const Value.absent(),
    this.addressKey = const Value.absent(),
    this.imageAsset = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShopRowsCompanion.insert({
    required String id,
    required String nameKey,
    required String addressKey,
    required String imageAsset,
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nameKey = Value(nameKey),
       addressKey = Value(addressKey),
       imageAsset = Value(imageAsset),
       sortOrder = Value(sortOrder);
  static Insertable<ShopRow> custom({
    Expression<String>? id,
    Expression<String>? nameKey,
    Expression<String>? addressKey,
    Expression<String>? imageAsset,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameKey != null) 'name_key': nameKey,
      if (addressKey != null) 'address_key': addressKey,
      if (imageAsset != null) 'image_asset': imageAsset,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShopRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? nameKey,
    Value<String>? addressKey,
    Value<String>? imageAsset,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return ShopRowsCompanion(
      id: id ?? this.id,
      nameKey: nameKey ?? this.nameKey,
      addressKey: addressKey ?? this.addressKey,
      imageAsset: imageAsset ?? this.imageAsset,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nameKey.present) {
      map['name_key'] = Variable<String>(nameKey.value);
    }
    if (addressKey.present) {
      map['address_key'] = Variable<String>(addressKey.value);
    }
    if (imageAsset.present) {
      map['image_asset'] = Variable<String>(imageAsset.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShopRowsCompanion(')
          ..write('id: $id, ')
          ..write('nameKey: $nameKey, ')
          ..write('addressKey: $addressKey, ')
          ..write('imageAsset: $imageAsset, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChallengeRowsTable extends ChallengeRows
    with TableInfo<$ChallengeRowsTable, ChallengeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChallengeRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tabMeta = const VerificationMeta('tab');
  @override
  late final GeneratedColumn<String> tab = GeneratedColumn<String>(
    'tab',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleKeyMeta = const VerificationMeta(
    'titleKey',
  );
  @override
  late final GeneratedColumn<String> titleKey = GeneratedColumn<String>(
    'title_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _progressCurrentMeta = const VerificationMeta(
    'progressCurrent',
  );
  @override
  late final GeneratedColumn<int> progressCurrent = GeneratedColumn<int>(
    'progress_current',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _progressTotalMeta = const VerificationMeta(
    'progressTotal',
  );
  @override
  late final GeneratedColumn<int> progressTotal = GeneratedColumn<int>(
    'progress_total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pointsRewardMeta = const VerificationMeta(
    'pointsReward',
  );
  @override
  late final GeneratedColumn<int> pointsReward = GeneratedColumn<int>(
    'points_reward',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageAssetMeta = const VerificationMeta(
    'imageAsset',
  );
  @override
  late final GeneratedColumn<String> imageAsset = GeneratedColumn<String>(
    'image_asset',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tab,
    kind,
    titleKey,
    progressCurrent,
    progressTotal,
    pointsReward,
    imageAsset,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'challenge_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChallengeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tab')) {
      context.handle(
        _tabMeta,
        tab.isAcceptableOrUnknown(data['tab']!, _tabMeta),
      );
    } else if (isInserting) {
      context.missing(_tabMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('title_key')) {
      context.handle(
        _titleKeyMeta,
        titleKey.isAcceptableOrUnknown(data['title_key']!, _titleKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_titleKeyMeta);
    }
    if (data.containsKey('progress_current')) {
      context.handle(
        _progressCurrentMeta,
        progressCurrent.isAcceptableOrUnknown(
          data['progress_current']!,
          _progressCurrentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_progressCurrentMeta);
    }
    if (data.containsKey('progress_total')) {
      context.handle(
        _progressTotalMeta,
        progressTotal.isAcceptableOrUnknown(
          data['progress_total']!,
          _progressTotalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_progressTotalMeta);
    }
    if (data.containsKey('points_reward')) {
      context.handle(
        _pointsRewardMeta,
        pointsReward.isAcceptableOrUnknown(
          data['points_reward']!,
          _pointsRewardMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pointsRewardMeta);
    }
    if (data.containsKey('image_asset')) {
      context.handle(
        _imageAssetMeta,
        imageAsset.isAcceptableOrUnknown(data['image_asset']!, _imageAssetMeta),
      );
    } else if (isInserting) {
      context.missing(_imageAssetMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChallengeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChallengeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tab: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tab'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      titleKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_key'],
      )!,
      progressCurrent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress_current'],
      )!,
      progressTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress_total'],
      )!,
      pointsReward: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points_reward'],
      )!,
      imageAsset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_asset'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $ChallengeRowsTable createAlias(String alias) {
    return $ChallengeRowsTable(attachedDatabase, alias);
  }
}

class ChallengeRow extends DataClass implements Insertable<ChallengeRow> {
  final String id;
  final String tab;
  final String kind;
  final String titleKey;
  final int progressCurrent;
  final int progressTotal;
  final int pointsReward;
  final String imageAsset;
  final int sortOrder;
  const ChallengeRow({
    required this.id,
    required this.tab,
    required this.kind,
    required this.titleKey,
    required this.progressCurrent,
    required this.progressTotal,
    required this.pointsReward,
    required this.imageAsset,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tab'] = Variable<String>(tab);
    map['kind'] = Variable<String>(kind);
    map['title_key'] = Variable<String>(titleKey);
    map['progress_current'] = Variable<int>(progressCurrent);
    map['progress_total'] = Variable<int>(progressTotal);
    map['points_reward'] = Variable<int>(pointsReward);
    map['image_asset'] = Variable<String>(imageAsset);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  ChallengeRowsCompanion toCompanion(bool nullToAbsent) {
    return ChallengeRowsCompanion(
      id: Value(id),
      tab: Value(tab),
      kind: Value(kind),
      titleKey: Value(titleKey),
      progressCurrent: Value(progressCurrent),
      progressTotal: Value(progressTotal),
      pointsReward: Value(pointsReward),
      imageAsset: Value(imageAsset),
      sortOrder: Value(sortOrder),
    );
  }

  factory ChallengeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChallengeRow(
      id: serializer.fromJson<String>(json['id']),
      tab: serializer.fromJson<String>(json['tab']),
      kind: serializer.fromJson<String>(json['kind']),
      titleKey: serializer.fromJson<String>(json['titleKey']),
      progressCurrent: serializer.fromJson<int>(json['progressCurrent']),
      progressTotal: serializer.fromJson<int>(json['progressTotal']),
      pointsReward: serializer.fromJson<int>(json['pointsReward']),
      imageAsset: serializer.fromJson<String>(json['imageAsset']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tab': serializer.toJson<String>(tab),
      'kind': serializer.toJson<String>(kind),
      'titleKey': serializer.toJson<String>(titleKey),
      'progressCurrent': serializer.toJson<int>(progressCurrent),
      'progressTotal': serializer.toJson<int>(progressTotal),
      'pointsReward': serializer.toJson<int>(pointsReward),
      'imageAsset': serializer.toJson<String>(imageAsset),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  ChallengeRow copyWith({
    String? id,
    String? tab,
    String? kind,
    String? titleKey,
    int? progressCurrent,
    int? progressTotal,
    int? pointsReward,
    String? imageAsset,
    int? sortOrder,
  }) => ChallengeRow(
    id: id ?? this.id,
    tab: tab ?? this.tab,
    kind: kind ?? this.kind,
    titleKey: titleKey ?? this.titleKey,
    progressCurrent: progressCurrent ?? this.progressCurrent,
    progressTotal: progressTotal ?? this.progressTotal,
    pointsReward: pointsReward ?? this.pointsReward,
    imageAsset: imageAsset ?? this.imageAsset,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  ChallengeRow copyWithCompanion(ChallengeRowsCompanion data) {
    return ChallengeRow(
      id: data.id.present ? data.id.value : this.id,
      tab: data.tab.present ? data.tab.value : this.tab,
      kind: data.kind.present ? data.kind.value : this.kind,
      titleKey: data.titleKey.present ? data.titleKey.value : this.titleKey,
      progressCurrent: data.progressCurrent.present
          ? data.progressCurrent.value
          : this.progressCurrent,
      progressTotal: data.progressTotal.present
          ? data.progressTotal.value
          : this.progressTotal,
      pointsReward: data.pointsReward.present
          ? data.pointsReward.value
          : this.pointsReward,
      imageAsset: data.imageAsset.present
          ? data.imageAsset.value
          : this.imageAsset,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChallengeRow(')
          ..write('id: $id, ')
          ..write('tab: $tab, ')
          ..write('kind: $kind, ')
          ..write('titleKey: $titleKey, ')
          ..write('progressCurrent: $progressCurrent, ')
          ..write('progressTotal: $progressTotal, ')
          ..write('pointsReward: $pointsReward, ')
          ..write('imageAsset: $imageAsset, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tab,
    kind,
    titleKey,
    progressCurrent,
    progressTotal,
    pointsReward,
    imageAsset,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChallengeRow &&
          other.id == this.id &&
          other.tab == this.tab &&
          other.kind == this.kind &&
          other.titleKey == this.titleKey &&
          other.progressCurrent == this.progressCurrent &&
          other.progressTotal == this.progressTotal &&
          other.pointsReward == this.pointsReward &&
          other.imageAsset == this.imageAsset &&
          other.sortOrder == this.sortOrder);
}

class ChallengeRowsCompanion extends UpdateCompanion<ChallengeRow> {
  final Value<String> id;
  final Value<String> tab;
  final Value<String> kind;
  final Value<String> titleKey;
  final Value<int> progressCurrent;
  final Value<int> progressTotal;
  final Value<int> pointsReward;
  final Value<String> imageAsset;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const ChallengeRowsCompanion({
    this.id = const Value.absent(),
    this.tab = const Value.absent(),
    this.kind = const Value.absent(),
    this.titleKey = const Value.absent(),
    this.progressCurrent = const Value.absent(),
    this.progressTotal = const Value.absent(),
    this.pointsReward = const Value.absent(),
    this.imageAsset = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChallengeRowsCompanion.insert({
    required String id,
    required String tab,
    required String kind,
    required String titleKey,
    required int progressCurrent,
    required int progressTotal,
    required int pointsReward,
    required String imageAsset,
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tab = Value(tab),
       kind = Value(kind),
       titleKey = Value(titleKey),
       progressCurrent = Value(progressCurrent),
       progressTotal = Value(progressTotal),
       pointsReward = Value(pointsReward),
       imageAsset = Value(imageAsset),
       sortOrder = Value(sortOrder);
  static Insertable<ChallengeRow> custom({
    Expression<String>? id,
    Expression<String>? tab,
    Expression<String>? kind,
    Expression<String>? titleKey,
    Expression<int>? progressCurrent,
    Expression<int>? progressTotal,
    Expression<int>? pointsReward,
    Expression<String>? imageAsset,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tab != null) 'tab': tab,
      if (kind != null) 'kind': kind,
      if (titleKey != null) 'title_key': titleKey,
      if (progressCurrent != null) 'progress_current': progressCurrent,
      if (progressTotal != null) 'progress_total': progressTotal,
      if (pointsReward != null) 'points_reward': pointsReward,
      if (imageAsset != null) 'image_asset': imageAsset,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChallengeRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? tab,
    Value<String>? kind,
    Value<String>? titleKey,
    Value<int>? progressCurrent,
    Value<int>? progressTotal,
    Value<int>? pointsReward,
    Value<String>? imageAsset,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return ChallengeRowsCompanion(
      id: id ?? this.id,
      tab: tab ?? this.tab,
      kind: kind ?? this.kind,
      titleKey: titleKey ?? this.titleKey,
      progressCurrent: progressCurrent ?? this.progressCurrent,
      progressTotal: progressTotal ?? this.progressTotal,
      pointsReward: pointsReward ?? this.pointsReward,
      imageAsset: imageAsset ?? this.imageAsset,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tab.present) {
      map['tab'] = Variable<String>(tab.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (titleKey.present) {
      map['title_key'] = Variable<String>(titleKey.value);
    }
    if (progressCurrent.present) {
      map['progress_current'] = Variable<int>(progressCurrent.value);
    }
    if (progressTotal.present) {
      map['progress_total'] = Variable<int>(progressTotal.value);
    }
    if (pointsReward.present) {
      map['points_reward'] = Variable<int>(pointsReward.value);
    }
    if (imageAsset.present) {
      map['image_asset'] = Variable<String>(imageAsset.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChallengeRowsCompanion(')
          ..write('id: $id, ')
          ..write('tab: $tab, ')
          ..write('kind: $kind, ')
          ..write('titleKey: $titleKey, ')
          ..write('progressCurrent: $progressCurrent, ')
          ..write('progressTotal: $progressTotal, ')
          ..write('pointsReward: $pointsReward, ')
          ..write('imageAsset: $imageAsset, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MemberRowsTable memberRows = $MemberRowsTable(this);
  late final $ProductRowsTable productRows = $ProductRowsTable(this);
  late final $BannerRowsTable bannerRows = $BannerRowsTable(this);
  late final $SectionRowsTable sectionRows = $SectionRowsTable(this);
  late final $SectionProductRowsTable sectionProductRows =
      $SectionProductRowsTable(this);
  late final $ShopRowsTable shopRows = $ShopRowsTable(this);
  late final $ChallengeRowsTable challengeRows = $ChallengeRowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    memberRows,
    productRows,
    bannerRows,
    sectionRows,
    sectionProductRows,
    shopRows,
    challengeRows,
  ];
}

typedef $$MemberRowsTableCreateCompanionBuilder =
    MemberRowsCompanion Function({
      required String id,
      required String displayName,
      required String subtitleKey,
      required String avatarAsset,
      required String tierProgressKey,
      required int tierProgressKyats,
      required int notificationCount,
      required String tierCode,
      required int pointsBalance,
      required int pointsToNextTier,
      Value<int> rewardsPillCount,
      Value<int> tierLadderFillBp,
      Value<int> rowid,
    });
typedef $$MemberRowsTableUpdateCompanionBuilder =
    MemberRowsCompanion Function({
      Value<String> id,
      Value<String> displayName,
      Value<String> subtitleKey,
      Value<String> avatarAsset,
      Value<String> tierProgressKey,
      Value<int> tierProgressKyats,
      Value<int> notificationCount,
      Value<String> tierCode,
      Value<int> pointsBalance,
      Value<int> pointsToNextTier,
      Value<int> rewardsPillCount,
      Value<int> tierLadderFillBp,
      Value<int> rowid,
    });

class $$MemberRowsTableFilterComposer
    extends Composer<_$AppDatabase, $MemberRowsTable> {
  $$MemberRowsTableFilterComposer({
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

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subtitleKey => $composableBuilder(
    column: $table.subtitleKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarAsset => $composableBuilder(
    column: $table.avatarAsset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tierProgressKey => $composableBuilder(
    column: $table.tierProgressKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tierProgressKyats => $composableBuilder(
    column: $table.tierProgressKyats,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get notificationCount => $composableBuilder(
    column: $table.notificationCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tierCode => $composableBuilder(
    column: $table.tierCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pointsBalance => $composableBuilder(
    column: $table.pointsBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pointsToNextTier => $composableBuilder(
    column: $table.pointsToNextTier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rewardsPillCount => $composableBuilder(
    column: $table.rewardsPillCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tierLadderFillBp => $composableBuilder(
    column: $table.tierLadderFillBp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MemberRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $MemberRowsTable> {
  $$MemberRowsTableOrderingComposer({
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

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtitleKey => $composableBuilder(
    column: $table.subtitleKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarAsset => $composableBuilder(
    column: $table.avatarAsset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tierProgressKey => $composableBuilder(
    column: $table.tierProgressKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tierProgressKyats => $composableBuilder(
    column: $table.tierProgressKyats,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get notificationCount => $composableBuilder(
    column: $table.notificationCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tierCode => $composableBuilder(
    column: $table.tierCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pointsBalance => $composableBuilder(
    column: $table.pointsBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pointsToNextTier => $composableBuilder(
    column: $table.pointsToNextTier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rewardsPillCount => $composableBuilder(
    column: $table.rewardsPillCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tierLadderFillBp => $composableBuilder(
    column: $table.tierLadderFillBp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MemberRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemberRowsTable> {
  $$MemberRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subtitleKey => $composableBuilder(
    column: $table.subtitleKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get avatarAsset => $composableBuilder(
    column: $table.avatarAsset,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tierProgressKey => $composableBuilder(
    column: $table.tierProgressKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tierProgressKyats => $composableBuilder(
    column: $table.tierProgressKyats,
    builder: (column) => column,
  );

  GeneratedColumn<int> get notificationCount => $composableBuilder(
    column: $table.notificationCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tierCode =>
      $composableBuilder(column: $table.tierCode, builder: (column) => column);

  GeneratedColumn<int> get pointsBalance => $composableBuilder(
    column: $table.pointsBalance,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pointsToNextTier => $composableBuilder(
    column: $table.pointsToNextTier,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rewardsPillCount => $composableBuilder(
    column: $table.rewardsPillCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tierLadderFillBp => $composableBuilder(
    column: $table.tierLadderFillBp,
    builder: (column) => column,
  );
}

class $$MemberRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemberRowsTable,
          MemberRow,
          $$MemberRowsTableFilterComposer,
          $$MemberRowsTableOrderingComposer,
          $$MemberRowsTableAnnotationComposer,
          $$MemberRowsTableCreateCompanionBuilder,
          $$MemberRowsTableUpdateCompanionBuilder,
          (
            MemberRow,
            BaseReferences<_$AppDatabase, $MemberRowsTable, MemberRow>,
          ),
          MemberRow,
          PrefetchHooks Function()
        > {
  $$MemberRowsTableTableManager(_$AppDatabase db, $MemberRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemberRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemberRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemberRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> subtitleKey = const Value.absent(),
                Value<String> avatarAsset = const Value.absent(),
                Value<String> tierProgressKey = const Value.absent(),
                Value<int> tierProgressKyats = const Value.absent(),
                Value<int> notificationCount = const Value.absent(),
                Value<String> tierCode = const Value.absent(),
                Value<int> pointsBalance = const Value.absent(),
                Value<int> pointsToNextTier = const Value.absent(),
                Value<int> rewardsPillCount = const Value.absent(),
                Value<int> tierLadderFillBp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemberRowsCompanion(
                id: id,
                displayName: displayName,
                subtitleKey: subtitleKey,
                avatarAsset: avatarAsset,
                tierProgressKey: tierProgressKey,
                tierProgressKyats: tierProgressKyats,
                notificationCount: notificationCount,
                tierCode: tierCode,
                pointsBalance: pointsBalance,
                pointsToNextTier: pointsToNextTier,
                rewardsPillCount: rewardsPillCount,
                tierLadderFillBp: tierLadderFillBp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String displayName,
                required String subtitleKey,
                required String avatarAsset,
                required String tierProgressKey,
                required int tierProgressKyats,
                required int notificationCount,
                required String tierCode,
                required int pointsBalance,
                required int pointsToNextTier,
                Value<int> rewardsPillCount = const Value.absent(),
                Value<int> tierLadderFillBp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MemberRowsCompanion.insert(
                id: id,
                displayName: displayName,
                subtitleKey: subtitleKey,
                avatarAsset: avatarAsset,
                tierProgressKey: tierProgressKey,
                tierProgressKyats: tierProgressKyats,
                notificationCount: notificationCount,
                tierCode: tierCode,
                pointsBalance: pointsBalance,
                pointsToNextTier: pointsToNextTier,
                rewardsPillCount: rewardsPillCount,
                tierLadderFillBp: tierLadderFillBp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MemberRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemberRowsTable,
      MemberRow,
      $$MemberRowsTableFilterComposer,
      $$MemberRowsTableOrderingComposer,
      $$MemberRowsTableAnnotationComposer,
      $$MemberRowsTableCreateCompanionBuilder,
      $$MemberRowsTableUpdateCompanionBuilder,
      (MemberRow, BaseReferences<_$AppDatabase, $MemberRowsTable, MemberRow>),
      MemberRow,
      PrefetchHooks Function()
    >;
typedef $$ProductRowsTableCreateCompanionBuilder =
    ProductRowsCompanion Function({
      required String id,
      required String code,
      required String nameKey,
      required int priceMmk,
      required bool isNew,
      Value<int?> discountPercent,
      required String imageAsset,
      Value<String?> imageUrl,
      required String descriptionKey,
      Value<int> rowid,
    });
typedef $$ProductRowsTableUpdateCompanionBuilder =
    ProductRowsCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<String> nameKey,
      Value<int> priceMmk,
      Value<bool> isNew,
      Value<int?> discountPercent,
      Value<String> imageAsset,
      Value<String?> imageUrl,
      Value<String> descriptionKey,
      Value<int> rowid,
    });

class $$ProductRowsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductRowsTable> {
  $$ProductRowsTableFilterComposer({
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

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameKey => $composableBuilder(
    column: $table.nameKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceMmk => $composableBuilder(
    column: $table.priceMmk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isNew => $composableBuilder(
    column: $table.isNew,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionKey => $composableBuilder(
    column: $table.descriptionKey,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductRowsTable> {
  $$ProductRowsTableOrderingComposer({
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

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameKey => $composableBuilder(
    column: $table.nameKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceMmk => $composableBuilder(
    column: $table.priceMmk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isNew => $composableBuilder(
    column: $table.isNew,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionKey => $composableBuilder(
    column: $table.descriptionKey,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductRowsTable> {
  $$ProductRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get nameKey =>
      $composableBuilder(column: $table.nameKey, builder: (column) => column);

  GeneratedColumn<int> get priceMmk =>
      $composableBuilder(column: $table.priceMmk, builder: (column) => column);

  GeneratedColumn<bool> get isNew =>
      $composableBuilder(column: $table.isNew, builder: (column) => column);

  GeneratedColumn<int> get discountPercent => $composableBuilder(
    column: $table.discountPercent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get descriptionKey => $composableBuilder(
    column: $table.descriptionKey,
    builder: (column) => column,
  );
}

class $$ProductRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductRowsTable,
          ProductRow,
          $$ProductRowsTableFilterComposer,
          $$ProductRowsTableOrderingComposer,
          $$ProductRowsTableAnnotationComposer,
          $$ProductRowsTableCreateCompanionBuilder,
          $$ProductRowsTableUpdateCompanionBuilder,
          (
            ProductRow,
            BaseReferences<_$AppDatabase, $ProductRowsTable, ProductRow>,
          ),
          ProductRow,
          PrefetchHooks Function()
        > {
  $$ProductRowsTableTableManager(_$AppDatabase db, $ProductRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> nameKey = const Value.absent(),
                Value<int> priceMmk = const Value.absent(),
                Value<bool> isNew = const Value.absent(),
                Value<int?> discountPercent = const Value.absent(),
                Value<String> imageAsset = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String> descriptionKey = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductRowsCompanion(
                id: id,
                code: code,
                nameKey: nameKey,
                priceMmk: priceMmk,
                isNew: isNew,
                discountPercent: discountPercent,
                imageAsset: imageAsset,
                imageUrl: imageUrl,
                descriptionKey: descriptionKey,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                required String nameKey,
                required int priceMmk,
                required bool isNew,
                Value<int?> discountPercent = const Value.absent(),
                required String imageAsset,
                Value<String?> imageUrl = const Value.absent(),
                required String descriptionKey,
                Value<int> rowid = const Value.absent(),
              }) => ProductRowsCompanion.insert(
                id: id,
                code: code,
                nameKey: nameKey,
                priceMmk: priceMmk,
                isNew: isNew,
                discountPercent: discountPercent,
                imageAsset: imageAsset,
                imageUrl: imageUrl,
                descriptionKey: descriptionKey,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductRowsTable,
      ProductRow,
      $$ProductRowsTableFilterComposer,
      $$ProductRowsTableOrderingComposer,
      $$ProductRowsTableAnnotationComposer,
      $$ProductRowsTableCreateCompanionBuilder,
      $$ProductRowsTableUpdateCompanionBuilder,
      (
        ProductRow,
        BaseReferences<_$AppDatabase, $ProductRowsTable, ProductRow>,
      ),
      ProductRow,
      PrefetchHooks Function()
    >;
typedef $$BannerRowsTableCreateCompanionBuilder =
    BannerRowsCompanion Function({
      required String id,
      required String imageAsset,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$BannerRowsTableUpdateCompanionBuilder =
    BannerRowsCompanion Function({
      Value<String> id,
      Value<String> imageAsset,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$BannerRowsTableFilterComposer
    extends Composer<_$AppDatabase, $BannerRowsTable> {
  $$BannerRowsTableFilterComposer({
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

  ColumnFilters<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BannerRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $BannerRowsTable> {
  $$BannerRowsTableOrderingComposer({
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

  ColumnOrderings<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BannerRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BannerRowsTable> {
  $$BannerRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$BannerRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BannerRowsTable,
          BannerRow,
          $$BannerRowsTableFilterComposer,
          $$BannerRowsTableOrderingComposer,
          $$BannerRowsTableAnnotationComposer,
          $$BannerRowsTableCreateCompanionBuilder,
          $$BannerRowsTableUpdateCompanionBuilder,
          (
            BannerRow,
            BaseReferences<_$AppDatabase, $BannerRowsTable, BannerRow>,
          ),
          BannerRow,
          PrefetchHooks Function()
        > {
  $$BannerRowsTableTableManager(_$AppDatabase db, $BannerRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BannerRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BannerRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BannerRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> imageAsset = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BannerRowsCompanion(
                id: id,
                imageAsset: imageAsset,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String imageAsset,
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => BannerRowsCompanion.insert(
                id: id,
                imageAsset: imageAsset,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BannerRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BannerRowsTable,
      BannerRow,
      $$BannerRowsTableFilterComposer,
      $$BannerRowsTableOrderingComposer,
      $$BannerRowsTableAnnotationComposer,
      $$BannerRowsTableCreateCompanionBuilder,
      $$BannerRowsTableUpdateCompanionBuilder,
      (BannerRow, BaseReferences<_$AppDatabase, $BannerRowsTable, BannerRow>),
      BannerRow,
      PrefetchHooks Function()
    >;
typedef $$SectionRowsTableCreateCompanionBuilder =
    SectionRowsCompanion Function({
      required String id,
      required String titleKey,
      required String cardStyle,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$SectionRowsTableUpdateCompanionBuilder =
    SectionRowsCompanion Function({
      Value<String> id,
      Value<String> titleKey,
      Value<String> cardStyle,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$SectionRowsTableFilterComposer
    extends Composer<_$AppDatabase, $SectionRowsTable> {
  $$SectionRowsTableFilterComposer({
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

  ColumnFilters<String> get titleKey => $composableBuilder(
    column: $table.titleKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardStyle => $composableBuilder(
    column: $table.cardStyle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SectionRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $SectionRowsTable> {
  $$SectionRowsTableOrderingComposer({
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

  ColumnOrderings<String> get titleKey => $composableBuilder(
    column: $table.titleKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardStyle => $composableBuilder(
    column: $table.cardStyle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SectionRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SectionRowsTable> {
  $$SectionRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titleKey =>
      $composableBuilder(column: $table.titleKey, builder: (column) => column);

  GeneratedColumn<String> get cardStyle =>
      $composableBuilder(column: $table.cardStyle, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$SectionRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SectionRowsTable,
          SectionRow,
          $$SectionRowsTableFilterComposer,
          $$SectionRowsTableOrderingComposer,
          $$SectionRowsTableAnnotationComposer,
          $$SectionRowsTableCreateCompanionBuilder,
          $$SectionRowsTableUpdateCompanionBuilder,
          (
            SectionRow,
            BaseReferences<_$AppDatabase, $SectionRowsTable, SectionRow>,
          ),
          SectionRow,
          PrefetchHooks Function()
        > {
  $$SectionRowsTableTableManager(_$AppDatabase db, $SectionRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SectionRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SectionRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SectionRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> titleKey = const Value.absent(),
                Value<String> cardStyle = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SectionRowsCompanion(
                id: id,
                titleKey: titleKey,
                cardStyle: cardStyle,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String titleKey,
                required String cardStyle,
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => SectionRowsCompanion.insert(
                id: id,
                titleKey: titleKey,
                cardStyle: cardStyle,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SectionRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SectionRowsTable,
      SectionRow,
      $$SectionRowsTableFilterComposer,
      $$SectionRowsTableOrderingComposer,
      $$SectionRowsTableAnnotationComposer,
      $$SectionRowsTableCreateCompanionBuilder,
      $$SectionRowsTableUpdateCompanionBuilder,
      (
        SectionRow,
        BaseReferences<_$AppDatabase, $SectionRowsTable, SectionRow>,
      ),
      SectionRow,
      PrefetchHooks Function()
    >;
typedef $$SectionProductRowsTableCreateCompanionBuilder =
    SectionProductRowsCompanion Function({
      required String sectionId,
      required String productId,
      required int sortIndex,
      Value<int> rowid,
    });
typedef $$SectionProductRowsTableUpdateCompanionBuilder =
    SectionProductRowsCompanion Function({
      Value<String> sectionId,
      Value<String> productId,
      Value<int> sortIndex,
      Value<int> rowid,
    });

class $$SectionProductRowsTableFilterComposer
    extends Composer<_$AppDatabase, $SectionProductRowsTable> {
  $$SectionProductRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SectionProductRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $SectionProductRowsTable> {
  $$SectionProductRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sectionId => $composableBuilder(
    column: $table.sectionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SectionProductRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SectionProductRowsTable> {
  $$SectionProductRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sectionId =>
      $composableBuilder(column: $table.sectionId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get sortIndex =>
      $composableBuilder(column: $table.sortIndex, builder: (column) => column);
}

class $$SectionProductRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SectionProductRowsTable,
          SectionProductRow,
          $$SectionProductRowsTableFilterComposer,
          $$SectionProductRowsTableOrderingComposer,
          $$SectionProductRowsTableAnnotationComposer,
          $$SectionProductRowsTableCreateCompanionBuilder,
          $$SectionProductRowsTableUpdateCompanionBuilder,
          (
            SectionProductRow,
            BaseReferences<
              _$AppDatabase,
              $SectionProductRowsTable,
              SectionProductRow
            >,
          ),
          SectionProductRow,
          PrefetchHooks Function()
        > {
  $$SectionProductRowsTableTableManager(
    _$AppDatabase db,
    $SectionProductRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SectionProductRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SectionProductRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SectionProductRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> sectionId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<int> sortIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SectionProductRowsCompanion(
                sectionId: sectionId,
                productId: productId,
                sortIndex: sortIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sectionId,
                required String productId,
                required int sortIndex,
                Value<int> rowid = const Value.absent(),
              }) => SectionProductRowsCompanion.insert(
                sectionId: sectionId,
                productId: productId,
                sortIndex: sortIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SectionProductRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SectionProductRowsTable,
      SectionProductRow,
      $$SectionProductRowsTableFilterComposer,
      $$SectionProductRowsTableOrderingComposer,
      $$SectionProductRowsTableAnnotationComposer,
      $$SectionProductRowsTableCreateCompanionBuilder,
      $$SectionProductRowsTableUpdateCompanionBuilder,
      (
        SectionProductRow,
        BaseReferences<
          _$AppDatabase,
          $SectionProductRowsTable,
          SectionProductRow
        >,
      ),
      SectionProductRow,
      PrefetchHooks Function()
    >;
typedef $$ShopRowsTableCreateCompanionBuilder =
    ShopRowsCompanion Function({
      required String id,
      required String nameKey,
      required String addressKey,
      required String imageAsset,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$ShopRowsTableUpdateCompanionBuilder =
    ShopRowsCompanion Function({
      Value<String> id,
      Value<String> nameKey,
      Value<String> addressKey,
      Value<String> imageAsset,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$ShopRowsTableFilterComposer
    extends Composer<_$AppDatabase, $ShopRowsTable> {
  $$ShopRowsTableFilterComposer({
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

  ColumnFilters<String> get nameKey => $composableBuilder(
    column: $table.nameKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressKey => $composableBuilder(
    column: $table.addressKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShopRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShopRowsTable> {
  $$ShopRowsTableOrderingComposer({
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

  ColumnOrderings<String> get nameKey => $composableBuilder(
    column: $table.nameKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressKey => $composableBuilder(
    column: $table.addressKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShopRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShopRowsTable> {
  $$ShopRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameKey =>
      $composableBuilder(column: $table.nameKey, builder: (column) => column);

  GeneratedColumn<String> get addressKey => $composableBuilder(
    column: $table.addressKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$ShopRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShopRowsTable,
          ShopRow,
          $$ShopRowsTableFilterComposer,
          $$ShopRowsTableOrderingComposer,
          $$ShopRowsTableAnnotationComposer,
          $$ShopRowsTableCreateCompanionBuilder,
          $$ShopRowsTableUpdateCompanionBuilder,
          (ShopRow, BaseReferences<_$AppDatabase, $ShopRowsTable, ShopRow>),
          ShopRow,
          PrefetchHooks Function()
        > {
  $$ShopRowsTableTableManager(_$AppDatabase db, $ShopRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShopRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShopRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShopRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nameKey = const Value.absent(),
                Value<String> addressKey = const Value.absent(),
                Value<String> imageAsset = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShopRowsCompanion(
                id: id,
                nameKey: nameKey,
                addressKey: addressKey,
                imageAsset: imageAsset,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nameKey,
                required String addressKey,
                required String imageAsset,
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => ShopRowsCompanion.insert(
                id: id,
                nameKey: nameKey,
                addressKey: addressKey,
                imageAsset: imageAsset,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShopRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShopRowsTable,
      ShopRow,
      $$ShopRowsTableFilterComposer,
      $$ShopRowsTableOrderingComposer,
      $$ShopRowsTableAnnotationComposer,
      $$ShopRowsTableCreateCompanionBuilder,
      $$ShopRowsTableUpdateCompanionBuilder,
      (ShopRow, BaseReferences<_$AppDatabase, $ShopRowsTable, ShopRow>),
      ShopRow,
      PrefetchHooks Function()
    >;
typedef $$ChallengeRowsTableCreateCompanionBuilder =
    ChallengeRowsCompanion Function({
      required String id,
      required String tab,
      required String kind,
      required String titleKey,
      required int progressCurrent,
      required int progressTotal,
      required int pointsReward,
      required String imageAsset,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$ChallengeRowsTableUpdateCompanionBuilder =
    ChallengeRowsCompanion Function({
      Value<String> id,
      Value<String> tab,
      Value<String> kind,
      Value<String> titleKey,
      Value<int> progressCurrent,
      Value<int> progressTotal,
      Value<int> pointsReward,
      Value<String> imageAsset,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$ChallengeRowsTableFilterComposer
    extends Composer<_$AppDatabase, $ChallengeRowsTable> {
  $$ChallengeRowsTableFilterComposer({
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

  ColumnFilters<String> get tab => $composableBuilder(
    column: $table.tab,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleKey => $composableBuilder(
    column: $table.titleKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progressCurrent => $composableBuilder(
    column: $table.progressCurrent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progressTotal => $composableBuilder(
    column: $table.progressTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pointsReward => $composableBuilder(
    column: $table.pointsReward,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChallengeRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChallengeRowsTable> {
  $$ChallengeRowsTableOrderingComposer({
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

  ColumnOrderings<String> get tab => $composableBuilder(
    column: $table.tab,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleKey => $composableBuilder(
    column: $table.titleKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progressCurrent => $composableBuilder(
    column: $table.progressCurrent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progressTotal => $composableBuilder(
    column: $table.progressTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pointsReward => $composableBuilder(
    column: $table.pointsReward,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChallengeRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChallengeRowsTable> {
  $$ChallengeRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tab =>
      $composableBuilder(column: $table.tab, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get titleKey =>
      $composableBuilder(column: $table.titleKey, builder: (column) => column);

  GeneratedColumn<int> get progressCurrent => $composableBuilder(
    column: $table.progressCurrent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get progressTotal => $composableBuilder(
    column: $table.progressTotal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pointsReward => $composableBuilder(
    column: $table.pointsReward,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageAsset => $composableBuilder(
    column: $table.imageAsset,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$ChallengeRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChallengeRowsTable,
          ChallengeRow,
          $$ChallengeRowsTableFilterComposer,
          $$ChallengeRowsTableOrderingComposer,
          $$ChallengeRowsTableAnnotationComposer,
          $$ChallengeRowsTableCreateCompanionBuilder,
          $$ChallengeRowsTableUpdateCompanionBuilder,
          (
            ChallengeRow,
            BaseReferences<_$AppDatabase, $ChallengeRowsTable, ChallengeRow>,
          ),
          ChallengeRow,
          PrefetchHooks Function()
        > {
  $$ChallengeRowsTableTableManager(_$AppDatabase db, $ChallengeRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChallengeRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChallengeRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChallengeRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tab = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> titleKey = const Value.absent(),
                Value<int> progressCurrent = const Value.absent(),
                Value<int> progressTotal = const Value.absent(),
                Value<int> pointsReward = const Value.absent(),
                Value<String> imageAsset = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChallengeRowsCompanion(
                id: id,
                tab: tab,
                kind: kind,
                titleKey: titleKey,
                progressCurrent: progressCurrent,
                progressTotal: progressTotal,
                pointsReward: pointsReward,
                imageAsset: imageAsset,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tab,
                required String kind,
                required String titleKey,
                required int progressCurrent,
                required int progressTotal,
                required int pointsReward,
                required String imageAsset,
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => ChallengeRowsCompanion.insert(
                id: id,
                tab: tab,
                kind: kind,
                titleKey: titleKey,
                progressCurrent: progressCurrent,
                progressTotal: progressTotal,
                pointsReward: pointsReward,
                imageAsset: imageAsset,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChallengeRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChallengeRowsTable,
      ChallengeRow,
      $$ChallengeRowsTableFilterComposer,
      $$ChallengeRowsTableOrderingComposer,
      $$ChallengeRowsTableAnnotationComposer,
      $$ChallengeRowsTableCreateCompanionBuilder,
      $$ChallengeRowsTableUpdateCompanionBuilder,
      (
        ChallengeRow,
        BaseReferences<_$AppDatabase, $ChallengeRowsTable, ChallengeRow>,
      ),
      ChallengeRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MemberRowsTableTableManager get memberRows =>
      $$MemberRowsTableTableManager(_db, _db.memberRows);
  $$ProductRowsTableTableManager get productRows =>
      $$ProductRowsTableTableManager(_db, _db.productRows);
  $$BannerRowsTableTableManager get bannerRows =>
      $$BannerRowsTableTableManager(_db, _db.bannerRows);
  $$SectionRowsTableTableManager get sectionRows =>
      $$SectionRowsTableTableManager(_db, _db.sectionRows);
  $$SectionProductRowsTableTableManager get sectionProductRows =>
      $$SectionProductRowsTableTableManager(_db, _db.sectionProductRows);
  $$ShopRowsTableTableManager get shopRows =>
      $$ShopRowsTableTableManager(_db, _db.shopRows);
  $$ChallengeRowsTableTableManager get challengeRows =>
      $$ChallengeRowsTableTableManager(_db, _db.challengeRows);
}
