import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_config/flutter_config.dart';

part 'app_database.g.dart';

// Helper functions

DateTime? getDateTime(int? timestamp) {
  if (timestamp == null) return null;
  return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
}

bool _debugCheckHasCipher(Database database) {
  return database.select('PRAGMA cipher_version;').isNotEmpty;
}

// Base Tables Definition

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get parentId => integer()
      .nullable()
      // .references(Categories, #id, onDelete: KeyAction.cascade)();
      .customConstraint('NULL REFERENCES categories (id) ON DELETE CASCADE')();
  DateTimeColumn get dateCreated =>
      dateTime().withDefault(currentDateAndTime)();
}

@DataClassName("Unit")
class Units extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get amount => integer()();
  DateTimeColumn get dateCreated =>
      dateTime().withDefault(currentDateAndTime)();
}

@DataClassName("Person")
class Persons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get photo => text()();
  TextColumn get contactNo => text().nullable()();
  TextColumn get remarks => text().nullable()();
  DateTimeColumn get dateCreated =>
      dateTime().withDefault(currentDateAndTime)();
}

// Transaction Tables Definition

@DataClassName("Product")
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer()
      .nullable()
      // .references(Categories, #id, onDelete: KeyAction.cascade)();
      .customConstraint('NULL REFERENCES categories (id) ON DELETE CASCADE')();
  IntColumn get unitId => integer()
      .nullable()
      // .references(Units, #id, onDelete: KeyAction.cascade)();
      .customConstraint('NULL REFERENCES units (id) ON DELETE CASCADE')();
  TextColumn get photo => text()();
  TextColumn get name => text()();
  TextColumn get remarks => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get dateCreated =>
      dateTime().withDefault(currentDateAndTime)();
}

@DataClassName("ProductPurchase")
class ProductPurchases extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer()
      // .references(Products, #id, onDelete: KeyAction.cascade)();
      .customConstraint(
          'NOT NULL REFERENCES products (id) ON DELETE CASCADE')();
  RealColumn get cost => real()();
  IntColumn get quantity => integer()();
  DateTimeColumn get dateCreated =>
      dateTime().withDefault(currentDateAndTime)();
}

@DataClassName("ProductPrice")
class ProductPrices extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer()
      // .references(Products, #id, onDelete: KeyAction.cascade)();
      .customConstraint(
          'NOT NULL REFERENCES products (id) ON DELETE CASCADE')();
  RealColumn get retail => real()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get dateCreated =>
      dateTime().withDefault(currentDateAndTime)();
}

enum Status { unpaid, paid }

@DataClassName("Arrear")
class Arrears extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get personId => integer()
      // .references(Persons, #id, onDelete: KeyAction.cascade)();
      .customConstraint('NOT NULL REFERENCES persons (id) ON DELETE CASCADE')();
  IntColumn get status => intEnum<Status>()();
  RealColumn get amount => real()();
  DateTimeColumn get due => dateTime().nullable()();
  IntColumn get notificationId => integer().nullable()();
  TextColumn get remarks => text().nullable()();
  DateTimeColumn get dateCreated =>
      dateTime().withDefault(currentDateAndTime)();
}

@DataClassName("ArrearPurchase")
class ArrearPurchases extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get arrearId => integer()
      // .references(Arrears, #id, onDelete: KeyAction.cascade)();
      .customConstraint('NOT NULL REFERENCES arrears (id) ON DELETE CASCADE')();
  IntColumn get productId => integer()
      // .references(Products, #id, onDelete: KeyAction.cascade)();
      .customConstraint(
          'NOT NULL REFERENCES products (id) ON DELETE CASCADE')();
  IntColumn get productPriceId => integer()
      // .references(ProductPrices, #id, onDelete: KeyAction.cascade)();
      .customConstraint(
          'NOT NULL REFERENCES product_prices (id) ON DELETE CASCADE')();
  IntColumn get quantity => integer()();
  DateTimeColumn get dateCreated =>
      dateTime().withDefault(currentDateAndTime)();
}

@DataClassName("ArrearPayment")
class ArrearPayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get arrearId => integer()
      // .references(Arrears, #id, onDelete: KeyAction.cascade)();
      .customConstraint('NOT NULL REFERENCES arrears (id) ON DELETE CASCADE')();
  RealColumn get amount => real()();
  TextColumn get remarks => text().nullable()();
  DateTimeColumn get dateCreated =>
      dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('Earning')
class Earnings extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  TextColumn get remarks => text().nullable()();
  DateTimeColumn get dateCreated =>
      dateTime().withDefault(currentDateAndTime)();
}

LazyDatabase _openConnection(Future<File> filename) {
  return LazyDatabase(() async {
    final _cipherKey = FlutterConfig.get('CIPHER_KEY');

    return NativeDatabase(
      await filename,
      logStatements: kDebugMode,
      setup: (rawDb) {
        assert(_debugCheckHasCipher(rawDb));
        rawDb.execute("PRAGMA key = '${_cipherKey}';");
      },
    );
  });
}

