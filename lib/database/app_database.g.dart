// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final int? parentId;
  final DateTime dateCreated;
  Category(
      {required this.id,
      required this.name,
      this.parentId,
      required this.dateCreated});
  factory Category.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Category(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      parentId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}parent_id']),
      dateCreated: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date_created'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int?>(parentId);
    }
    map['date_created'] = Variable<DateTime>(dateCreated);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      dateCreated: Value(dateCreated),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<int?>(parentId),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
    };
  }

  Category copyWith(
          {int? id, String? name, int? parentId, DateTime? dateCreated}) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        parentId: parentId ?? this.parentId,
        dateCreated: dateCreated ?? this.dateCreated,
      );
  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, parentId, dateCreated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.dateCreated == this.dateCreated);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> parentId;
  final Value<DateTime> dateCreated;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.dateCreated = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.parentId = const Value.absent(),
    this.dateCreated = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int?>? parentId,
    Expression<DateTime>? dateCreated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (dateCreated != null) 'date_created': dateCreated,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int?>? parentId,
      Value<DateTime>? dateCreated}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int?>(parentId.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _parentIdMeta = const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<int?> parentId = GeneratedColumn<int?>(
      'parent_id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      $customConstraints: 'NULL REFERENCES categories (id) ON DELETE CASCADE');
  final VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime?> dateCreated =
      GeneratedColumn<DateTime?>('date_created', aliasedName, false,
          type: const IntType(),
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, name, parentId, dateCreated];
  @override
  String get aliasedName => _alias ?? 'categories';
  @override
  String get actualTableName => 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Category.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Unit extends DataClass implements Insertable<Unit> {
  final int id;
  final String name;
  final int amount;
  final DateTime dateCreated;
  Unit(
      {required this.id,
      required this.name,
      required this.amount,
      required this.dateCreated});
  factory Unit.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Unit(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      amount: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}amount'])!,
      dateCreated: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date_created'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<int>(amount);
    map['date_created'] = Variable<DateTime>(dateCreated);
    return map;
  }

  UnitsCompanion toCompanion(bool nullToAbsent) {
    return UnitsCompanion(
      id: Value(id),
      name: Value(name),
      amount: Value(amount),
      dateCreated: Value(dateCreated),
    );
  }

  factory Unit.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Unit(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<int>(json['amount']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<int>(amount),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
    };
  }

  Unit copyWith({int? id, String? name, int? amount, DateTime? dateCreated}) =>
      Unit(
        id: id ?? this.id,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        dateCreated: dateCreated ?? this.dateCreated,
      );
  @override
  String toString() {
    return (StringBuffer('Unit(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, amount, dateCreated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Unit &&
          other.id == this.id &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.dateCreated == this.dateCreated);
}

class UnitsCompanion extends UpdateCompanion<Unit> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> amount;
  final Value<DateTime> dateCreated;
  const UnitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.dateCreated = const Value.absent(),
  });
  UnitsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int amount,
    this.dateCreated = const Value.absent(),
  })  : name = Value(name),
        amount = Value(amount);
  static Insertable<Unit> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? amount,
    Expression<DateTime>? dateCreated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (dateCreated != null) 'date_created': dateCreated,
    });
  }

  UnitsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<int>? amount,
      Value<DateTime>? dateCreated}) {
    return UnitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }
}

