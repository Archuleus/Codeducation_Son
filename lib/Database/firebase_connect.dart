import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FlutterConnection {
  static FlutterConnection? _instance;
  static FlutterConnection get instance =>
      _instance ??= FlutterConnection._internal();

  FlutterConnection._internal();

  // Firebase Database ve Auth
  FirebaseDatabase? _database;
  FirebaseAuth? _auth;

  // Database URL ve secret key
  static const String _databaseUrl =
      'https://codeducation-27352-default-rtdb.firebaseio.com';

  // Getter'lar
  FirebaseDatabase get database {
    if (_database == null) {
      // Firebase app'in başlatıldığından emin ol
      if (Firebase.apps.isEmpty) {
        throw Exception(
            'Firebase başlatılmamış. Lütfen Firebase.initializeApp() çağırın.');
      }

      _database = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: _databaseUrl,
      );
    }
    return _database!;
  }

  FirebaseAuth get auth {
    // Firebase app'in başlatıldığından emin ol
    if (Firebase.apps.isEmpty) {
      throw Exception(
          'Firebase başlatılmamış. Lütfen Firebase.initializeApp() çağırın.');
    }

    return _auth ??= FirebaseAuth.instance;
  }

  /// Firebase'i başlatır
  static Future<void> initializeFirebase() async {
    try {
      // Zaten başlatılmış mı kontrol et
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      print('Firebase başarıyla başlatıldı');
      print('Database URL: $_databaseUrl');
    } catch (e) {
      print('Firebase başlatma hatası: $e');
      rethrow; // Hatayı yukarı fırlat
    }
  }

  /// Firebase bağlantı durumunu kontrol eder
  bool get isFirebaseConnected {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Kullanıcı giriş durumunu kontrol eder
  bool get isUserSignedIn {
    try {
      return auth.currentUser != null;
    } catch (e) {
      print('Kullanıcı giriş durumu kontrol hatası: $e');
      return false;
    }
  }

  /// Mevcut kullanıcıyı döndürür
  User? get currentUser {
    try {
      return auth.currentUser;
    } catch (e) {
      print('Mevcut kullanıcı alma hatası: $e');
      return null;
    }
  }

  /// E-posta ile kayıt olma
  Future<Map<String, dynamic>> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      // Firebase'in başlatıldığından emin ol
      if (!isFirebaseConnected) {
        await initializeFirebase();
      }

      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (displayName != null && credential.user != null) {
        await credential.user!.updateDisplayName(displayName);
      }

      // Kullanıcı bilgilerini database'e kaydet
      if (credential.user != null) {
        await writeToDatabase(
          path: 'users/${credential.user!.uid}',
          data: {
            'name': displayName?.trim() ?? 'Kullanıcı',
            'email': email,
            'uid': credential.user!.uid,
            'createdAt': DateTime.now().millisecondsSinceEpoch,
            'lastLogin': DateTime.now().millisecondsSinceEpoch,
            'isActive': true,
          },
        );
      }

      print('Kullanıcı başarıyla kayıt oldu: ${credential.user?.email}');
      return {
        'success': true,
        'user': credential.user,
        'message': 'Hesap başarıyla oluşturuldu!'
      };
    } on FirebaseAuthException catch (e) {
      print('Kayıt hatası: ${e.message}');
      return {
        'success': false,
        'error': e.code,
        'message': _getErrorMessage(e.code)
      };
    } catch (e) {
      print('Genel kayıt hatası: $e');
      return {
        'success': false,
        'error': 'unknown',
        'message': 'Bir hata oluştu. Lütfen tekrar deneyin.'
      };
    }
  }

  /// E-posta ile giriş yapma
  Future<Map<String, dynamic>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Firebase'in başlatıldığından emin ol
      if (!isFirebaseConnected) {
        await initializeFirebase();
      }

      UserCredential credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Son giriş zamanını güncelle
      if (credential.user != null) {
        await writeToDatabase(
          path: 'users/${credential.user!.uid}/lastLogin',
          data: DateTime.now().millisecondsSinceEpoch,
        );
      }

      print('Kullanıcı başarıyla giriş yaptı: ${credential.user?.email}');
      return {
        'success': true,
        'user': credential.user,
        'message': 'Başarıyla giriş yapıldı!'
      };
    } on FirebaseAuthException catch (e) {
      print('Giriş hatası: ${e.message}');
      return {
        'success': false,
        'error': e.code,
        'message': _getErrorMessage(e.code)
      };
    } catch (e) {
      print('Genel giriş hatası: $e');
      return {
        'success': false,
        'error': 'unknown',
        'message': 'Bir hata oluştu. Lütfen tekrar deneyin.'
      };
    }
  }

  /// Çıkış yapma
  Future<void> signOut() async {
    try {
      await auth.signOut();
      print('Kullanıcı başarıyla çıkış yaptı');
    } catch (e) {
      print('Çıkış hatası: $e');
    }
  }

  /// Hata mesajlarını Türkçe'ye çevir
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'weak-password':
        return 'Şifre çok zayıf.';
      case 'email-already-in-use':
        return 'Bu e-posta adresi zaten kullanımda.';
      case 'user-not-found':
        return 'Kullanıcı bulunamadı.';
      case 'wrong-password':
        return 'Yanlış şifre.';
      case 'invalid-email':
        return 'Geçersiz e-posta adresi.';
      case 'user-disabled':
        return 'Kullanıcı hesabı devre dışı bırakıldı.';
      case 'too-many-requests':
        return 'Çok fazla başarısız deneme. Lütfen daha sonra tekrar deneyin.';
      case 'network-request-failed':
        return 'Ağ bağlantısı hatası.';
      default:
        return 'Bir hata oluştu. Lütfen tekrar deneyin.';
    }
  }

  /// Realtime Database'e veri yazma
  Future<bool> writeToDatabase({
    required String path,
    required dynamic data,
  }) async {
    try {
      await database.ref(path).set(data);
      print('Database\'e veri yazıldı: $path');
      return true;
    } catch (e) {
      print('Database yazma hatası: $e');
      return false;
    }
  }

  /// Realtime Database'den veri okuma
  Future<dynamic> readFromDatabase({required String path}) async {
    try {
      DatabaseEvent event = await database.ref(path).once();
      print('Database\'den veri okundu: $path');
      return event.snapshot.value;
    } catch (e) {
      print('Database okuma hatası: $e');
      return null;
    }
  }

  /// Database'den veri silme
  Future<bool> deleteFromDatabase({required String path}) async {
    try {
      await database.ref(path).remove();
      print('Database\'den veri silindi: $path');
      return true;
    } catch (e) {
      print('Database silme hatası: $e');
      return false;
    }
  }

  /// Database'i dinleme (realtime updates)
  Stream<DatabaseEvent> listenToDatabase({required String path}) {
    return database.ref(path).onValue;
  }

  /// Bağlantıyı test etme
  Future<bool> testConnection() async {
    try {
      // Database bağlantısını test et
      await database.ref('test').child('connection').set({
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'status': 'connected'
      });
      print('Firebase Database bağlantısı başarılı');
      return true;
    } catch (e) {
      print('Firebase Database bağlantı testi başarısız: $e');
      return false;
    }
  }

  /// Kullanıcı profil bilgilerini al
  Future<Map<String, dynamic>?> getUserProfile({String? userId}) async {
    try {
      final uid = userId ?? currentUser?.uid;
      if (uid == null) return null;

      final data = await readFromDatabase(path: 'users/$uid');
      if (data != null) {
        return Map<String, dynamic>.from(data);
      }
      return null;
    } catch (e) {
      print('Kullanıcı profil alma hatası: $e');
      return null;
    }
  }

  /// Kullanıcı adını güncelle
  Future<bool> updateUserName({required String newName}) async {
    try {
      final user = currentUser;
      if (user == null) return false;

      // Firebase Auth'ta güncelle
      await user.updateDisplayName(newName.trim());

      // Database'de güncelle
      return await writeToDatabase(
        path: 'users/${user.uid}/name',
        data: newName.trim(),
      );
    } catch (e) {
      print('Kullanıcı adı güncelleme hatası: $e');
      return false;
    }
  }

  /// Dispose işlemleri
  void dispose() {
    _database = null;
    _auth = null;
  }
}