@DriftDatabase(
  tables: [
    Categories,
    Units,
    Persons,
    Products,
    ProductPurchases,
    ProductPrices,
    Arrears,
    ArrearPurchases,
    ArrearPayments,
    Earnings,
  ],
  daos: [
    CategoriesDao,
    UnitsDao,
    PersonsDao,
    ProductsDao,
    ProductPurchasesDao,
    ProductPricesDao,
    ArrearsDao,
    ArrearPurchasesDao,
    ArrearPaymentsDao,
    EarningsDao,
    DashboardDao
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection(getDbFile()));

  @override
  int get schemaVersion => 1;

  static Future<File> getDbFile() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final parentPath = dbFolder.parent.path.toString();
    return File(p.join(parentPath, 'databases/vendibase.sqlite'));
  }

  static Future<FileSystemEntity> deleteDatabase() async {
    final dbFile = await getDbFile();
    return dbFile.delete();
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

enum ActionType { create, view, update, delete }

abstract class CrudInterface {
  CrudInterface();

  Stream<List<Object>> all() {
    throw UnimplementedError();
  }

  Stream<Object> one(int id) {
    throw UnimplementedError();
  }

  Future<int> make(covariant Object param) async {
    throw UnimplementedError();
  }

  Future<int> revise(covariant Object param) async {
    throw UnimplementedError();
  }

  Future<int> omit(covariant Object param) async {
    throw UnimplementedError();
  }
}

class CategoryWithChildren {
  CategoryWithChildren({
    required this.id,
    required this.name,
    required this.dateCreated,
    this.children,
  });

  final int id;
  final String name;
  final DateTime dateCreated;

  final List<Category>? children;
}

@DriftAccessor(tables: [Categories])
class CategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriesDaoMixin
    implements CrudInterface {
  CategoriesDao(AppDatabase db) : super(db);

  @override
  Stream<List<Category>> all() {
    final _query = select(categories);
    return _query.watch();
  }

  @override
  Future<int> make(CategoriesCompanion category) async {
    return await into(categories).insert(category);
  }

  @override
  Future<int> omit(CategoriesCompanion category) async {
    return await delete(categories).delete(category);
  }

  @override
  Stream<Category> one(int id) {
    final _query = select(categories);
    _query.where((category) => category.id.equals(id));
    return _query.watchSingle();
  }

  @override
  Future<int> revise(CategoriesCompanion category) async {
    final _query = update(categories);
    _query.where((t) => t.id.equals(category.id.value));
    return await _query.write(category);
  }

  // Custom query

  Future<List<Category>> getCategories([int? id]) async {
    final _query = select(categories);
    _query.where(
      (category) => (id == null)
          ? category.parentId.isNull()
          : category.parentId.isNull() & category.id.equals(id).not(),
    );
    return await _query.get();
  }

  Future<Category> getCategory(int id) async {
    final _query = select(categories);
    _query.where((category) => category.id.equals(id));
    return await _query.getSingle();
  }

  Stream<List<Category>> watchCategories([int? id]) {
    final _query = select(categories);
    _query.where(
      (category) => (id == null)
          ? category.parentId.isNull()
          : category.parentId.isNull() & category.id.equals(id).not(),
    );
    return _query.watch();
  }

  Stream<CategoryWithChildren> watchCategory(int id) {
    final _query = select(categories);
    _query.where((category) => category.id.equals(id));

    final _query2 = select(categories);
    _query2.where((category) => category.parentId.equals(id));

    return Rx.combineLatest2(_query.watchSingle(), _query2.watch(), (
      Category a,
      List<Category> b,
    ) {
      return CategoryWithChildren(
        id: a.id,
        name: a.name,
        dateCreated: a.dateCreated,
        children: b.toList(),
      );
    });
  }
}

@DriftAccessor(tables: [Units])
class UnitsDao extends DatabaseAccessor<AppDatabase>
    with _$UnitsDaoMixin
    implements CrudInterface {
  UnitsDao(AppDatabase db) : super(db);

  @override
  Stream<List<Unit>> all() {
    final _query = select(units);
    return _query.watch();
  }

  @override
  Future<int> make(UnitsCompanion unit) async {
    return await into(units).insert(unit);
  }

  @override
  Future<int> omit(UnitsCompanion unit) async {
    return await delete(units).delete(unit);
  }

  @override
  Stream<Unit> one(int id) {
    final _query = select(units);
    _query.where((unit) => unit.id.equals(id));
    return _query.watchSingle();
  }

  @override
  Future<int> revise(UnitsCompanion unit) async {
    final _query = update(units);
    _query.where((t) => t.id.equals(unit.id.value));
    return await _query.write(unit);
  }

  // Custom query

  Future<List<Unit>> getUnits() async {
    final _query = select(units);
    return await _query.get();
  }

  Future<Unit> getUnit(int id) async {
    final _query = select(units);
    _query.where((unit) => unit.id.equals(id));
    return await _query.getSingle();
  }
}

@DriftAccessor(tables: [Persons])
class PersonsDao extends DatabaseAccessor<AppDatabase>
    with _$PersonsDaoMixin
    implements CrudInterface {
  PersonsDao(AppDatabase db) : super(db);

  @override
  Stream<List<Person>> all() {
    final _query = select(persons);
    return _query.watch();
  }

  @override
  Future<int> make(PersonsCompanion person) async {
    return await into(persons).insert(person);
  }

  @override
  Future<int> omit(PersonsCompanion person) async {
    return await delete(persons).delete(person);
  }

  @override
  Stream<Person> one(int id) {
    final _query = select(persons);
    _query.where((person) => person.id.equals(id));
    return _query.watchSingle();
  }

  @override
  Future<int> revise(PersonsCompanion person) async {
    final _query = update(persons);
    _query.where((t) => t.id.equals(person.id.value));
    return await _query.write(person);
  }

  // Custom query

  Future<Person> getPerson(int id) async {
    final _query = select(persons);
    _query.where((person) => person.id.equals(id));
    return await _query.getSingle();
  }

  Future<List<Person>> getPersons() async {
    final _query = select(persons);
    return await _query.get();
  }
}

class ProductWithDetails {
  ProductWithDetails({
    required this.id,
    this.unitId,
    this.unit,
    this.categoryId,
    this.category,
    required this.photo,
    required this.name,
    this.remarks,
    required this.isFavorite,
    required this.dateCreated,
    this.activePriceId,
    this.activePrice,
    this.activeQuantity,
    this.activePriceDate,
    this.latestCostId,
    this.latestCost,
    this.latestQuantity,
    this.latestCostDate,
    this.productPrices,
    this.productPurchases,
  });

  final int id;

  final int? unitId;
  final String? unit;
  final int? categoryId;
  final String? category;

  final String photo;
  final String name;
  final String? remarks;
  final bool isFavorite;
  final DateTime dateCreated;

  final int? activePriceId;
  final double? activePrice;
  final int? activeQuantity;
  final DateTime? activePriceDate;

  final int? latestCostId;
  final double? latestCost;
  final int? latestQuantity;
  final DateTime? latestCostDate;

  final List<ProductPrice>? productPrices;
  final List<ProductPurchase>? productPurchases;
}

@DriftAccessor(tables: [Products])
class ProductsDao extends DatabaseAccessor<AppDatabase>
    with
        _$ProductsDaoMixin,
        _$ProductPurchasesDaoMixin,
        _$ProductPricesDaoMixin,
        _$ArrearPurchasesDaoMixin,
        _$UnitsDaoMixin,
        _$CategoriesDaoMixin
    implements CrudInterface {
  ProductsDao(AppDatabase db) : super(db);

  @override
  Stream<List<Product>> all() {
    final _query = select(products);
    return _query.watch();
  }

  @override
  Future<int> make(ProductsCompanion product) async {
    return await into(products).insert(product);
  }

  @override
  Future<int> omit(ProductsCompanion product) async {
    return await delete(products).delete(product);
  }

  @override
  Stream<Product> one(int id) {
    final _query = select(products);
    _query.where((product) => product.id.equals(id));
    return _query.watchSingle();
  }

  @override
  Future<int> revise(ProductsCompanion product) async {
    final _query = update(products);
    _query.where((t) => t.id.equals(product.id.value));
    return await _query.write(product);
  }

  // Custom query

  Future<ProductWithDetails> getProduct(int id) async {
    final _query1 = """
      SELECT
        P.id,
        P.photo,
        U.id AS unit_id,
        U.name AS unit,
        C.id AS category_id,
        C.name AS category,
        P.name,
        P.remarks,
        P.is_favorite,
        P.date_created,
        SQ1.active_price_id,
        SQ1.active_price,
        SQ2.active_quantity,
        SQ1.active_price_date,
        SQ3.latest_cost_id,
        SQ3.latest_cost,
        SQ3.latest_quantity,
        SQ3.latest_cost_date
      FROM products P
      LEFT OUTER JOIN units U ON U.id = P.unit_id
      LEFT OUTER JOIN categories C ON C.id = P.category_id
      LEFT OUTER JOIN (
        SELECT
          PPRC.id AS active_price_id,
          PPRC.product_id,
          PPRC.retail AS active_price,
          PPRC.date_created AS active_price_date
        FROM product_prices PPRC
        WHERE PPRC.is_active = 1
        GROUP BY PPRC.product_id
      ) AS SQ1 ON SQ1.product_id = P.id
      LEFT OUTER JOIN (
        SELECT
          PPCH.product_id,
          COALESCE(SUM(PPCH.quantity), 0) - COALESCE(SQ.ap_qty, 0) AS active_quantity
        FROM product_purchases PPCH
        LEFT OUTER JOIN (
          SELECT
            APCH.product_id,
            SUM(APCH.quantity) AS ap_qty
          FROM arrear_purchases APCH
          GROUP BY APCH.product_id
        ) SQ ON SQ.product_id = PPCH.product_id
        GROUP BY PPCH.product_id
      ) AS SQ2 ON SQ2.product_id = P.id
      LEFT OUTER JOIN (
        SELECT
          PPCH.id AS latest_cost_id,
          PPCH.product_id,
          PPCH.cost AS latest_cost,
          PPCH.quantity AS latest_quantity,
          PPCH.date_created AS latest_cost_date
        FROM product_purchases PPCH
        INNER JOIN (
          SELECT product_id, MAX(date_created) AS MDC
          FROM product_purchases GROUP BY product_id
        ) ISQ ON PPCH.product_id = ISQ.product_id AND PPCH.date_created = ISQ.MDC
      ) AS SQ3 ON SQ3.product_id = P.id
      WHERE P.id = ?;
    """;

    final result = await customSelect(
      _query1,
      variables: [
        Variable.withInt(id),
      ],
      readsFrom: {
        products,
        productPurchases,
        productPrices,
        arrearPurchases,
        categories,
        units,
      },
    ).getSingle();
    final _data = result.data;

    return ProductWithDetails(
      id: _data['id'],
      photo: _data['photo'],
      name: _data['name'],
      remarks: _data['remarks'],
      isFavorite: _data['is_favorite'] == 1 ? true : false,
      dateCreated: getDateTime(_data['date_created'])!,
      unitId: _data['unit_id'],
      unit: _data['unit'],
      categoryId: _data['category_id'],
      category: _data['category'],
      activePriceId: _data['active_price_id'],
      activePrice: _data['active_price'],
      activeQuantity: _data['active_quantity'],
      activePriceDate: getDateTime(_data['active_price_date']),
      latestCostId: _data['latest_cost_id'],
      latestCost: _data['latest_cost'],
      latestQuantity: _data['latest_quantity'],
      latestCostDate: getDateTime(_data['latest_cost_date']),
    );
  }

  Future<List<ProductWithDetails>> getProducts() async {
    final _query = """
      SELECT
        P.id,
        P.photo,
        U.id AS unit_id,
        U.name AS unit,
        C.id AS category_id,
        C.name AS category,
        P.name,
        P.remarks,
        P.is_favorite,
        P.date_created,
        SQ1.active_price_id,
        SQ1.active_price,
        SQ2.active_quantity,
        SQ1.active_price_date,
        SQ3.latest_cost_id,
        SQ3.latest_cost,
        SQ3.latest_quantity,
        SQ3.latest_cost_date
      FROM products P
      LEFT OUTER JOIN units U ON U.id = P.unit_id
      LEFT OUTER JOIN categories C ON C.id = P.category_id
      LEFT OUTER JOIN (
        SELECT
          PPRC.id AS active_price_id,
          PPRC.product_id,
          PPRC.retail AS active_price,
          PPRC.date_created AS active_price_date
        FROM product_prices PPRC
        WHERE PPRC.is_active = 1
        GROUP BY PPRC.product_id
      ) AS SQ1 ON SQ1.product_id = P.id
      LEFT OUTER JOIN (
        SELECT
          PPCH.product_id,
          COALESCE(SUM(PPCH.quantity), 0) - COALESCE(SQ.ap_qty, 0) AS active_quantity
        FROM product_purchases PPCH
        LEFT OUTER JOIN (
          SELECT
            APCH.product_id,
            SUM(APCH.quantity) AS ap_qty
          FROM arrear_purchases APCH
          GROUP BY APCH.product_id
        ) SQ ON SQ.product_id = PPCH.product_id
        GROUP BY PPCH.product_id
      ) AS SQ2 ON SQ2.product_id = P.id
      LEFT OUTER JOIN (
        SELECT
          PPCH.id AS latest_cost_id,
          PPCH.product_id,
          PPCH.cost AS latest_cost,
          PPCH.quantity AS latest_quantity,
          PPCH.date_created AS latest_cost_date
        FROM product_purchases PPCH
        INNER JOIN (
          SELECT product_id, MAX(date_created) AS MDC
          FROM product_purchases GROUP BY product_id
        ) ISQ ON PPCH.product_id = ISQ.product_id AND PPCH.date_created = ISQ.MDC
      ) AS SQ3 ON SQ3.product_id = P.id
      WHERE SQ2.active_quantity >= 1
      ORDER BY P.is_favorite DESC;
    """;

    final _res = await customSelect(
      _query,
      variables: [],
      readsFrom: {
        products,
        productPurchases,
        productPrices,
        arrearPurchases,
        categories,
        units,
      },
    ).get();

    return _res.map((row) {
      final _data = row.data;

      return ProductWithDetails(
        id: _data['id'],
        photo: _data['photo'],
        name: _data['name'],
        remarks: _data['remarks'],
        isFavorite: _data['is_favorite'] == 1 ? true : false,
        dateCreated: getDateTime(_data['date_created'])!,
        unitId: _data['unit_id'],
        unit: _data['unit'],
        categoryId: _data['category_id'],
        category: _data['category'],
        activePriceId: _data['active_price_id'],
        activePrice: _data['active_price'],
        activeQuantity: _data['active_quantity'],
        activePriceDate: getDateTime(_data['active_price_date']),
        latestCostId: _data['latest_cost_id'],
        latestCost: _data['latest_cost'],
        latestQuantity: _data['latest_quantity'],
        latestCostDate: getDateTime(_data['latest_cost_date']),
      );
    }).toList();
  }

  Stream<List<ProductWithDetails>> watchProducts([
    String? term = '',
    Map<String, dynamic>? filters,
  ]) {
    var _query = """
      SELECT
        P.id,
        P.photo,
        U.id AS unit_id,
        U.name AS unit,
        C.id AS category_id,
        C.name AS category,
        P.name,
        P.remarks,
        P.is_favorite,
        P.date_created,
        SQ1.active_price_id,
        SQ1.active_price,
        SQ2.active_quantity,
        SQ1.active_price_date,
        SQ3.latest_cost_id,
        SQ3.latest_cost,
        SQ3.latest_quantity,
        SQ3.latest_cost_date
      FROM products P
      LEFT OUTER JOIN units U ON U.id = P.unit_id
      LEFT OUTER JOIN categories C ON C.id = P.category_id
      LEFT OUTER JOIN (
        SELECT
          PPRC.id AS active_price_id,
          PPRC.product_id,
          PPRC.retail AS active_price,
          PPRC.date_created AS active_price_date
        FROM product_prices PPRC
        WHERE PPRC.is_active = 1
        GROUP BY PPRC.product_id
      ) AS SQ1 ON SQ1.product_id = P.id
      LEFT OUTER JOIN (
        SELECT
          PPCH.product_id,
          COALESCE(SUM(PPCH.quantity), 0) - COALESCE(SQ.ap_qty, 0) AS active_quantity
        FROM product_purchases PPCH
        LEFT OUTER JOIN (
          SELECT
            APCH.product_id,
            SUM(APCH.quantity) AS ap_qty
          FROM arrear_purchases APCH
          GROUP BY APCH.product_id
        ) SQ ON SQ.product_id = PPCH.product_id
        GROUP BY PPCH.product_id
      ) AS SQ2 ON SQ2.product_id = P.id
      LEFT OUTER JOIN (
        SELECT
          PPCH.id AS latest_cost_id,
          PPCH.product_id,
          PPCH.cost AS latest_cost,
          PPCH.quantity AS latest_quantity,
          PPCH.date_created AS latest_cost_date
        FROM product_purchases PPCH
        INNER JOIN (
          SELECT product_id, MAX(date_created) AS MDC
          FROM product_purchases GROUP BY product_id
        ) ISQ ON PPCH.product_id = ISQ.product_id AND PPCH.date_created = ISQ.MDC
      ) AS SQ3 ON SQ3.product_id = P.id
      WHERE P.name LIKE ?
      /* %PRICE_RANGE_FILTER% */
      /* %CATEGORY_ID_FILTER% */
      /* %UNIT_ID_FILTER% */
      ORDER BY P.is_favorite DESC;
    """;

    List<Variable<dynamic>> _vars = [
      Variable.withString('%$term%'),
    ];

    if (filters != null && filters.length >= 1) {
      /// Price Range Filter
      final _priceRangeFtr = 'AND SQ1.active_price BETWEEN ? AND ?';
      final _priceRange = filters['priceRange'];
      if (_priceRange != null &&
          (_priceRange.start != 1.0 && _priceRange.end != 1.0)) {
        _vars.add(Variable.withReal(_priceRange.start));
        _vars.add(Variable.withReal(_priceRange.end));
        _query =
            _query.replaceAll('/* %PRICE_RANGE_FILTER% */', _priceRangeFtr);
      }

      /// Category Id Filter
      final _categoryIdFtr = 'AND C.id = ?';
      final _categoryId = filters['categoryId'];
      if (_categoryId != null) {
        _vars.add(Variable.withInt(_categoryId));
        _query =
            _query.replaceAll('/* %CATEGORY_ID_FILTER% */', _categoryIdFtr);
      }

      /// Unit Id Filter
      final _unitIdFtr = 'AND U.id = ?';
      final _unitId = filters['unitId'];
      if (_unitId != null) {
        _vars.add(Variable.withInt(_unitId));
        _query = _query.replaceAll('/* %UNIT_ID_FILTER% */', _unitIdFtr);
      }
    }

    return customSelect(
      _query,
      variables: _vars,
      readsFrom: {
        products,
        productPurchases,
        productPrices,
        arrearPurchases,
        categories,
        units,
      },
    ).watch().map((rows) {
      return rows.map((row) {
        final _data = row.data;

        return ProductWithDetails(
          id: _data['id'],
          photo: _data['photo'],
          name: _data['name'],
          remarks: _data['remarks'],
          isFavorite: _data['is_favorite'] == 1 ? true : false,
          dateCreated: getDateTime(_data['date_created'])!,
          unitId: _data['unit_id'],
          unit: _data['unit'],
          categoryId: _data['category_id'],
          category: _data['category'],
          activePriceId: _data['active_price_id'],
          activePrice: _data['active_price'],
          activeQuantity: _data['active_quantity'],
          activePriceDate: getDateTime(_data['active_price_date']),
          latestCostId: _data['latest_cost_id'],
          latestCost: _data['latest_cost'],
          latestQuantity: _data['latest_quantity'],
          latestCostDate: getDateTime(_data['latest_cost_date']),
        );
      }).toList();
    });
  }

  Stream<ProductWithDetails> watchProduct(int id) {
    final _query = """
      SELECT
        P.id,
        P.photo,
        U.id AS unit_id,
        U.name AS unit,
        C.id AS category_id,
        C.name AS category,
        P.name,
        P.remarks,
        P.is_favorite,
        P.date_created,
        SQ1.active_price_id,
        SQ1.active_price,
        SQ2.active_quantity,
        SQ1.active_price_date,
        SQ3.latest_cost_id,
        SQ3.latest_cost,
        SQ3.latest_quantity,
        SQ3.latest_cost_date
      FROM products P
      LEFT OUTER JOIN units U ON U.id = P.unit_id
      LEFT OUTER JOIN categories C ON C.id = P.category_id
      LEFT OUTER JOIN (
        SELECT
          PPRC.id AS active_price_id,
          PPRC.product_id,
          PPRC.retail AS active_price,
          PPRC.date_created AS active_price_date
        FROM product_prices PPRC
        WHERE PPRC.is_active = 1
        GROUP BY PPRC.product_id
      ) AS SQ1 ON SQ1.product_id = P.id
      LEFT OUTER JOIN (
        SELECT
          PPCH.product_id,
          COALESCE(SUM(PPCH.quantity), 0) - COALESCE(SQ.ap_qty, 0) AS active_quantity
        FROM product_purchases PPCH
        LEFT OUTER JOIN (
          SELECT
            APCH.product_id,
            SUM(APCH.quantity) AS ap_qty
          FROM arrear_purchases APCH
          GROUP BY APCH.product_id
        ) SQ ON SQ.product_id = PPCH.product_id
        GROUP BY PPCH.product_id
      ) AS SQ2 ON SQ2.product_id = P.id
      LEFT OUTER JOIN (
        SELECT
          PPCH.id AS latest_cost_id,
          PPCH.product_id,
          PPCH.cost AS latest_cost,
          PPCH.quantity AS latest_quantity,
          PPCH.date_created AS latest_cost_date
        FROM product_purchases PPCH
        INNER JOIN (
          SELECT product_id, MAX(date_created) AS MDC
          FROM product_purchases GROUP BY product_id
        ) ISQ ON PPCH.product_id = ISQ.product_id AND PPCH.date_created = ISQ.MDC
      ) AS SQ3 ON SQ3.product_id = P.id
      WHERE P.id = ?;
    """;

    final _productPrices = select(productPrices);
    _productPrices.where((entry) => entry.productId.equals(id));

    final _productPurchases = select(productPurchases);
    _productPurchases.where((entry) => entry.productId.equals(id));

    return Rx.combineLatest3(
      customSelect(
        _query,
        variables: [
          Variable.withInt(id),
        ],
        readsFrom: {
          products,
          productPurchases,
          productPrices,
          arrearPurchases,
          categories,
          units,
        },
      ).watchSingle(),
      _productPrices.watch(),
      _productPurchases.watch(),
      (
        QueryRow a,
        List<ProductPrice> b,
        List<ProductPurchase> c,
      ) {
        final _data = a.data;

        return ProductWithDetails(
          id: _data['id'],
          photo: _data['photo'],
          name: _data['name'],
          remarks: _data['remarks'],
          isFavorite: _data['is_favorite'] == 1 ? true : false,
          dateCreated: getDateTime(_data['date_created'])!,
          unitId: _data['unit_id'],
          unit: _data['unit'],
          categoryId: _data['category_id'],
          category: _data['category'],
          activePriceId: _data['active_price_id'],
          activePrice: _data['active_price'],
          activeQuantity: _data['active_quantity'],
          activePriceDate: getDateTime(_data['active_price_date']),
          latestCostId: _data['latest_cost_id'],
          latestCost: _data['latest_cost'],
          latestQuantity: _data['latest_quantity'],
          latestCostDate: getDateTime(_data['latest_cost_date']),
          productPrices: b.toList(),
          productPurchases: c.toList(),
        );
      },
    );
  }
}

@DriftAccessor(tables: [ProductPurchases])
class ProductPurchasesDao extends DatabaseAccessor<AppDatabase>
    with _$ProductPurchasesDaoMixin
    implements CrudInterface {
  ProductPurchasesDao(AppDatabase db) : super(db);

  @override
  Stream<List<ProductPurchase>> all() {
    final _query = select(productPurchases);
    return _query.watch();
  }

  @override
  Future<int> make(ProductPurchasesCompanion productPurchase) async {
    return await into(productPurchases).insert(productPurchase);
  }

  @override
  Future<int> omit(ProductPurchasesCompanion productPurchase) async {
    return await delete(productPurchases).delete(productPurchase);
  }

  @override
  Stream<ProductPurchase> one(int id) {
    final _query = select(productPurchases);
    _query.where((productPurchase) => productPurchase.id.equals(id));
    return _query.watchSingle();
  }

  @override
  Future<int> revise(ProductPurchasesCompanion productPurchase) async {
    final _query = update(productPurchases);
    _query.where((t) => t.id.equals(productPurchase.id.value));
    return await _query.write(productPurchase);
  }
}

@DriftAccessor(tables: [ProductPrices])
class ProductPricesDao extends DatabaseAccessor<AppDatabase>
    with _$ProductPricesDaoMixin
    implements CrudInterface {
  ProductPricesDao(AppDatabase db) : super(db);

  @override
  Stream<List<ProductPrice>> all() {
    final _query = select(productPrices);
    return _query.watch();
  }

  @override
  Future<int> make(ProductPricesCompanion productPrice) async {
    return await into(productPrices).insert(productPrice);
  }

  @override
  Future<int> omit(ProductPricesCompanion productPrice) async {
    return await delete(productPrices).delete(productPrice);
  }

  @override
  Stream<ProductPrice> one(int id) {
    final _query = select(productPrices);
    _query.where((productPrice) => productPrice.id.equals(id));
    return _query.watchSingle();
  }

  @override
  Future<int> revise(ProductPricesCompanion productPrice) async {
    final _query = update(productPrices);
    _query.where((t) => t.id.equals(productPrice.id.value));
    return await _query.write(productPrice);
  }

  // Custom query

  Stream<double> watchMaxRetail() {
    final _query = """
      SELECT 
        COALESCE(MAX(PP.retail), 0.0) AS max_retail
      FROM product_prices PP
    """;

    return customSelect(
      _query,
      variables: [],
      readsFrom: {productPrices},
    ).watchSingle().map((result) => result.data['max_retail']);
  }

  Future setActive(
    ProductPricesCompanion productPrice, {
    ActionType actionType = ActionType.create,
  }) async {
    var _id;
    if (actionType == ActionType.create) {
      _id = await into(productPrices).insert(productPrice);
    }

    if (actionType == ActionType.update) {
      await update(productPrices).replace(productPrice);
      _id = productPrice.id.value;
    }

    // Update previous data
    final _productPrices = await select(productPrices).get();
    _productPrices.forEach((_productPrice) async {
      if (_productPrice.id != _id) {
        await update(productPrices).replace(
          ProductPricesCompanion(
            id: Value(_productPrice.id),
            productId: Value(_productPrice.productId),
            retail: Value(_productPrice.retail),
            isActive: Value(false),
            dateCreated: Value(_productPrice.dateCreated),
          ),
        );
      }
    });
  }
}

class ArrearWithDetails {
  ArrearWithDetails({
    required this.id,
    required this.status,
    required this.amount,
    required this.activeAmount,
    required this.personId,
    required this.personName,
    required this.personPhoto,
    this.due,
    this.notificationId,
    this.remarks,
    required this.dateCreated,
    required this.totalPurchase,
    required this.totalPurchaseAmount,
    this.totalPayment,
    this.totalPaymentAmount,
    this.arrearPayments,
    this.arrearPurchases,
  });

  final int id;
  final int status;
  final double amount;
  final double activeAmount;

  final int personId;
  final String personName;
  final String personPhoto;

  final DateTime? due;
  final int? notificationId;
  final String? remarks;
  final DateTime dateCreated;

  final int totalPurchase;
  final double totalPurchaseAmount;

  final int? totalPayment;
  final double? totalPaymentAmount;

  final List<ArrearPayment>? arrearPayments;
  final List<ArrearPurchaseWithDetails>? arrearPurchases;
}

@DriftAccessor(tables: [Arrears])
class ArrearsDao extends DatabaseAccessor<AppDatabase>
    with
        _$ArrearsDaoMixin,
        _$ArrearPaymentsDaoMixin,
        _$ArrearPurchasesDaoMixin,
        _$PersonsDaoMixin,
        _$ProductPricesDaoMixin
    implements CrudInterface {
  ArrearsDao(AppDatabase db) : super(db);

  @override
  Stream<List<Arrear>> all() {
    final _query = select(arrears);
    return _query.watch();
  }

  @override
  Future<int> make(ArrearsCompanion arrear) async {
    return await into(arrears).insert(arrear);
  }

  @override
  Future<int> omit(ArrearsCompanion arrear) async {
    return await delete(arrears).delete(arrear);
  }

  @override
  Stream<Arrear> one(int id) {
    final _query = select(arrears);
    _query.where((arrear) => arrear.id.equals(id));
    return _query.watchSingle();
  }

  @override
  Future<int> revise(ArrearsCompanion arrear) async {
    final _query = update(arrears);
    _query.where((t) => t.id.equals(arrear.id.value));
    return await _query.write(arrear);
  }

  // Custom query

  Stream<double> watchMaxActiveAmount() {
    final _query = """
      SELECT
        CASE WHEN 
          COALESCE(A.amount, 0.0.0) - COALESCE(SQ.total_payment_amount, 0.0) <= 0 
          THEN 0.0 
          ELSE MAX(COALESCE(A.amount, 0.0.0) - COALESCE(SQ.total_payment_amount, 0.0)) 
        END AS max_active_amount
      FROM arrears A
      LEFT OUTER JOIN (
        SELECT
          AP.arrear_id,
          COALESCE(COUNT(AP.arrear_id), 0.0) AS total_payment,
          COALESCE(SUM(AP.amount), 0.0) AS total_payment_amount
        FROM arrear_payments AP
        GROUP BY AP.arrear_id
      ) AS SQ ON SQ.arrear_id = A.id
    """;

    return customSelect(
      _query,
      variables: [],
      readsFrom: {arrears},
    ).watchSingle().map((result) => result.data['max_active_amount']);
  }

  Future<ArrearWithDetails> getArrear(int id) async {
    final _query = """
      SELECT
        A.id,
        A.status,
        A.amount,
        CASE WHEN 
          COALESCE(A.amount, 0.0) - COALESCE(SQ2.total_payment_amount, 0.0) <= 0 
          THEN 0.0 
          ELSE COALESCE(A.amount, 0.0) - COALESCE(SQ2.total_payment_amount, 0.0) 
        END AS active_amount,
        P.id AS person_id,
        P.name AS person_name,
        P.photo AS person_photo,
        A.due,
        A.notification_id,
        A.remarks,
        A.date_created,
        COALESCE(SQ.total_purchase, 0) AS total_purchase,
        COALESCE(SQ1.total_purchase_amount, 0.0) AS total_purchase_amount,
        COALESCE(SQ2.total_payment, 0) AS total_payment,
        COALESCE(SQ2.total_payment_amount, 0.0) AS total_payment_amount
      FROM arrears A
      LEFT OUTER JOIN persons P ON P.id = A.person_id
      LEFT OUTER JOIN (
        SELECT
          AP.arrear_id,
          COALESCE(COUNT(AP.product_id), 0) AS total_purchase
        FROM arrear_purchases AP
        GROUP BY AP.arrear_id
      ) AS SQ ON SQ.arrear_id = A.id
      LEFT OUTER JOIN (
        SELECT
          AP.arrear_id,
          SUM(PP.retail * AP.quantity) AS total_purchase_amount
        FROM arrear_purchases AP
        LEFT OUTER JOIN product_prices PP ON PP.id = AP.product_price_id
        GROUP BY AP.arrear_id
      ) AS SQ1 ON SQ1.arrear_id = A.id
      LEFT OUTER JOIN (
        SELECT
          AP.arrear_id,
          COALESCE(COUNT(AP.arrear_id), 0) AS total_payment,
          COALESCE(SUM(AP.amount), 0.0) AS total_payment_amount
        FROM arrear_payments AP
        GROUP BY AP.arrear_id
      ) AS SQ2 ON SQ2.arrear_id = A.id
      WHERE A.id = ?;
    """;

    final _row = await customSelect(
      _query,
      variables: [Variable.withInt(id)],
      readsFrom: {
        persons,
        productPrices,
        arrears,
        arrearPurchases,
        arrearPayments,
      },
    ).getSingle();
    final _data = _row.data;

    final _arrearPayments = select(arrearPayments);
    _arrearPayments.where((entry) => entry.arrearId.equals(id));
    final _list1 = await _arrearPayments.get();

    final _apchDao = ArrearPurchasesDao(db);
    _apchDao.getArrearPurchases(id);
    final _list2 = await _apchDao.getArrearPurchases(id);

    return ArrearWithDetails(
      id: _data['id'],
      status: _data['status'],
      amount: _data['amount'],
      activeAmount: _data['active_amount'],
      personId: _data['person_id'],
      personName: _data['person_name'],
      personPhoto: _data['person_photo'],
      due: getDateTime(_data['due']),
      notificationId: _data['notification_id'],
      remarks: _data['remarks'],
      dateCreated: getDateTime(_data['date_created'])!,
      totalPurchase: _data['total_purchase'],
      totalPurchaseAmount: _data['total_purchase_amount'],
      totalPayment: _data['total_payment'],
      totalPaymentAmount: _data['total_payment_amount'],
      arrearPayments: _list1.toList(),
      arrearPurchases: _list2.toList(),
    );
  }

  Stream<List<ArrearWithDetails>> watchArrears([
    String term = '',
    Map<String, dynamic>? filters,
  ]) {
    var _query = """
      SELECT
        A.id,
        A.status,
        A.amount,
        CASE WHEN 
          COALESCE(A.amount, 0.0) - COALESCE(SQ2.total_payment_amount, 0.0) <= 0 
          THEN 0.0 
          ELSE COALESCE(A.amount, 0.0) - COALESCE(SQ2.total_payment_amount, 0.0) 
        END AS active_amount,
        P.id AS person_id,
        P.name AS person_name,
        P.photo AS person_photo,
        A.due,
        A.notification_id,
        A.remarks,
        A.date_created,
        COALESCE(SQ.total_purchase, 0) AS total_purchase,
        COALESCE(SQ1.total_purchase_amount, 0.0) AS total_purchase_amount,
        COALESCE(SQ2.total_payment, 0) AS total_payment,
        COALESCE(SQ2.total_payment_amount, 0.0) AS total_payment_amount
      FROM arrears A
      LEFT OUTER JOIN persons P ON P.id = A.person_id
      LEFT OUTER JOIN (
        SELECT
          AP.arrear_id,
          COALESCE(COUNT(AP.product_id), 0) AS total_purchase
        FROM arrear_purchases AP
        GROUP BY AP.arrear_id
      ) AS SQ ON SQ.arrear_id = A.id
      LEFT OUTER JOIN (
        SELECT
          AP.arrear_id,
          SUM(PP.retail * AP.quantity) AS total_purchase_amount
        FROM arrear_purchases AP
        LEFT OUTER JOIN product_prices PP ON PP.id = AP.product_price_id
        GROUP BY AP.arrear_id
      ) AS SQ1 ON SQ1.arrear_id = A.id
      LEFT OUTER JOIN (
        SELECT
          AP.arrear_id,
          COALESCE(COUNT(AP.arrear_id), 0) AS total_payment,
          COALESCE(SUM(AP.amount), 0.0) AS total_payment_amount
        FROM arrear_payments AP
        GROUP BY AP.arrear_id
      ) AS SQ2 ON SQ2.arrear_id = A.id
      WHERE P.name LIKE ?
      /* %PRICE_RANGE_FILTER% */
      /* %STATUS_FILTER% */
      /* %DUE_FILTER% */
    """;

    List<Variable<dynamic>> _vars = [
      Variable.withString('%$term%'),
    ];

    if (filters != null && filters.length >= 1) {
      /// Price Range Filter
      final _priceRangeFtr = 'AND active_amount BETWEEN ? AND ?';
      final _priceRange = filters['priceRange'];
      if (_priceRange != null &&
          (_priceRange.start != 1.0 && _priceRange.end != 1.0)) {
        _vars.add(Variable.withReal(_priceRange.start));
        _vars.add(Variable.withReal(_priceRange.end));
        _query =
            _query.replaceAll('/* %PRICE_RANGE_FILTER% */', _priceRangeFtr);
      }

      /// Status Filter
      final _statusFtr = 'AND A.status = ?';
      final _status = filters['status'];
      if (_status != null) {
        _vars.add(Variable.withInt(_status));
        _query = _query.replaceAll('/* %STATUS_FILTER% */', _statusFtr);
      }

      /// Due Filter
      final _dueFtr = 'AND A.due = ?';
      final _due = filters['due'];
      if (_due != null) {
        _vars.add(Variable.withDateTime(_due));
        _query = _query.replaceAll('/* %DUE_FILTER% */', _dueFtr);
      }
    }

    return customSelect(
      _query,
      variables: _vars,
      readsFrom: {
        persons,
        productPrices,
        arrears,
        arrearPurchases,
        arrearPayments,
      },
    ).watch().map((rows) {
      return rows.map((row) {
        final _data = row.data;

        return ArrearWithDetails(
          id: _data['id'],
          status: _data['status'],
          amount: _data['amount'],
          activeAmount: _data['active_amount'],
          personId: _data['person_id'],
          personName: _data['person_name'],
          personPhoto: _data['person_photo'],
          due: getDateTime(_data['due']),
          notificationId: _data['notification_id'],
          remarks: _data['remarks'],
          dateCreated: getDateTime(_data['date_created'])!,
          totalPurchase: _data['total_purchase'],
          totalPurchaseAmount: _data['total_purchase_amount'],
          totalPayment: _data['total_payment'],
          totalPaymentAmount: _data['total_payment_amount'],
        );
      }).toList();
    });
  }

  Stream<ArrearWithDetails> watchArrear(int id) {
    final _query = """
      SELECT
        A.id,
        A.status,
        A.amount,
        CASE WHEN 
          COALESCE(A.amount, 0.0) - COALESCE(SQ2.total_payment_amount, 0.0) <= 0 
          THEN 0.0 
          ELSE COALESCE(A.amount, 0.0) - COALESCE(SQ2.total_payment_amount, 0.0) 
        END AS active_amount,
        P.id AS person_id,
        P.name AS person_name,
        P.photo AS person_photo,
        A.due,
        A.notification_id,
        A.remarks,
        A.date_created,
        COALESCE(SQ.total_purchase, 0) AS total_purchase,
        COALESCE(SQ1.total_purchase_amount, 0.0) AS total_purchase_amount,
        COALESCE(SQ2.total_payment, 0) AS total_payment,
        COALESCE(SQ2.total_payment_amount, 0.0) AS total_payment_amount
      FROM arrears A
      LEFT OUTER JOIN persons P ON P.id = A.person_id
      LEFT OUTER JOIN (
        SELECT
          AP.arrear_id,
          COALESCE(COUNT(AP.product_id), 0) AS total_purchase
        FROM arrear_purchases AP
        GROUP BY AP.arrear_id
      ) AS SQ ON SQ.arrear_id = A.id
      LEFT OUTER JOIN (
        SELECT
          AP.arrear_id,
          SUM(PP.retail * AP.quantity) AS total_purchase_amount
        FROM arrear_purchases AP
        LEFT OUTER JOIN product_prices PP ON PP.id = AP.product_price_id
        GROUP BY AP.arrear_id
      ) AS SQ1 ON SQ1.arrear_id = A.id
      LEFT OUTER JOIN (
        SELECT
          AP.arrear_id,
          COALESCE(COUNT(AP.arrear_id), 0) AS total_payment,
          COALESCE(SUM(AP.amount), 0.0) AS total_payment_amount
        FROM arrear_payments AP
        GROUP BY AP.arrear_id
      ) AS SQ2 ON SQ2.arrear_id = A.id
      WHERE A.id = ?;
    """;

    final _arrearPayments = select(arrearPayments);
    _arrearPayments.where((entry) => entry.arrearId.equals(id));

    final _apchDao = ArrearPurchasesDao(db);
    _apchDao.watchArrearPurchases(id);

    return Rx.combineLatest3(
      customSelect(
        _query,
        variables: [Variable.withInt(id)],
        readsFrom: {
          persons,
          productPrices,
          arrears,
          arrearPurchases,
          arrearPayments,
        },
      ).watchSingle(),
      _arrearPayments.watch(),
      _apchDao.watchArrearPurchases(id),
      (
        QueryRow a,
        List<ArrearPayment> b,
        List<ArrearPurchaseWithDetails> c,
      ) {
        final _data = a.data;

        return ArrearWithDetails(
          id: _data['id'],
          status: _data['status'],
          amount: _data['amount'],
          activeAmount: _data['active_amount'],
          personId: _data['person_id'],
          personName: _data['person_name'],
          personPhoto: _data['person_photo'],
          due: getDateTime(_data['due']),
          notificationId: _data['notification_id'],
          remarks: _data['remarks'],
          dateCreated: getDateTime(_data['date_created'])!,
          totalPurchase: _data['total_purchase'],
          totalPurchaseAmount: _data['total_purchase_amount'],
          totalPayment: _data['total_payment'],
          totalPaymentAmount: _data['total_payment_amount'],
          arrearPayments: b.toList(),
          arrearPurchases: c.toList(),
        );
      },
    );
  }
}

class ArrearPurchaseWithDetails {
  ArrearPurchaseWithDetails({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.dateCreated,
  });

  final int id;
  final String productName;
  final double productPrice;
  final int quantity;
  final DateTime dateCreated;
}

@DriftAccessor(tables: [ArrearPurchases])
class ArrearPurchasesDao extends DatabaseAccessor<AppDatabase>
    with
        _$ArrearPurchasesDaoMixin,
        _$ProductsDaoMixin,
        _$ArrearPurchasesDaoMixin,
        _$ProductPricesDaoMixin
    implements CrudInterface {
  ArrearPurchasesDao(AppDatabase db) : super(db);

  @override
  Stream<List<ArrearPurchase>> all() {
    final _query = select(arrearPurchases);
    return _query.watch();
  }

  @override
  Future<int> make(ArrearPurchasesCompanion arrearPurchase) async {
    return await into(arrearPurchases).insert(arrearPurchase);
  }

  @override
  Future<int> omit(ArrearPurchasesCompanion arrearPurchase) async {
    return await delete(arrearPurchases).delete(arrearPurchase);
  }

  @override
  Stream<ArrearPurchase> one(int id) {
    final _query = select(arrearPurchases);
    _query.where((arrearPurchase) => arrearPurchase.id.equals(id));
    return _query.watchSingle();
  }

  @override
  Future<int> revise(ArrearPurchasesCompanion arrearPurchase) async {
    final _query = update(arrearPurchases);
    _query.where((t) => t.id.equals(arrearPurchase.id.value));
    return await _query.write(arrearPurchase);
  }

  // Custom query

  Future<List<ArrearPurchaseWithDetails>> getArrearPurchases(int id) async {
    final _query = """
      SELECT
        AP.id,
        AP.arrear_id,
        P.name AS product_name,
        SQ.active_price AS product_price,
        AP.quantity,
        AP.date_created
      FROM arrear_purchases AP
      LEFT OUTER JOIN products P ON P.id = AP.product_id
      LEFT OUTER JOIN (
        SELECT
          PPRC.id,
          PPRC.product_id,
          PPRC.retail AS active_price
        FROM product_prices PPRC
      ) AS SQ ON SQ.product_id = AP.product_id AND AP.product_price_id = SQ.id
      WHERE AP.arrear_id = ?;
    """;

    final _res = await customSelect(
      _query,
      variables: [Variable.withInt(id)],
      readsFrom: {
        arrearPurchases,
        products,
        productPrices,
      },
    ).get();

    return _res.map((row) {
      final _data = row.data;

      return ArrearPurchaseWithDetails(
        id: _data['id'],
        productName: _data['product_name'],
        productPrice: _data['product_price'],
        quantity: _data['quantity'],
        dateCreated: getDateTime(_data['date_created'])!,
      );
    }).toList();
  }

  Stream<List<ArrearPurchaseWithDetails>> watchArrearPurchases(int id) {
    final _query = """
      SELECT
        AP.id,
        AP.arrear_id,
        P.name AS product_name,
        SQ.active_price AS product_price,
        AP.quantity,
        AP.date_created
      FROM arrear_purchases AP
      LEFT OUTER JOIN products P ON P.id = AP.product_id
      LEFT OUTER JOIN (
        SELECT
          PPRC.id,
          PPRC.product_id,
          PPRC.retail AS active_price
        FROM product_prices PPRC
      ) AS SQ ON SQ.product_id = AP.product_id AND AP.product_price_id = SQ.id
      WHERE AP.arrear_id = ?;
    """;

    return customSelect(
      _query,
      variables: [Variable.withInt(id)],
      readsFrom: {
        arrearPurchases,
        products,
        productPrices,
      },
    ).watch().map((rows) {
      return rows.map((row) {
        final _data = row.data;

        return ArrearPurchaseWithDetails(
          id: _data['id'],
          productName: _data['product_name'],
          productPrice: _data['product_price'],
          quantity: _data['quantity'],
          dateCreated: getDateTime(_data['date_created'])!,
        );
      }).toList();
    });
  }
}

@DriftAccessor(tables: [ArrearPayments])
class ArrearPaymentsDao extends DatabaseAccessor<AppDatabase>
    with _$ArrearPaymentsDaoMixin
    implements CrudInterface {
  ArrearPaymentsDao(AppDatabase db) : super(db);

  @override
  Stream<List<ArrearPayment>> all() {
    final _query = select(arrearPayments);
    return _query.watch();
  }

  @override
  Future<int> make(ArrearPaymentsCompanion arrearPayment) async {
    return await into(arrearPayments).insert(arrearPayment);
  }

  @override
  Future<int> omit(ArrearPaymentsCompanion arrearPayment) async {
    return await delete(arrearPayments).delete(arrearPayment);
  }

  @override
  Stream<ArrearPayment> one(int id) {
    final _query = select(arrearPayments);
    _query.where((arrearPayment) => arrearPayment.id.equals(id));
    return _query.watchSingle();
  }

  @override
  Future<int> revise(ArrearPaymentsCompanion arrearPayment) async {
    final _query = update(arrearPayments);
    _query.where((t) => t.id.equals(arrearPayment.id.value));
    return await _query.write(arrearPayment);
  }
}

class EarningWithDetails {
  EarningWithDetails({
    required this.year,
    required this.month,
    required this.amount,
  });

  final String year;
  final String month;
  final double amount;
}

@DriftAccessor(tables: [Earnings])
class EarningsDao extends DatabaseAccessor<AppDatabase>
    with _$EarningsDaoMixin
    implements CrudInterface {
  EarningsDao(AppDatabase db) : super(db);

  @override
  Stream<List<Earning>> all() {
    final _query = select(earnings);
    _query.orderBy([
      (t) => OrderingTerm(expression: t.dateCreated, mode: OrderingMode.desc)
    ]);
    return _query.watch();
  }

  @override
  Future<int> make(EarningsCompanion earning) async {
    return await into(earnings).insert(earning);
  }

  @override
  Future<int> omit(EarningsCompanion earning) async {
    return await delete(earnings).delete(earning);
  }

  @override
  Stream<Earning> one(int id) {
    final _query = select(earnings);
    _query.where((earning) => earning.id.equals(id));
    return _query.watchSingle();
  }

  @override
  Future<int> revise(EarningsCompanion earning) async {
    final _query = update(earnings);
    _query.where((t) => t.id.equals(earning.id.value));
    return await _query.write(earning);
  }
}

class DashboardData {
  DashboardData({
    required this.totalEarnings,
    required this.earnings,
    required this.totalProducts,
    required this.totalPaidArrears,
    required this.totalUnpaidArrears,
  });

  final double totalEarnings;
  final List<EarningWithDetails> earnings;

  final int totalProducts;

  final int totalPaidArrears;
  final int totalUnpaidArrears;
}

@DriftAccessor(tables: [Earnings, Products, Arrears])
class DashboardDao extends DatabaseAccessor<AppDatabase>
    with
        _$DashboardDaoMixin,
        _$EarningsDaoMixin,
        _$ProductsDaoMixin,
        _$ArrearsDaoMixin {
  DashboardDao(AppDatabase db) : super(db);

  Stream<DashboardData> getData(String year) {
    final _query = """
      SELECT
        COALESCE(SUM(E.amount), 0.0) AS total_earnings
      FROM earnings E
      WHERE STRFTIME('%Y', E.date_created, 'unixepoch') = ?
    """;

    final _query1 = """
      SELECT
        STRFTIME('%Y', E.date_created, 'unixepoch') AS year,
        CASE STRFTIME('%m', E.date_created, 'unixepoch')
          WHEN '01' THEN 'January'
          WHEN '02' THEN 'February'
          WHEN '03' THEN 'March'
          WHEN '04' THEN 'April'
          WHEN '05' THEN 'May'
          WHEN '06' THEN 'June'
          WHEN '07' THEN 'July'
          WHEN '08' THEN 'August'
          WHEN '09' THEN 'September'
          WHEN '10' THEN 'October'
          WHEN '11' THEN 'November'
          WHEN '12' THEN 'December'
        END AS month,
        SUM(E.amount) AS amount
      FROM earnings E
      WHERE STRFTIME('%Y', E.date_created, 'unixepoch') = ?
      GROUP BY month
    """;

    final _query2 = """
      SELECT
        COALESCE(COUNT(P.id), 0) AS total_products
      FROM products P
    """;

    final _query3 = """
      SELECT
        COALESCE(COUNT(A.id), 0) AS total_paid_arrears
      FROM arrears A
      WHERE A.status = 1
    """;

    final _query4 = """
      SELECT
        COALESCE(COUNT(A.id), 0) AS total_unpaid_arrears
      FROM arrears A
      WHERE A.status = 0
    """;

    return Rx.combineLatest5(
      customSelect(
        _query,
        variables: [Variable.withString(year)],
        readsFrom: {earnings},
      ).watchSingle(),
      customSelect(
        _query1,
        variables: [Variable.withString(year)],
        readsFrom: {earnings},
      ).watch(),
      customSelect(
        _query2,
        variables: [],
        readsFrom: {products},
      ).watchSingle(),
      customSelect(
        _query3,
        variables: [],
        readsFrom: {arrears},
      ).watchSingle(),
      customSelect(
        _query4,
        variables: [],
        readsFrom: {arrears},
      ).watchSingle(),
      (
        QueryRow a,
        List<QueryRow> b,
        QueryRow c,
        QueryRow d,
        QueryRow e,
      ) {
        final _aData = a.data;
        final _bData = b.map((row) {
          final _data = row.data;
          return EarningWithDetails(
            year: _data['year'],
            month: _data['month'],
            amount: _data['amount'],
          );
        }).toList();
        final _cData = c.data;
        final _dData = d.data;
        final _eData = e.data;

        return DashboardData(
          totalEarnings: _aData['total_earnings'],
          earnings: _bData,
          totalProducts: _cData['total_products'],
          totalPaidArrears: _dData['total_paid_arrears'],
          totalUnpaidArrears: _eData['total_unpaid_arrears'],
        );
      },
    );
  }
}
