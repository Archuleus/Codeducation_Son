import 'package:flutter/material.dart';

import '../Database/firebase_connect.dart';
import 'login_screen.dart';

class DebugHomeScreen extends StatefulWidget {
  @override
  _DebugHomeScreenState createState() => _DebugHomeScreenState();
}

class _DebugHomeScreenState extends State<DebugHomeScreen> {
  final FlutterConnection _firebase = FlutterConnection.instance;
  String _debugInfo = 'Başlatılıyor...';

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  void _checkUserStatus() async {
    try {
      if (mounted) {
        setState(() {
          _debugInfo = '🔄 Kullanıcı durumu kontrol ediliyor...';
        });
      }

      final user = _firebase.currentUser;

      if (user == null) {
        if (mounted) {
          setState(() {
            _debugInfo =
                '❌ Kullanıcı bulunamadı! Login ekranına yönlendiriliyor...';
          });
        }

        await Future.delayed(Duration(seconds: 2));

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AuthScreen()),
          );
        }
        return;
      }

      if (mounted) {
        setState(() {
          _debugInfo = '✅ Kullanıcı bulundu: ${user.email}\n\n';
          _debugInfo += '📧 Email: ${user.email}\n';
          _debugInfo += '👤 Display Name: ${user.displayName}\n';
          _debugInfo += '🆔 UID: ${user.uid}\n';
          _debugInfo += '✅ Email Doğrulandı: ${user.emailVerified}\n\n';
          _debugInfo += '🔍 Firebase Database\'den veri çekiliyor...';
        });
      }

      // Database'den veri çek
      try {
        final userData =
            await _firebase.readFromDatabase(path: 'users/${user.uid}');
        if (mounted) {
          setState(() {
            _debugInfo += '\n💾 Database Verisi: $userData\n\n';
            _debugInfo += '🎉 Tüm işlemler tamamlandı!';
          });
        }
      } catch (dbError) {
        if (mounted) {
          setState(() {
            _debugInfo += '\n❌ Database hatası: $dbError\n\n';
            _debugInfo += '⚠️ Database erişimi başarısız ama giriş geçerli';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _debugInfo = '❌ Genel hata: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug Ana Sayfa'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _firebase.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AuthScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Firebase Debug Bilgileri',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _debugInfo,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _checkUserStatus,
                    child: Text('Yeniden Kontrol Et'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Çıkış yap
                      await _firebase.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AuthScreen()),
                      );
                    },
                    child: Text('Çıkış Yap'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