class $UnitsTable extends Units with TableInfo<$UnitsTable, Unit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int?> amount = GeneratedColumn<int?>(
      'amount', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime?> dateCreated =
      GeneratedColumn<DateTime?>('date_created', aliasedName, false,
          type: const IntType(),
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, name, amount, dateCreated];
  @override
  String get aliasedName => _alias ?? 'units';
  @override
  String get actualTableName => 'units';
  @override
  VerificationContext validateIntegrity(Insertable<Unit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Unit map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Unit.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $UnitsTable createAlias(String alias) {
    return $UnitsTable(attachedDatabase, alias);
  }
}

class Person extends DataClass implements Insertable<Person> {
  final int id;
  final String name;
  final String photo;
  final String? contactNo;
  final String? remarks;
  final DateTime dateCreated;
  Person(
      {required this.id,
      required this.name,
      required this.photo,
      this.contactNo,
      this.remarks,
      required this.dateCreated});
  factory Person.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Person(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      photo: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}photo'])!,
      contactNo: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}contact_no']),
      remarks: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}remarks']),
      dateCreated: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date_created'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['photo'] = Variable<String>(photo);
    if (!nullToAbsent || contactNo != null) {
      map['contact_no'] = Variable<String?>(contactNo);
    }
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String?>(remarks);
    }
    map['date_created'] = Variable<DateTime>(dateCreated);
    return map;
  }

  PersonsCompanion toCompanion(bool nullToAbsent) {
    return PersonsCompanion(
      id: Value(id),
      name: Value(name),
      photo: Value(photo),
      contactNo: contactNo == null && nullToAbsent
          ? const Value.absent()
          : Value(contactNo),
      remarks: remarks == null && nullToAbsent
          ? const Value.absent()
          : Value(remarks),
      dateCreated: Value(dateCreated),
    );
  }

  factory Person.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Person(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      photo: serializer.fromJson<String>(json['photo']),
      contactNo: serializer.fromJson<String?>(json['contactNo']),
      remarks: serializer.fromJson<String?>(json['remarks']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'photo': serializer.toJson<String>(photo),
      'contactNo': serializer.toJson<String?>(contactNo),
      'remarks': serializer.toJson<String?>(remarks),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
    };
  }

  Person copyWith(
          {int? id,
          String? name,
          String? photo,
          String? contactNo,
          String? remarks,
          DateTime? dateCreated}) =>
      Person(
        id: id ?? this.id,
        name: name ?? this.name,
        photo: photo ?? this.photo,
        contactNo: contactNo ?? this.contactNo,
        remarks: remarks ?? this.remarks,
        dateCreated: dateCreated ?? this.dateCreated,
      );
  @override
  String toString() {
    return (StringBuffer('Person(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('photo: $photo, ')
          ..write('contactNo: $contactNo, ')
          ..write('remarks: $remarks, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, photo, contactNo, remarks, dateCreated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Person &&
          other.id == this.id &&
          other.name == this.name &&
          other.photo == this.photo &&
          other.contactNo == this.contactNo &&
          other.remarks == this.remarks &&
          other.dateCreated == this.dateCreated);
}

class PersonsCompanion extends UpdateCompanion<Person> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> photo;
  final Value<String?> contactNo;
  final Value<String?> remarks;
  final Value<DateTime> dateCreated;
  const PersonsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.photo = const Value.absent(),
    this.contactNo = const Value.absent(),
    this.remarks = const Value.absent(),
    this.dateCreated = const Value.absent(),
  });
  PersonsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String photo,
    this.contactNo = const Value.absent(),
    this.remarks = const Value.absent(),
    this.dateCreated = const Value.absent(),
  })  : name = Value(name),
        photo = Value(photo);
  static Insertable<Person> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? photo,
    Expression<String?>? contactNo,
    Expression<String?>? remarks,
    Expression<DateTime>? dateCreated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (photo != null) 'photo': photo,
      if (contactNo != null) 'contact_no': contactNo,
      if (remarks != null) 'remarks': remarks,
      if (dateCreated != null) 'date_created': dateCreated,
    });
  }

  PersonsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? photo,
      Value<String?>? contactNo,
      Value<String?>? remarks,
      Value<DateTime>? dateCreated}) {
    return PersonsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      photo: photo ?? this.photo,
      contactNo: contactNo ?? this.contactNo,
      remarks: remarks ?? this.remarks,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (photo.present) {
      map['photo'] = Variable<String>(photo.value);
    }
    if (contactNo.present) {
      map['contact_no'] = Variable<String?>(contactNo.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String?>(remarks.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('photo: $photo, ')
          ..write('contactNo: $contactNo, ')
          ..write('remarks: $remarks, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }
}

class $PersonsTable extends Persons with TableInfo<$PersonsTable, Person> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _photoMeta = const VerificationMeta('photo');
  @override
  late final GeneratedColumn<String?> photo = GeneratedColumn<String?>(
      'photo', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _contactNoMeta = const VerificationMeta('contactNo');
  @override
  late final GeneratedColumn<String?> contactNo = GeneratedColumn<String?>(
      'contact_no', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _remarksMeta = const VerificationMeta('remarks');
  @override
  late final GeneratedColumn<String?> remarks = GeneratedColumn<String?>(
      'remarks', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime?> dateCreated =
      GeneratedColumn<DateTime?>('date_created', aliasedName, false,
          type: const IntType(),
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, photo, contactNo, remarks, dateCreated];
  @override
  String get aliasedName => _alias ?? 'persons';
  @override
  String get actualTableName => 'persons';
  @override
  VerificationContext validateIntegrity(Insertable<Person> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('photo')) {
      context.handle(
          _photoMeta, photo.isAcceptableOrUnknown(data['photo']!, _photoMeta));
    } else if (isInserting) {
      context.missing(_photoMeta);
    }
    if (data.containsKey('contact_no')) {
      context.handle(_contactNoMeta,
          contactNo.isAcceptableOrUnknown(data['contact_no']!, _contactNoMeta));
    }
    if (data.containsKey('remarks')) {
      context.handle(_remarksMeta,
          remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta));
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Person map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Person.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $PersonsTable createAlias(String alias) {
    return $PersonsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final int? categoryId;
  final int? unitId;
  final String photo;
  final String name;
  final String? remarks;
  final bool isFavorite;
  final DateTime dateCreated;
  Product(
      {required this.id,
      this.categoryId,
      this.unitId,
      required this.photo,
      required this.name,
      this.remarks,
      required this.isFavorite,
      required this.dateCreated});
  factory Product.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Product(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      categoryId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}category_id']),
      unitId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}unit_id']),
      photo: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}photo'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      remarks: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}remarks']),
      isFavorite: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_favorite'])!,
      dateCreated: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date_created'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int?>(categoryId);
    }
    if (!nullToAbsent || unitId != null) {
      map['unit_id'] = Variable<int?>(unitId);
    }
    map['photo'] = Variable<String>(photo);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String?>(remarks);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['date_created'] = Variable<DateTime>(dateCreated);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      unitId:
          unitId == null && nullToAbsent ? const Value.absent() : Value(unitId),
      photo: Value(photo),
      name: Value(name),
      remarks: remarks == null && nullToAbsent
          ? const Value.absent()
          : Value(remarks),
      isFavorite: Value(isFavorite),
      dateCreated: Value(dateCreated),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      unitId: serializer.fromJson<int?>(json['unitId']),
      photo: serializer.fromJson<String>(json['photo']),
      name: serializer.fromJson<String>(json['name']),
      remarks: serializer.fromJson<String?>(json['remarks']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int?>(categoryId),
      'unitId': serializer.toJson<int?>(unitId),
      'photo': serializer.toJson<String>(photo),
      'name': serializer.toJson<String>(name),
      'remarks': serializer.toJson<String?>(remarks),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
    };
  }

  Product copyWith(
          {int? id,
          int? categoryId,
          int? unitId,
          String? photo,
          String? name,
          String? remarks,
          bool? isFavorite,
          DateTime? dateCreated}) =>
      Product(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        unitId: unitId ?? this.unitId,
        photo: photo ?? this.photo,
        name: name ?? this.name,
        remarks: remarks ?? this.remarks,
        isFavorite: isFavorite ?? this.isFavorite,
        dateCreated: dateCreated ?? this.dateCreated,
      );
  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('unitId: $unitId, ')
          ..write('photo: $photo, ')
          ..write('name: $name, ')
          ..write('remarks: $remarks, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, categoryId, unitId, photo, name, remarks, isFavorite, dateCreated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.unitId == this.unitId &&
          other.photo == this.photo &&
          other.name == this.name &&
          other.remarks == this.remarks &&
          other.isFavorite == this.isFavorite &&
          other.dateCreated == this.dateCreated);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<int?> categoryId;
  final Value<int?> unitId;
  final Value<String> photo;
  final Value<String> name;
  final Value<String?> remarks;
  final Value<bool> isFavorite;
  final Value<DateTime> dateCreated;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.unitId = const Value.absent(),
    this.photo = const Value.absent(),
    this.name = const Value.absent(),
    this.remarks = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.dateCreated = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.unitId = const Value.absent(),
    required String photo,
    required String name,
    this.remarks = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.dateCreated = const Value.absent(),
  })  : photo = Value(photo),
        name = Value(name);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<int?>? categoryId,
    Expression<int?>? unitId,
    Expression<String>? photo,
    Expression<String>? name,
    Expression<String?>? remarks,
    Expression<bool>? isFavorite,
    Expression<DateTime>? dateCreated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (unitId != null) 'unit_id': unitId,
      if (photo != null) 'photo': photo,
      if (name != null) 'name': name,
      if (remarks != null) 'remarks': remarks,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (dateCreated != null) 'date_created': dateCreated,
    });
  }

  ProductsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? categoryId,
      Value<int?>? unitId,
      Value<String>? photo,
      Value<String>? name,
      Value<String?>? remarks,
      Value<bool>? isFavorite,
      Value<DateTime>? dateCreated}) {
    return ProductsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      unitId: unitId ?? this.unitId,
      photo: photo ?? this.photo,
      name: name ?? this.name,
      remarks: remarks ?? this.remarks,
      isFavorite: isFavorite ?? this.isFavorite,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int?>(categoryId.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<int?>(unitId.value);
    }
    if (photo.present) {
      map['photo'] = Variable<String>(photo.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String?>(remarks.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('unitId: $unitId, ')
          ..write('photo: $photo, ')
          ..write('name: $name, ')
          ..write('remarks: $remarks, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int?> categoryId = GeneratedColumn<int?>(
      'category_id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      $customConstraints: 'NULL REFERENCES categories (id) ON DELETE CASCADE');
  final VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<int?> unitId = GeneratedColumn<int?>(
      'unit_id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      $customConstraints: 'NULL REFERENCES units (id) ON DELETE CASCADE');
  final VerificationMeta _photoMeta = const VerificationMeta('photo');
  @override
  late final GeneratedColumn<String?> photo = GeneratedColumn<String?>(
      'photo', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _remarksMeta = const VerificationMeta('remarks');
  @override
  late final GeneratedColumn<String?> remarks = GeneratedColumn<String?>(
      'remarks', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _isFavoriteMeta = const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool?> isFavorite = GeneratedColumn<bool?>(
      'is_favorite', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_favorite IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime?> dateCreated =
      GeneratedColumn<DateTime?>('date_created', aliasedName, false,
          type: const IntType(),
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, categoryId, unitId, photo, name, remarks, isFavorite, dateCreated];
  @override
  String get aliasedName => _alias ?? 'products';
  @override
  String get actualTableName => 'products';
  @override
  VerificationContext validateIntegrity(Insertable<Product> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('unit_id')) {
      context.handle(_unitIdMeta,
          unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta));
    }
    if (data.containsKey('photo')) {
      context.handle(
          _photoMeta, photo.isAcceptableOrUnknown(data['photo']!, _photoMeta));
    } else if (isInserting) {
      context.missing(_photoMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('remarks')) {
      context.handle(_remarksMeta,
          remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Product.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class ProductPurchase extends DataClass implements Insertable<ProductPurchase> {
  final int id;
  final int productId;
  final double cost;
  final int quantity;
  final DateTime dateCreated;
  ProductPurchase(
      {required this.id,
      required this.productId,
      required this.cost,
      required this.quantity,
      required this.dateCreated});
  factory ProductPurchase.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ProductPurchase(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      productId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}product_id'])!,
      cost: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}cost'])!,
      quantity: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}quantity'])!,
      dateCreated: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date_created'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['cost'] = Variable<double>(cost);
    map['quantity'] = Variable<int>(quantity);
    map['date_created'] = Variable<DateTime>(dateCreated);
    return map;
  }

  ProductPurchasesCompanion toCompanion(bool nullToAbsent) {
    return ProductPurchasesCompanion(
      id: Value(id),
      productId: Value(productId),
      cost: Value(cost),
      quantity: Value(quantity),
      dateCreated: Value(dateCreated),
    );
  }

  factory ProductPurchase.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductPurchase(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      cost: serializer.fromJson<double>(json['cost']),
      quantity: serializer.fromJson<int>(json['quantity']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'cost': serializer.toJson<double>(cost),
      'quantity': serializer.toJson<int>(quantity),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
    };
  }

  ProductPurchase copyWith(
          {int? id,
          int? productId,
          double? cost,
          int? quantity,
          DateTime? dateCreated}) =>
      ProductPurchase(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        cost: cost ?? this.cost,
        quantity: quantity ?? this.quantity,
        dateCreated: dateCreated ?? this.dateCreated,
      );
  @override
  String toString() {
    return (StringBuffer('ProductPurchase(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('cost: $cost, ')
          ..write('quantity: $quantity, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, cost, quantity, dateCreated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductPurchase &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.cost == this.cost &&
          other.quantity == this.quantity &&
          other.dateCreated == this.dateCreated);
}

class ProductPurchasesCompanion extends UpdateCompanion<ProductPurchase> {
  final Value<int> id;
  final Value<int> productId;
  final Value<double> cost;
  final Value<int> quantity;
  final Value<DateTime> dateCreated;
  const ProductPurchasesCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.cost = const Value.absent(),
    this.quantity = const Value.absent(),
    this.dateCreated = const Value.absent(),
  });
  ProductPurchasesCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required double cost,
    required int quantity,
    this.dateCreated = const Value.absent(),
  })  : productId = Value(productId),
        cost = Value(cost),
        quantity = Value(quantity);
  static Insertable<ProductPurchase> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<double>? cost,
    Expression<int>? quantity,
    Expression<DateTime>? dateCreated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (cost != null) 'cost': cost,
      if (quantity != null) 'quantity': quantity,
      if (dateCreated != null) 'date_created': dateCreated,
    });
  }

  ProductPurchasesCompanion copyWith(
      {Value<int>? id,
      Value<int>? productId,
      Value<double>? cost,
      Value<int>? quantity,
      Value<DateTime>? dateCreated}) {
    return ProductPurchasesCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      cost: cost ?? this.cost,
      quantity: quantity ?? this.quantity,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductPurchasesCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('cost: $cost, ')
          ..write('quantity: $quantity, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }
}

class $ProductPurchasesTable extends ProductPurchases
    with TableInfo<$ProductPurchasesTable, ProductPurchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductPurchasesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _productIdMeta = const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int?> productId = GeneratedColumn<int?>(
      'product_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL REFERENCES products (id) ON DELETE CASCADE');
  final VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double?> cost = GeneratedColumn<double?>(
      'cost', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _quantityMeta = const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int?> quantity = GeneratedColumn<int?>(
      'quantity', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime?> dateCreated =
      GeneratedColumn<DateTime?>('date_created', aliasedName, false,
          type: const IntType(),
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, productId, cost, quantity, dateCreated];
  @override
  String get aliasedName => _alias ?? 'product_purchases';
  @override
  String get actualTableName => 'product_purchases';
  @override
  VerificationContext validateIntegrity(Insertable<ProductPurchase> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
          _costMeta, cost.isAcceptableOrUnknown(data['cost']!, _costMeta));
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductPurchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ProductPurchase.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ProductPurchasesTable createAlias(String alias) {
    return $ProductPurchasesTable(attachedDatabase, alias);
  }
}

class ProductPrice extends DataClass implements Insertable<ProductPrice> {
  final int id;
  final int productId;
  final double retail;
  final bool isActive;
  final DateTime dateCreated;
  ProductPrice(
      {required this.id,
      required this.productId,
      required this.retail,
      required this.isActive,
      required this.dateCreated});
  factory ProductPrice.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ProductPrice(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      productId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}product_id'])!,
      retail: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}retail'])!,
      isActive: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_active'])!,
      dateCreated: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date_created'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['retail'] = Variable<double>(retail);
    map['is_active'] = Variable<bool>(isActive);
    map['date_created'] = Variable<DateTime>(dateCreated);
    return map;
  }

  ProductPricesCompanion toCompanion(bool nullToAbsent) {
    return ProductPricesCompanion(
      id: Value(id),
      productId: Value(productId),
      retail: Value(retail),
      isActive: Value(isActive),
      dateCreated: Value(dateCreated),
    );
  }

  factory ProductPrice.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductPrice(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      retail: serializer.fromJson<double>(json['retail']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'retail': serializer.toJson<double>(retail),
      'isActive': serializer.toJson<bool>(isActive),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
    };
  }

  ProductPrice copyWith(
          {int? id,
          int? productId,
          double? retail,
          bool? isActive,
          DateTime? dateCreated}) =>
      ProductPrice(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        retail: retail ?? this.retail,
        isActive: isActive ?? this.isActive,
        dateCreated: dateCreated ?? this.dateCreated,
      );
  @override
  String toString() {
    return (StringBuffer('ProductPrice(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('retail: $retail, ')
          ..write('isActive: $isActive, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, retail, isActive, dateCreated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductPrice &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.retail == this.retail &&
          other.isActive == this.isActive &&
          other.dateCreated == this.dateCreated);
}

class ProductPricesCompanion extends UpdateCompanion<ProductPrice> {
  final Value<int> id;
  final Value<int> productId;
  final Value<double> retail;
  final Value<bool> isActive;
  final Value<DateTime> dateCreated;
  const ProductPricesCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.retail = const Value.absent(),
    this.isActive = const Value.absent(),
    this.dateCreated = const Value.absent(),
  });
  ProductPricesCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required double retail,
    this.isActive = const Value.absent(),
    this.dateCreated = const Value.absent(),
  })  : productId = Value(productId),
        retail = Value(retail);
  static Insertable<ProductPrice> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<double>? retail,
    Expression<bool>? isActive,
    Expression<DateTime>? dateCreated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (retail != null) 'retail': retail,
      if (isActive != null) 'is_active': isActive,
      if (dateCreated != null) 'date_created': dateCreated,
    });
  }

  ProductPricesCompanion copyWith(
      {Value<int>? id,
      Value<int>? productId,
      Value<double>? retail,
      Value<bool>? isActive,
      Value<DateTime>? dateCreated}) {
    return ProductPricesCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      retail: retail ?? this.retail,
      isActive: isActive ?? this.isActive,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (retail.present) {
      map['retail'] = Variable<double>(retail.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductPricesCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('retail: $retail, ')
          ..write('isActive: $isActive, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }
}

class $ProductPricesTable extends ProductPrices
    with TableInfo<$ProductPricesTable, ProductPrice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductPricesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _productIdMeta = const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int?> productId = GeneratedColumn<int?>(
      'product_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL REFERENCES products (id) ON DELETE CASCADE');
  final VerificationMeta _retailMeta = const VerificationMeta('retail');
  @override
  late final GeneratedColumn<double?> retail = GeneratedColumn<double?>(
      'retail', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _isActiveMeta = const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool?> isActive = GeneratedColumn<bool?>(
      'is_active', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (is_active IN (0, 1))',
      defaultValue: const Constant(true));
  final VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime?> dateCreated =
      GeneratedColumn<DateTime?>('date_created', aliasedName, false,
          type: const IntType(),
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, productId, retail, isActive, dateCreated];
  @override
  String get aliasedName => _alias ?? 'product_prices';
  @override
  String get actualTableName => 'product_prices';
  @override
  VerificationContext validateIntegrity(Insertable<ProductPrice> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('retail')) {
      context.handle(_retailMeta,
          retail.isAcceptableOrUnknown(data['retail']!, _retailMeta));
    } else if (isInserting) {
      context.missing(_retailMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductPrice map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ProductPrice.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ProductPricesTable createAlias(String alias) {
    return $ProductPricesTable(attachedDatabase, alias);
  }
}

class Arrear extends DataClass implements Insertable<Arrear> {
  final int id;
  final int personId;
  final Status status;
  final double amount;
  final DateTime? due;
  final String? remarks;
  final DateTime dateCreated;
  Arrear(
      {required this.id,
      required this.personId,
      required this.status,
      required this.amount,
      this.due,
      this.remarks,
      required this.dateCreated});
  factory Arrear.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Arrear(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      personId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}person_id'])!,
      status: $ArrearsTable.$converter0.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}status']))!,
      amount: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}amount'])!,
      due: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}due']),
      remarks: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}remarks']),
      dateCreated: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date_created'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['person_id'] = Variable<int>(personId);
    {
      final converter = $ArrearsTable.$converter0;
      map['status'] = Variable<int>(converter.mapToSql(status)!);
    }
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || due != null) {
      map['due'] = Variable<DateTime?>(due);
    }
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String?>(remarks);
    }
    map['date_created'] = Variable<DateTime>(dateCreated);
    return map;
  }

  ArrearsCompanion toCompanion(bool nullToAbsent) {
    return ArrearsCompanion(
      id: Value(id),
      personId: Value(personId),
      status: Value(status),
      amount: Value(amount),
      due: due == null && nullToAbsent ? const Value.absent() : Value(due),
      remarks: remarks == null && nullToAbsent
          ? const Value.absent()
          : Value(remarks),
      dateCreated: Value(dateCreated),
    );
  }

  factory Arrear.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Arrear(
      id: serializer.fromJson<int>(json['id']),
      personId: serializer.fromJson<int>(json['personId']),
      status: serializer.fromJson<Status>(json['status']),
      amount: serializer.fromJson<double>(json['amount']),
      due: serializer.fromJson<DateTime?>(json['due']),
      remarks: serializer.fromJson<String?>(json['remarks']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personId': serializer.toJson<int>(personId),
      'status': serializer.toJson<Status>(status),
      'amount': serializer.toJson<double>(amount),
      'due': serializer.toJson<DateTime?>(due),
      'remarks': serializer.toJson<String?>(remarks),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
    };
  }

  Arrear copyWith(
          {int? id,
          int? personId,
          Status? status,
          double? amount,
          DateTime? due,
          String? remarks,
          DateTime? dateCreated}) =>
      Arrear(
        id: id ?? this.id,
        personId: personId ?? this.personId,
        status: status ?? this.status,
        amount: amount ?? this.amount,
        due: due ?? this.due,
        remarks: remarks ?? this.remarks,
        dateCreated: dateCreated ?? this.dateCreated,
      );
  @override
  String toString() {
    return (StringBuffer('Arrear(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('status: $status, ')
          ..write('amount: $amount, ')
          ..write('due: $due, ')
          ..write('remarks: $remarks, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, personId, status, amount, due, remarks, dateCreated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Arrear &&
          other.id == this.id &&
          other.personId == this.personId &&
          other.status == this.status &&
          other.amount == this.amount &&
          other.due == this.due &&
          other.remarks == this.remarks &&
          other.dateCreated == this.dateCreated);
}

class ArrearsCompanion extends UpdateCompanion<Arrear> {
  final Value<int> id;
  final Value<int> personId;
  final Value<Status> status;
  final Value<double> amount;
  final Value<DateTime?> due;
  final Value<String?> remarks;
  final Value<DateTime> dateCreated;
  const ArrearsCompanion({
    this.id = const Value.absent(),
    this.personId = const Value.absent(),
    this.status = const Value.absent(),
    this.amount = const Value.absent(),
    this.due = const Value.absent(),
    this.remarks = const Value.absent(),
    this.dateCreated = const Value.absent(),
  });
  ArrearsCompanion.insert({
    this.id = const Value.absent(),
    required int personId,
    required Status status,
    required double amount,
    this.due = const Value.absent(),
    this.remarks = const Value.absent(),
    this.dateCreated = const Value.absent(),
  })  : personId = Value(personId),
        status = Value(status),
        amount = Value(amount);
  static Insertable<Arrear> custom({
    Expression<int>? id,
    Expression<int>? personId,
    Expression<Status>? status,
    Expression<double>? amount,
    Expression<DateTime?>? due,
    Expression<String?>? remarks,
    Expression<DateTime>? dateCreated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personId != null) 'person_id': personId,
      if (status != null) 'status': status,
      if (amount != null) 'amount': amount,
      if (due != null) 'due': due,
      if (remarks != null) 'remarks': remarks,
      if (dateCreated != null) 'date_created': dateCreated,
    });
  }

  ArrearsCompanion copyWith(
      {Value<int>? id,
      Value<int>? personId,
      Value<Status>? status,
      Value<double>? amount,
      Value<DateTime?>? due,
      Value<String?>? remarks,
      Value<DateTime>? dateCreated}) {
    return ArrearsCompanion(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      due: due ?? this.due,
      remarks: remarks ?? this.remarks,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<int>(personId.value);
    }
    if (status.present) {
      final converter = $ArrearsTable.$converter0;
      map['status'] = Variable<int>(converter.mapToSql(status.value)!);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (due.present) {
      map['due'] = Variable<DateTime?>(due.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String?>(remarks.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArrearsCompanion(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('status: $status, ')
          ..write('amount: $amount, ')
          ..write('due: $due, ')
          ..write('remarks: $remarks, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }
}

class $ArrearsTable extends Arrears with TableInfo<$ArrearsTable, Arrear> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArrearsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _personIdMeta = const VerificationMeta('personId');
  @override
  late final GeneratedColumn<int?> personId = GeneratedColumn<int?>(
      'person_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES persons (id) ON DELETE CASCADE');
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<Status, int?> status =
      GeneratedColumn<int?>('status', aliasedName, false,
              type: const IntType(), requiredDuringInsert: true)
          .withConverter<Status>($ArrearsTable.$converter0);
  final VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double?> amount = GeneratedColumn<double?>(
      'amount', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _dueMeta = const VerificationMeta('due');
  @override
  late final GeneratedColumn<DateTime?> due = GeneratedColumn<DateTime?>(
      'due', aliasedName, true,
      type: const IntType(), requiredDuringInsert: false);
  final VerificationMeta _remarksMeta = const VerificationMeta('remarks');
  @override
  late final GeneratedColumn<String?> remarks = GeneratedColumn<String?>(
      'remarks', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime?> dateCreated =
      GeneratedColumn<DateTime?>('date_created', aliasedName, false,
          type: const IntType(),
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, personId, status, amount, due, remarks, dateCreated];
  @override
  String get aliasedName => _alias ?? 'arrears';
  @override
  String get actualTableName => 'arrears';
  @override
  VerificationContext validateIntegrity(Insertable<Arrear> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('due')) {
      context.handle(
          _dueMeta, due.isAcceptableOrUnknown(data['due']!, _dueMeta));
    }
    if (data.containsKey('remarks')) {
      context.handle(_remarksMeta,
          remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta));
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Arrear map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Arrear.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ArrearsTable createAlias(String alias) {
    return $ArrearsTable(attachedDatabase, alias);
  }

  static TypeConverter<Status, int> $converter0 =
      const EnumIndexConverter<Status>(Status.values);
}

class ArrearPurchase extends DataClass implements Insertable<ArrearPurchase> {
  final int id;
  final int arrearId;
  final int productId;
  final int productPriceId;
  final int quantity;
  final DateTime dateCreated;
  ArrearPurchase(
      {required this.id,
      required this.arrearId,
      required this.productId,
      required this.productPriceId,
      required this.quantity,
      required this.dateCreated});
  factory ArrearPurchase.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ArrearPurchase(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      arrearId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}arrear_id'])!,
      productId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}product_id'])!,
      productPriceId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}product_price_id'])!,
      quantity: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}quantity'])!,
      dateCreated: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date_created'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['arrear_id'] = Variable<int>(arrearId);
    map['product_id'] = Variable<int>(productId);
    map['product_price_id'] = Variable<int>(productPriceId);
    map['quantity'] = Variable<int>(quantity);
    map['date_created'] = Variable<DateTime>(dateCreated);
    return map;
  }

  ArrearPurchasesCompanion toCompanion(bool nullToAbsent) {
    return ArrearPurchasesCompanion(
      id: Value(id),
      arrearId: Value(arrearId),
      productId: Value(productId),
      productPriceId: Value(productPriceId),
      quantity: Value(quantity),
      dateCreated: Value(dateCreated),
    );
  }

  factory ArrearPurchase.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArrearPurchase(
      id: serializer.fromJson<int>(json['id']),
      arrearId: serializer.fromJson<int>(json['arrearId']),
      productId: serializer.fromJson<int>(json['productId']),
      productPriceId: serializer.fromJson<int>(json['productPriceId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'arrearId': serializer.toJson<int>(arrearId),
      'productId': serializer.toJson<int>(productId),
      'productPriceId': serializer.toJson<int>(productPriceId),
      'quantity': serializer.toJson<int>(quantity),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
    };
  }

  ArrearPurchase copyWith(
          {int? id,
          int? arrearId,
          int? productId,
          int? productPriceId,
          int? quantity,
          DateTime? dateCreated}) =>
      ArrearPurchase(
        id: id ?? this.id,
        arrearId: arrearId ?? this.arrearId,
        productId: productId ?? this.productId,
        productPriceId: productPriceId ?? this.productPriceId,
        quantity: quantity ?? this.quantity,
        dateCreated: dateCreated ?? this.dateCreated,
      );
  @override
  String toString() {
    return (StringBuffer('ArrearPurchase(')
          ..write('id: $id, ')
          ..write('arrearId: $arrearId, ')
          ..write('productId: $productId, ')
          ..write('productPriceId: $productPriceId, ')
          ..write('quantity: $quantity, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, arrearId, productId, productPriceId, quantity, dateCreated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArrearPurchase &&
          other.id == this.id &&
          other.arrearId == this.arrearId &&
          other.productId == this.productId &&
          other.productPriceId == this.productPriceId &&
          other.quantity == this.quantity &&
          other.dateCreated == this.dateCreated);
}

class ArrearPurchasesCompanion extends UpdateCompanion<ArrearPurchase> {
  final Value<int> id;
  final Value<int> arrearId;
  final Value<int> productId;
  final Value<int> productPriceId;
  final Value<int> quantity;
  final Value<DateTime> dateCreated;
  const ArrearPurchasesCompanion({
    this.id = const Value.absent(),
    this.arrearId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productPriceId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.dateCreated = const Value.absent(),
  });
  ArrearPurchasesCompanion.insert({
    this.id = const Value.absent(),
    required int arrearId,
    required int productId,
    required int productPriceId,
    required int quantity,
    this.dateCreated = const Value.absent(),
  })  : arrearId = Value(arrearId),
        productId = Value(productId),
        productPriceId = Value(productPriceId),
        quantity = Value(quantity);
  static Insertable<ArrearPurchase> custom({
    Expression<int>? id,
    Expression<int>? arrearId,
    Expression<int>? productId,
    Expression<int>? productPriceId,
    Expression<int>? quantity,
    Expression<DateTime>? dateCreated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (arrearId != null) 'arrear_id': arrearId,
      if (productId != null) 'product_id': productId,
      if (productPriceId != null) 'product_price_id': productPriceId,
      if (quantity != null) 'quantity': quantity,
      if (dateCreated != null) 'date_created': dateCreated,
    });
  }

  ArrearPurchasesCompanion copyWith(
      {Value<int>? id,
      Value<int>? arrearId,
      Value<int>? productId,
      Value<int>? productPriceId,
      Value<int>? quantity,
      Value<DateTime>? dateCreated}) {
    return ArrearPurchasesCompanion(
      id: id ?? this.id,
      arrearId: arrearId ?? this.arrearId,
      productId: productId ?? this.productId,
      productPriceId: productPriceId ?? this.productPriceId,
      quantity: quantity ?? this.quantity,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (arrearId.present) {
      map['arrear_id'] = Variable<int>(arrearId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (productPriceId.present) {
      map['product_price_id'] = Variable<int>(productPriceId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArrearPurchasesCompanion(')
          ..write('id: $id, ')
          ..write('arrearId: $arrearId, ')
          ..write('productId: $productId, ')
          ..write('productPriceId: $productPriceId, ')
          ..write('quantity: $quantity, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }
}

class $ArrearPurchasesTable extends ArrearPurchases
    with TableInfo<$ArrearPurchasesTable, ArrearPurchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArrearPurchasesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _arrearIdMeta = const VerificationMeta('arrearId');
  @override
  late final GeneratedColumn<int?> arrearId = GeneratedColumn<int?>(
      'arrear_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES arrears (id) ON DELETE CASCADE');
  final VerificationMeta _productIdMeta = const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int?> productId = GeneratedColumn<int?>(
      'product_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL REFERENCES products (id) ON DELETE CASCADE');
  final VerificationMeta _productPriceIdMeta =
      const VerificationMeta('productPriceId');
  @override
  late final GeneratedColumn<int?> productPriceId = GeneratedColumn<int?>(
      'product_price_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints:
          'NOT NULL REFERENCES product_prices (id) ON DELETE CASCADE');
  final VerificationMeta _quantityMeta = const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int?> quantity = GeneratedColumn<int?>(
      'quantity', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime?> dateCreated =
      GeneratedColumn<DateTime?>('date_created', aliasedName, false,
          type: const IntType(),
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, arrearId, productId, productPriceId, quantity, dateCreated];
  @override
  String get aliasedName => _alias ?? 'arrear_purchases';
  @override
  String get actualTableName => 'arrear_purchases';
  @override
  VerificationContext validateIntegrity(Insertable<ArrearPurchase> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('arrear_id')) {
      context.handle(_arrearIdMeta,
          arrearId.isAcceptableOrUnknown(data['arrear_id']!, _arrearIdMeta));
    } else if (isInserting) {
      context.missing(_arrearIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_price_id')) {
      context.handle(
          _productPriceIdMeta,
          productPriceId.isAcceptableOrUnknown(
              data['product_price_id']!, _productPriceIdMeta));
    } else if (isInserting) {
      context.missing(_productPriceIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ArrearPurchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ArrearPurchase.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ArrearPurchasesTable createAlias(String alias) {
    return $ArrearPurchasesTable(attachedDatabase, alias);
  }
}

class ArrearPayment extends DataClass implements Insertable<ArrearPayment> {
  final int id;
  final int arrearId;
  final double amount;
  final String? remarks;
  final DateTime dateCreated;
  ArrearPayment(
      {required this.id,
      required this.arrearId,
      required this.amount,
      this.remarks,
      required this.dateCreated});
  factory ArrearPayment.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ArrearPayment(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      arrearId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}arrear_id'])!,
      amount: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}amount'])!,
      remarks: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}remarks']),
      dateCreated: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date_created'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['arrear_id'] = Variable<int>(arrearId);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String?>(remarks);
    }
    map['date_created'] = Variable<DateTime>(dateCreated);
    return map;
  }

  ArrearPaymentsCompanion toCompanion(bool nullToAbsent) {
    return ArrearPaymentsCompanion(
      id: Value(id),
      arrearId: Value(arrearId),
      amount: Value(amount),
      remarks: remarks == null && nullToAbsent
          ? const Value.absent()
          : Value(remarks),
      dateCreated: Value(dateCreated),
    );
  }

  factory ArrearPayment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArrearPayment(
      id: serializer.fromJson<int>(json['id']),
      arrearId: serializer.fromJson<int>(json['arrearId']),
      amount: serializer.fromJson<double>(json['amount']),
      remarks: serializer.fromJson<String?>(json['remarks']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'arrearId': serializer.toJson<int>(arrearId),
      'amount': serializer.toJson<double>(amount),
      'remarks': serializer.toJson<String?>(remarks),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
    };
  }

  ArrearPayment copyWith(
          {int? id,
          int? arrearId,
          double? amount,
          String? remarks,
          DateTime? dateCreated}) =>
      ArrearPayment(
        id: id ?? this.id,
        arrearId: arrearId ?? this.arrearId,
        amount: amount ?? this.amount,
        remarks: remarks ?? this.remarks,
        dateCreated: dateCreated ?? this.dateCreated,
      );
  @override
  String toString() {
    return (StringBuffer('ArrearPayment(')
          ..write('id: $id, ')
          ..write('arrearId: $arrearId, ')
          ..write('amount: $amount, ')
          ..write('remarks: $remarks, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, arrearId, amount, remarks, dateCreated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArrearPayment &&
          other.id == this.id &&
          other.arrearId == this.arrearId &&
          other.amount == this.amount &&
          other.remarks == this.remarks &&
          other.dateCreated == this.dateCreated);
}

class ArrearPaymentsCompanion extends UpdateCompanion<ArrearPayment> {
  final Value<int> id;
  final Value<int> arrearId;
  final Value<double> amount;
  final Value<String?> remarks;
  final Value<DateTime> dateCreated;
  const ArrearPaymentsCompanion({
    this.id = const Value.absent(),
    this.arrearId = const Value.absent(),
    this.amount = const Value.absent(),
    this.remarks = const Value.absent(),
    this.dateCreated = const Value.absent(),
  });
  ArrearPaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int arrearId,
    required double amount,
    this.remarks = const Value.absent(),
    this.dateCreated = const Value.absent(),
  })  : arrearId = Value(arrearId),
        amount = Value(amount);
  static Insertable<ArrearPayment> custom({
    Expression<int>? id,
    Expression<int>? arrearId,
    Expression<double>? amount,
    Expression<String?>? remarks,
    Expression<DateTime>? dateCreated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (arrearId != null) 'arrear_id': arrearId,
      if (amount != null) 'amount': amount,
      if (remarks != null) 'remarks': remarks,
      if (dateCreated != null) 'date_created': dateCreated,
    });
  }

  ArrearPaymentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? arrearId,
      Value<double>? amount,
      Value<String?>? remarks,
      Value<DateTime>? dateCreated}) {
    return ArrearPaymentsCompanion(
      id: id ?? this.id,
      arrearId: arrearId ?? this.arrearId,
      amount: amount ?? this.amount,
      remarks: remarks ?? this.remarks,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (arrearId.present) {
      map['arrear_id'] = Variable<int>(arrearId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String?>(remarks.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArrearPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('arrearId: $arrearId, ')
          ..write('amount: $amount, ')
          ..write('remarks: $remarks, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }
}

class $ArrearPaymentsTable extends ArrearPayments
    with TableInfo<$ArrearPaymentsTable, ArrearPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArrearPaymentsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _arrearIdMeta = const VerificationMeta('arrearId');
  @override
  late final GeneratedColumn<int?> arrearId = GeneratedColumn<int?>(
      'arrear_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints: 'NOT NULL REFERENCES arrears (id) ON DELETE CASCADE');
  final VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double?> amount = GeneratedColumn<double?>(
      'amount', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _remarksMeta = const VerificationMeta('remarks');
  @override
  late final GeneratedColumn<String?> remarks = GeneratedColumn<String?>(
      'remarks', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime?> dateCreated =
      GeneratedColumn<DateTime?>('date_created', aliasedName, false,
          type: const IntType(),
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, arrearId, amount, remarks, dateCreated];
  @override
  String get aliasedName => _alias ?? 'arrear_payments';
  @override
  String get actualTableName => 'arrear_payments';
  @override
  VerificationContext validateIntegrity(Insertable<ArrearPayment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('arrear_id')) {
      context.handle(_arrearIdMeta,
          arrearId.isAcceptableOrUnknown(data['arrear_id']!, _arrearIdMeta));
    } else if (isInserting) {
      context.missing(_arrearIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('remarks')) {
      context.handle(_remarksMeta,
          remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta));
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ArrearPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ArrearPayment.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ArrearPaymentsTable createAlias(String alias) {
    return $ArrearPaymentsTable(attachedDatabase, alias);
  }
}

class Earning extends DataClass implements Insertable<Earning> {
  final int id;
  final double amount;
  final String? remarks;
  final DateTime dateCreated;
  Earning(
      {required this.id,
      required this.amount,
      this.remarks,
      required this.dateCreated});
  factory Earning.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Earning(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      amount: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}amount'])!,
      remarks: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}remarks']),
      dateCreated: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date_created'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || remarks != null) {
      map['remarks'] = Variable<String?>(remarks);
    }
    map['date_created'] = Variable<DateTime>(dateCreated);
    return map;
  }

  EarningsCompanion toCompanion(bool nullToAbsent) {
    return EarningsCompanion(
      id: Value(id),
      amount: Value(amount),
      remarks: remarks == null && nullToAbsent
          ? const Value.absent()
          : Value(remarks),
      dateCreated: Value(dateCreated),
    );
  }

  factory Earning.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Earning(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      remarks: serializer.fromJson<String?>(json['remarks']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<double>(amount),
      'remarks': serializer.toJson<String?>(remarks),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
    };
  }

  Earning copyWith(
          {int? id, double? amount, String? remarks, DateTime? dateCreated}) =>
      Earning(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        remarks: remarks ?? this.remarks,
        dateCreated: dateCreated ?? this.dateCreated,
      );
  @override
  String toString() {
    return (StringBuffer('Earning(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('remarks: $remarks, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, amount, remarks, dateCreated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Earning &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.remarks == this.remarks &&
          other.dateCreated == this.dateCreated);
}

class EarningsCompanion extends UpdateCompanion<Earning> {
  final Value<int> id;
  final Value<double> amount;
  final Value<String?> remarks;
  final Value<DateTime> dateCreated;
  const EarningsCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.remarks = const Value.absent(),
    this.dateCreated = const Value.absent(),
  });
  EarningsCompanion.insert({
    this.id = const Value.absent(),
    required double amount,
    this.remarks = const Value.absent(),
    this.dateCreated = const Value.absent(),
  }) : amount = Value(amount);
  static Insertable<Earning> custom({
    Expression<int>? id,
    Expression<double>? amount,
    Expression<String?>? remarks,
    Expression<DateTime>? dateCreated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (remarks != null) 'remarks': remarks,
      if (dateCreated != null) 'date_created': dateCreated,
    });
  }

  EarningsCompanion copyWith(
      {Value<int>? id,
      Value<double>? amount,
      Value<String?>? remarks,
      Value<DateTime>? dateCreated}) {
    return EarningsCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      remarks: remarks ?? this.remarks,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String?>(remarks.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EarningsCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('remarks: $remarks, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }
}

class $EarningsTable extends Earnings with TableInfo<$EarningsTable, Earning> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EarningsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double?> amount = GeneratedColumn<double?>(
      'amount', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _remarksMeta = const VerificationMeta('remarks');
  @override
  late final GeneratedColumn<String?> remarks = GeneratedColumn<String?>(
      'remarks', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime?> dateCreated =
      GeneratedColumn<DateTime?>('date_created', aliasedName, false,
          type: const IntType(),
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, amount, remarks, dateCreated];
  @override
  String get aliasedName => _alias ?? 'earnings';
  @override
  String get actualTableName => 'earnings';
  @override
  VerificationContext validateIntegrity(Insertable<Earning> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('remarks')) {
      context.handle(_remarksMeta,
          remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta));
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Earning map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Earning.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $EarningsTable createAlias(String alias) {
    return $EarningsTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $UnitsTable units = $UnitsTable(this);
  late final $PersonsTable persons = $PersonsTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $ProductPurchasesTable productPurchases =
      $ProductPurchasesTable(this);
  late final $ProductPricesTable productPrices = $ProductPricesTable(this);
  late final $ArrearsTable arrears = $ArrearsTable(this);
  late final $ArrearPurchasesTable arrearPurchases =
      $ArrearPurchasesTable(this);
  late final $ArrearPaymentsTable arrearPayments = $ArrearPaymentsTable(this);
  late final $EarningsTable earnings = $EarningsTable(this);
  late final CategoriesDao categoriesDao = CategoriesDao(this as AppDatabase);
  late final UnitsDao unitsDao = UnitsDao(this as AppDatabase);
  late final PersonsDao personsDao = PersonsDao(this as AppDatabase);
  late final ProductsDao productsDao = ProductsDao(this as AppDatabase);
  late final ProductPurchasesDao productPurchasesDao =
      ProductPurchasesDao(this as AppDatabase);
  late final ProductPricesDao productPricesDao =
      ProductPricesDao(this as AppDatabase);
  late final ArrearsDao arrearsDao = ArrearsDao(this as AppDatabase);
  late final ArrearPurchasesDao arrearPurchasesDao =
      ArrearPurchasesDao(this as AppDatabase);
  late final ArrearPaymentsDao arrearPaymentsDao =
      ArrearPaymentsDao(this as AppDatabase);
  late final EarningsDao earningsDao = EarningsDao(this as AppDatabase);
  late final DashboardDao dashboardDao = DashboardDao(this as AppDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        categories,
        units,
        persons,
        products,
        productPurchases,
        productPrices,
        arrears,
        arrearPurchases,
        arrearPayments,
        earnings
      ];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$CategoriesDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
}
mixin _$UnitsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UnitsTable get units => attachedDatabase.units;
}
mixin _$PersonsDaoMixin on DatabaseAccessor<AppDatabase> {
  $PersonsTable get persons => attachedDatabase.persons;
}
mixin _$ProductsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProductsTable get products => attachedDatabase.products;
}
mixin _$ProductPurchasesDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProductPurchasesTable get productPurchases =>
      attachedDatabase.productPurchases;
}
mixin _$ProductPricesDaoMixin on DatabaseAccessor<AppDatabase> {
  $ProductPricesTable get productPrices => attachedDatabase.productPrices;
}
mixin _$ArrearsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ArrearsTable get arrears => attachedDatabase.arrears;
}
mixin _$ArrearPurchasesDaoMixin on DatabaseAccessor<AppDatabase> {
  $ArrearPurchasesTable get arrearPurchases => attachedDatabase.arrearPurchases;
}
mixin _$ArrearPaymentsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ArrearPaymentsTable get arrearPayments => attachedDatabase.arrearPayments;
}
mixin _$EarningsDaoMixin on DatabaseAccessor<AppDatabase> {
  $EarningsTable get earnings => attachedDatabase.earnings;
}
mixin _$DashboardDaoMixin on DatabaseAccessor<AppDatabase> {
  $EarningsTable get earnings => attachedDatabase.earnings;
  $ProductsTable get products => attachedDatabase.products;
  $ArrearsTable get arrears => attachedDatabase.arrears;
}
