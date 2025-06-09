import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Database/firebase_connect.dart';
import '../Edu/edu_build.dart';



class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  bool isLogin = true;
  bool isTurkish = true;
  bool rememberMe = false;

  late AnimationController _formController;
  late AnimationController _backgroundController;

  late Animation<Offset> _formAnimation;
  late Animation<double> _backgroundAnimation;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // Firebase connection instance
  final FlutterConnection _firebaseConnection = FlutterConnection.instance;

  // Dil değiştirme limiti için
  DateTime? _lastLanguageChange;
  static const Duration _languageChangeLimit = Duration(seconds: 15);

  // Consolidated translations
  static const Map<String, Map<String, String>> _translations = {
    'tr': {
      'welcomeBack': 'Tekrar Hoş Geldin!', 'joinFun': 'Eğlenceye Katıl!',
      'eduMissed': 'Edu seni özledi! Öğrenmeye devam edelim!', 'startJourney': 'Harika öğrenme yolculuğuna başlayalım!',
      'yourName': 'Adın', 'email': 'E-posta', 'password': 'Şifre', 'rememberMe': 'Hesabımı açık tut',
      'letsLearn': 'Hadi Öğrenelim!', 'startAdventure': 'Maceraya Başla!', 'loading': 'Yükleniyor...',
      'noAccount': 'Hesabın yok mu? ', 'haveAccount': 'Zaten hesabın var mı? ', 'signUp': 'Kayıt Ol', 'signIn': 'Giriş Yap',
      'enterName': 'Lütfen adını gir', 'enterEmail': 'Lütfen e-postanı gir', 'validEmail': 'Lütfen geçerli bir e-posta gir',
      'enterPassword': 'Lütfen şifreni gir', 'passwordLength': 'Şifre en az 6 karakter olmalı',
      'welcomeBackMsg': 'Tekrar hoş geldin!', 'accountCreated': 'Hesap başarıyla oluşturuldu!',
      'languageChangeLimit': 'Dil değiştirmek için lütfen bekleyin...',
      'authError': 'Kimlik doğrulama hatası',
      'connectionError': 'Bağlantı hatası. İnternet bağlantınızı kontrol edin.',
    },
    'en': {
      'welcomeBack': 'Welcome Back!', 'joinFun': 'Join the Fun!',
      'eduMissed': 'Edu missed you! Let\'s continue learning!', 'startJourney': 'Let\'s start your amazing learning journey!',
      'yourName': 'Your Name', 'email': 'Email', 'password': 'Password', 'rememberMe': 'Remember me',
      'letsLearn': 'Let\'s Learn!', 'startAdventure': 'Start Adventure!', 'loading': 'Loading...',
      'noAccount': 'Don\'t have an account? ', 'haveAccount': 'Already have an account? ', 'signUp': 'Sign Up', 'signIn': 'Sign In',
      'enterName': 'Please enter your name', 'enterEmail': 'Please enter your email', 'validEmail': 'Please enter a valid email',
      'enterPassword': 'Please enter your password', 'passwordLength': 'Password must be at least 6 characters',
      'welcomeBackMsg': 'Welcome back!', 'accountCreated': 'Account created successfully!',
      'languageChangeLimit': 'Please wait to change language...',
      'authError': 'Authentication error',
      'connectionError': 'Connection error. Please check your internet connection.',
    },
  };

  String _getText(String key) => _translations[isTurkish ? 'tr' : 'en']?[key] ?? key;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _checkAuthState();
  }

  void _initAnimations() {
    // Background animation
    _backgroundController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_backgroundController);

    // Form slide animation
    _formController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _formAnimation = Tween<Offset>(
      begin: Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _formController,
      curve: Curves.easeOutCubic,
    ));

    _formController.forward();
  }

  // AuthScreen sınıfınızda _checkAuthState metodunu bu şekilde güncelleyin:

  void _checkAuthState() {
    try {
      // Firebase'in başlatıldığından emin ol
      if (!_firebaseConnection.isFirebaseConnected) {
        print('Firebase henüz başlatılmamış, auth kontrolü atlanıyor');
        return;
      }

      if (_firebaseConnection.isUserSignedIn) {
        // Kullanıcı zaten giriş yapmış, ana sayfaya yönlendir
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigateToHome();
        });
      }
    } catch (e) {
      print('Auth state kontrol hatası: $e');
      // Hata durumunda kullanıcıyı login ekranında tut
    }
  }

