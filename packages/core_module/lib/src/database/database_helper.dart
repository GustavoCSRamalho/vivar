// core/database/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  // Nome e versão do banco
  static const String _databaseName = 'vivar_local.db';
  static const int _databaseVersion = 13;

  // Singleton do banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializar banco de dados
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Criar tabelas
  Future<void> _onCreate(Database db, int version) async {
    // Tabela de usuários
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        name TEXT NOT NULL,
        username TEXT,
        avatar_url TEXT,
        bio TEXT,
        phone TEXT,
        location TEXT,
        plan_type TEXT DEFAULT 'free',
        points INTEGER DEFAULT 0,
        favorite_count INTEGER DEFAULT 0,
        businesses_visited INTEGER DEFAULT 0,
        badges_count INTEGER DEFAULT 0,
        streak_days INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        synced INTEGER DEFAULT 0
      )
    ''');

    // Tabela de lugares
    await db.execute('''
      CREATE TABLE IF NOT EXISTS businesses (
        id TEXT PRIMARY KEY,
        user_id TEXT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        description TEXT,
        address TEXT NOT NULL,
        city TEXT,
        state TEXT,
        latitude REAL,
        longitude REAL,
        phone TEXT,
        whatsapp TEXT,
        email TEXT,
        schedule TEXT,
        is_whatsapp INTEGER DEFAULT 0,
        website TEXT,
        rating REAL DEFAULT 0,
        reviews_count INTEGER DEFAULT 0,
        price_range TEXT,
        is_open INTEGER DEFAULT 1,
        opening_hours TEXT,
        amenities TEXT,
        images TEXT,
        discount_text TEXT,
        discount_percentage INTEGER,
        is_premium_only INTEGER DEFAULT 0,
        distance REAL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        synced INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Tabela de reviews
    await db.execute('''
      CREATE TABLE IF NOT EXISTS reviews (
        id TEXT PRIMARY KEY,
        place_id TEXT NOT NULL,
        user_id TEXT NOT NULL,
        rating INTEGER NOT NULL,
        comment TEXT,
        images TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        synced INTEGER DEFAULT 0,
        FOREIGN KEY (place_id) REFERENCES businesses (id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Tabela de check-ins
    await db.execute('''
      CREATE TABLE IF NOT EXISTS checkins (
        id TEXT PRIMARY KEY,
        place_id TEXT NOT NULL,
        user_id TEXT NOT NULL,
        points_earned INTEGER DEFAULT 50,
        rating INTEGER,
        comment TEXT,
        created_at TEXT NOT NULL,
        synced INTEGER DEFAULT 0,
        FOREIGN KEY (place_id) REFERENCES businesses (id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Tabela de favoritos
    await db.execute('''
      CREATE TABLE IF NOT EXISTS favorites (
        id TEXT PRIMARY KEY,
        place_id TEXT NOT NULL,
        user_id TEXT NOT NULL,
        created_at TEXT NOT NULL,
        synced INTEGER DEFAULT 0,
        FOREIGN KEY (place_id) REFERENCES businesses (id) ON DELETE CASCADE,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        UNIQUE(place_id, user_id)
      )
    ''');

    // Tabela de badges
    await db.execute('''
      CREATE TABLE IF NOT EXISTS badges (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        badge_type TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        icon TEXT NOT NULL,
        earned_at TEXT NOT NULL,
        synced INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Tabela de desafios
    await db.execute('''
      CREATE TABLE IF NOT EXISTS challenges (
        id TEXT PRIMARY KEY,
        user_id TEXT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        challenge_type TEXT NOT NULL,
        target_count INTEGER NOT NULL,
        current_count INTEGER DEFAULT 0,
        reward_points INTEGER DEFAULT 0,
        reward_badge TEXT,
        reward_discount TEXT,
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL,
        is_active INTEGER DEFAULT 1,
        is_completed INTEGER DEFAULT 0,
        completed_at TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        synced INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Tabela de notificações
    await db.execute('''
      CREATE TABLE IF NOT EXISTS notifications (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        data TEXT,
        is_read INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        synced INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS sync_queue (
        entity_type TEXT NOT NULL,
        entity_id TEXT PRIMARY KEY,
        operation TEXT NOT NULL,
        data TEXT,
        timestamp INTEGER NOT NULL
)
    ''');

    // Índices para melhorar performance
    await db.execute(
      'CREATE INDEX idx_businesses_category ON businesses(category)',
    );
    await db.execute(
      'CREATE INDEX idx_businesses_location ON businesses(latitude, longitude)',
    );
    await db.execute('CREATE INDEX idx_reviews_place ON reviews(place_id)');
    await db.execute('CREATE INDEX idx_checkins_user ON checkins(user_id)');
    await db.execute('CREATE INDEX idx_favorites_user ON favorites(user_id)');
    await db.execute('CREATE INDEX idx_badges_user ON badges(user_id)');
    await db.execute('CREATE INDEX idx_challenges_user ON challenges(user_id)');
    await db.execute(
      'CREATE INDEX idx_notifications_user ON notifications(user_id)',
    );
  }

  // Upgrade do banco (migrações)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Implementar migrações futuras aqui
    if (oldVersion < 2) {
      // Exemplo: adicionar nova coluna
      // await db.execute('ALTER TABLE users ADD COLUMN new_field TEXT');
      await db.execute(
        'ALTER TABLE users ADD COLUMN favorite_count INTEGER DEFAULT 0',
      );
    }
  }

  // Fechar banco de dados
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  // Limpar todo o banco (útil para logout)
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('users');
    await db.delete('businesses');
    await db.delete('reviews');
    await db.delete('checkins');
    await db.delete('favorites');
    await db.delete('badges');
    await db.delete('challenges');
    await db.delete('notifications');
  }

  // Deletar banco de dados (útil para reset completo)
  Future<void> deleteDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
