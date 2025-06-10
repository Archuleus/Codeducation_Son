import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Database/firebase_connect.dart'; // Kendi dosya yolunuzu ayarlayın
import 'Screen/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  // Flutter binding'lerinin başlatılması
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Firebase'i başlat
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase başarıyla başlatıldı');

    // FlutterConnection initialize fonksiyonunu çağır
    await FlutterConnection.initializeFirebase();

    runApp(MyApp());
  } catch (e) {
    print('Firebase başlatma hatası: $e');
    // Hata durumunda da uygulamayı çalıştır
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edu App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        // Firebase başlatma durumunu kontrol et
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          // Firebase başlatılıyor
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Firebase başlatılıyor...'),
                  ],
                ),
              ),
            );
          }

          // Firebase başlatma hatası
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, color: Colors.red, size: 50),
                    SizedBox(height: 20),
                    Text('Firebase başlatma hatası: ${snapshot.error}'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Uygulamayı yeniden başlat
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp()),
                        );
                      },
                      child: Text('Tekrar Dene'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Firebase başarıyla başlatıldı
          return AuthScreen();
        },
      ),
    );
  }
}