// Ayrıca _navigateToHome metodunu da güncelleyin:
  void _navigateToHome() {
    try {
      // Ana sayfaya yönlendirme kodunuz buraya gelecek
      // Örnek: Navigator.pushReplacementNamed(context, '/home');
      print('Kullanıcı zaten giriş yapmış, ana sayfaya yönlendiriliyor...');

      // Geçici olarak bir mesaj göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Zaten giriş yapmışsınız! Ana sayfaya yönlendiriliyorsunuz...'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Home yönlendirme hatası: $e');
    }
  }


  @override
  void dispose() {
    [_formController, _backgroundController].forEach((c) => c.dispose());
    [_emailController, _passwordController, _nameController].forEach((c) => c.dispose());
    super.dispose();
  }

  bool _canChangeLanguage() {
    if (_lastLanguageChange == null) return true;
    return DateTime.now().difference(_lastLanguageChange!) >= _languageChangeLimit;
  }

  void _toggleLanguage() {
    if (!_canChangeLanguage()) {
      _showSnackBar(_getText('languageChangeLimit'), Colors.orange);
      return;
    }

    setState(() {
      isTurkish = !isTurkish;
      _lastLanguageChange = DateTime.now();
    });

    _formController.reset();
    _formController.forward();
  }

  void _toggleAuthMode() {
    setState(() => isLogin = !isLogin);
    _restartFormAnimation();
    _clearForm();
  }

  void _restartFormAnimation() {
    _formController.reset();
    _formController.forward();
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    [_emailController, _passwordController, _nameController].forEach((c) => c.clear());
    setState(() => rememberMe = false);
  }

  // Firebase Authentication işlemleri
  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();

    try {
      if (isLogin) {
        await _signIn();
      } else {
        await _signUp();
      }
    } catch (e) {
      _showSnackBar(_getText('connectionError'), Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signIn() async {
    final result = await _firebaseConnection.signInWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (result['success']) {
      _showSuccessMessage(result['message']);
      // Başarılı giriş sonrası ana sayfaya yönlendir
      await Future.delayed(Duration(seconds: 1));
      _navigateToHome();
    } else {
      _showSnackBar(result['message'], Colors.red);
    }
  }

  Future<void> _signUp() async {
    final result = await _firebaseConnection.signUpWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : null,
    );

    if (result['success']) {
      _showSuccessMessage(result['message']);
      // Başarılı kayıt sonrası ana sayfaya yönlendir
      await Future.delayed(Duration(seconds: 1));
      _navigateToHome();
    } else {
      _showSnackBar(result['message'], Colors.red);
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.celebration, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) => Container(
          decoration: BoxDecoration(gradient: _buildBackgroundGradient()),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        _buildLanguageToggle(),
                        SizedBox(height: 20),
                        EduMascot(),
                        SizedBox(height: 30),
                        _buildWelcomeText(),
                        SizedBox(height: 40),
                        _buildFormCard(),
                        Spacer(),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Modern gri-siyah gradient arka plan
  LinearGradient _buildBackgroundGradient() {
    final gradientStops = [
      // Koyu gri tonları
      [Color(0xFF1a1a1a), Color(0xFF2d2d2d)],
      [Color(0xFF2d2d2d), Color(0xFF1e1e1e)],
      [Color(0xFF1e1e1e), Color(0xFF252525)],
      [Color(0xFF252525), Color(0xFF1a1a1a)],
    ];

    final currentPair = gradientStops[(_backgroundAnimation.value * gradientStops.length).floor() % gradientStops.length];

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.lerp(currentPair[0], currentPair[1], _backgroundAnimation.value * 0.3)!,
        Color.lerp(currentPair[1], currentPair[0], _backgroundAnimation.value * 0.3)!,
        Color(0xFF1a1a1a),
      ],
      stops: [0.0, 0.5, 1.0],
    );
  }

  Widget _buildLanguageToggle() {
    bool canChange = _canChangeLanguage();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: _toggleLanguage,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 2)
                )
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAnimatedText(isTurkish ? '🇹🇷' : '🇺🇸', ValueKey(isTurkish), TextStyle(fontSize: 18)),
                SizedBox(width: 8),
                _buildAnimatedText(
                    isTurkish ? 'TR' : 'EN',
                    ValueKey('${isTurkish}_text'),
                    TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        letterSpacing: 0.5
                    )
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedText(String text, Key key, TextStyle style) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: Text(text, key: key, style: style),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        _buildAnimatedWelcomeTitle(),
        SizedBox(height: 8),
        _buildAnimatedWelcomeSubtitle(),
      ],
    );
  }

  Widget _buildAnimatedWelcomeTitle() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: Text(
        isLogin ? _getText('welcomeBack') : _getText('joinFun'),
        key: ValueKey('${isLogin}_${isTurkish}_title'),
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(offset: Offset(2, 2), blurRadius: 4, color: Colors.black45)],
        ),
      ),
    );
  }

  Widget _buildAnimatedWelcomeSubtitle() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: Text(
        isLogin ? _getText('eduMissed') : _getText('startJourney'),
        key: ValueKey('${isLogin}_${isTurkish}_subtitle'),
        style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w400
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Modern glassmorphism container tasarımı
  Widget _buildFormCard() {
    return SlideTransition(
      position: _formAnimation,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(28),
        decoration: BoxDecoration(
          // Glassmorphism efekti
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.05),
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (!isLogin) ...[_buildNameField(), SizedBox(height: 20)],
                  _buildEmailField(),
                  SizedBox(height: 20),
                  _buildPasswordField(),
                  SizedBox(height: 20),
                  if (isLogin) ...[_buildRememberMeCheckbox(), SizedBox(height: 12)],
                  SizedBox(height: 24),
                  _buildSubmitButton(),
                  SizedBox(height: 20),
                  _buildToggleButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() => _buildTextField(
    controller: _nameController,
    label: _getText('yourName'),
    icon: Icons.person_outline,
    textCapitalization: TextCapitalization.words,
    validator: (value) => (value?.isEmpty ?? true) ? _getText('enterName') : null,
  );

  Widget _buildEmailField() => _buildTextField(
    controller: _emailController,
    label: _getText('email'),
    icon: Icons.email_outlined,
    keyboardType: TextInputType.emailAddress,
    validator: (value) {
      if (value?.isEmpty ?? true) return _getText('enterEmail');
      if (!value!.contains('@')) return _getText('validEmail');
      return null;
    },
  );

  Widget _buildPasswordField() => _buildTextField(
    controller: _passwordController,
    label: _getText('password'),
    icon: Icons.lock_outline,
    isPassword: true,
    validator: (value) {
      if (value?.isEmpty ?? true) return _getText('enterPassword');
      if (!isLogin && value!.length < 6) return _getText('passwordLength');
      return null;
    },
  );

  Widget _buildRememberMeCheckbox() {
    return Row(
      children: [
        AnimatedScale(
          scale: rememberMe ? 1.1 : 1.0,
          duration: Duration(milliseconds: 200),
          child: Checkbox(
            value: rememberMe,
            onChanged: (value) {
              setState(() => rememberMe = value ?? false);
              HapticFeedback.selectionClick();
            },
            activeColor: Color(0xFF4F46E5),
            checkColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            side: BorderSide(color: Colors.white.withOpacity(0.5), width: 1.5),
          ),
        ),
        Text(
            _getText('rememberMe'),
            style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.w400
            )
        ),
      ],
    );
  }

  // Modern input field tasarımı
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        validator: validator,
        style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w400
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZçÇğĞıİöÖşŞüÜ0-9@._\-\s]')),
        ],
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w400
          ),
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7), size: 20),
          suffixIcon: isPassword ? _buildPasswordToggleIcon() : null,
          border: _buildInputBorder(Colors.white.withOpacity(0.2), 1),
          focusedBorder: _buildInputBorder(Color(0xFF4F46E5), 1.5),
          errorBorder: _buildInputBorder(Colors.red.withOpacity(0.8), 1.5),
          enabledBorder: _buildInputBorder(Colors.white.withOpacity(0.2), 1),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          errorStyle: TextStyle(color: Colors.red.shade300),
        ),
      ),
    );
  }

  OutlineInputBorder _buildInputBorder(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  Widget _buildPasswordToggleIcon() {
    return IconButton(
      icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: Colors.white.withOpacity(0.7),
          size: 20
      ),
      onPressed: () {
        setState(() => _isPasswordVisible = !_isPasswordVisible);
        HapticFeedback.selectionClick();
      },
    );
  }

  Widget _buildSubmitButton() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF4F46E5),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 8,
          shadowColor: Color(0xFF4F46E5).withOpacity(0.4),
          disabledBackgroundColor: Colors.grey.withOpacity(0.3),
        ),
        child: _isLoading ? _buildLoadingContent() : _buildButtonContent(),
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
          ),
        ),
        SizedBox(width: 12),
        Text(_getText('loading'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildButtonContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(isLogin ? Icons.login : Icons.person_add, size: 20),
        SizedBox(width: 8),
        Text(
          isLogin ? _getText('letsLearn') : _getText('startAdventure'),
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildToggleButton() {
    return TextButton(
      onPressed: _toggleAuthMode,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: RichText(
          key: ValueKey('${isLogin}_${isTurkish}_toggle'),
          text: TextSpan(
            style: TextStyle(fontSize: 14),
            children: [
              TextSpan(
                text: isLogin ? _getText('noAccount') : _getText('haveAccount'),
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              TextSpan(
                text: isLogin ? _getText('signUp') : _getText('signIn'),
                style: TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}