import 'package:flutter/material.dart';
import 'dart:math' as math;

class EduMascot extends StatefulWidget {
  final double width;
  final double height;
  final bool isThinking;
  final bool isCelebrating;

  const EduMascot({
    Key? key,
    this.width = 160,
    this.height = 180,
    this.isThinking = false,
    this.isCelebrating = false,
  }) : super(key: key);

  @override
  _EduMascotState createState() => _EduMascotState();
}

class _EduMascotState extends State<EduMascot>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _eyeBlinkController;
  late AnimationController _pulseController;
  late AnimationController _codeStreamController;

  late Animation<double> _floatingAnimation;
  late Animation<double> _eyeBlinkAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _codeStreamAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startBlinking();
  }

  void _initAnimations() {
    // Floating animation
    _floatingController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(
      begin: -8.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    // Eye blink animation
    _eyeBlinkController = AnimationController(
      duration: Duration(milliseconds: 120),
      vsync: this,
    );

    _eyeBlinkAnimation = Tween<double>(
      begin: 1.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _eyeBlinkController,
      curve: Curves.easeOut,
    ));

    // Pulse animation
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Code stream animation
    _codeStreamController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _codeStreamAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_codeStreamController);
  }

  void _startBlinking() {
    Future.delayed(Duration(seconds: 2 + (DateTime.now().millisecond % 4)), () {
      if (mounted) {
        _eyeBlinkController.forward().then((_) {
          _eyeBlinkController.reverse().then((_) => _startBlinking());
        });
      }
    });
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _eyeBlinkController.dispose();
    _pulseController.dispose();
    _codeStreamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _floatingAnimation.value),
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Ana robot gövdesi
              _buildRobotBody(),
              // Kollar
              _buildRobotArms(),
              // WiFi şapkası
              _buildWifiHat(),
              // Kod akışları
              _buildCodeStreams(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRobotBody() {
    return Positioned(
      top: 25,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCharismaticHead(),
          SizedBox(height: 8),
          _buildSmartTorso(),
          SizedBox(height: 6),
          _buildRobotBase(),
        ],
      ),
    );
  }

  Widget _buildCharismaticHead() {
    return Container(
      width: 100,
      height: 85,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF60A5FA),
            Color(0xFF3B82F6),
            Color(0xFF2563EB),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF3B82F6).withOpacity(0.4),
            blurRadius: 15,
            offset: Offset(0, 6),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(-3, -3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Saç detayları
          _buildHairDetails(),
          // Yüz özellikleri
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 8),
              _buildCoolEyes(),
              SizedBox(height: 10),
              _buildConfidentSmile(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHairDetails() {
    return Positioned(
      top: 4,
      left: 0,
      right: 0,
      child: Container(
        height: 20,
        child: Stack(
          children: [
            // Sol saç tutamı
            Positioned(
              left: 12,
              top: 0,
              child: Transform.rotate(
                angle: -0.3,
                child: Container(
                  width: 16,
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            // Orta saç tutamı
            Positioned(
              left: 40,
              top: -1,
              child: Container(
                width: 16,
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            // Sağ saç tutamı
            Positioned(
              right: 12,
              top: 0,
              child: Transform.rotate(
                angle: 0.3,
                child: Container(
                  width: 16,
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoolEyes() {
    return AnimatedBuilder(
      animation: _eyeBlinkAnimation,
      builder: (context, child) => Transform.scale(
        scaleY: _eyeBlinkAnimation.value,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCharismaticEye(),
            SizedBox(width: 16),
            _buildCharismaticEye(),
          ],
        ),
      ),
    );
  }

  Widget _buildCharismaticEye() {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Color(0xFF1E40AF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF60A5FA).withOpacity(0.5),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ana göz bebeği
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0xFF1E40AF), Color(0xFF3B82F6), Color(0xFF60A5FA)],
                stops: [0.3, 0.7, 1.0],
              ),
              shape: BoxShape.circle,
            ),
          ),
          // Parlak ışık yansıması
          Positioned(
            top: 3,
            right: 3,
            child: Container(
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Küçük ışık noktası
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              width: 1.5,
              height: 1.5,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidentSmile() {
    return Container(
      width: 30,
      height: 15,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade50],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 20,
          height: 2.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
            ),
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildWifiHat() {
    return Positioned(
      top: 0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Şapka tabanı
          Container(
            width: 110,
            height: 22,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
          ),
          // WiFi sinyali
          Positioned(
            top: 2,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildWifiSignal(6, Color(0xFF10B981)),
                SizedBox(width: 2),
                _buildWifiSignal(10, Color(0xFF10B981)),
                SizedBox(width: 2),
                _buildWifiSignal(14, Color(0xFF10B981)),
                SizedBox(width: 6),
                // WiFi ikonu ortada
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: _pulseAnimation.value * 0.6 + 0.4,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [Colors.white, Color(0xFF60A5FA)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.6),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 6),
                _buildWifiSignal(14, Color(0xFF10B981)),
                SizedBox(width: 2),
                _buildWifiSignal(10, Color(0xFF10B981)),
                SizedBox(width: 2),
                _buildWifiSignal(6, Color(0xFF10B981)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWifiSignal(double height, Color color) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) => Container(
        width: 3,
        height: height * _pulseAnimation.value,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.5), color],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(1.5),
        ),
      ),
    );
  }

  Widget _buildSmartTorso() {
    return Container(
      width: 75,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF3B82F6),
            Color(0xFF2563EB),
            Color(0xFF1E40AF),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1E40AF).withOpacity(0.4),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCodeDisplay(),
          SizedBox(height: 6),
          _buildControlButtons(),
        ],
      ),
    );
  }

  Widget _buildCodeDisplay() {
    return Container(
      width: 50,
      height: 25,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Color(0xFF10B981), width: 1),
      ),
      child: AnimatedBuilder(
        animation: _codeStreamAnimation,
        builder: (context, child) => Stack(
          children: [
            // Kod metni simülasyonu
            Positioned(
              left: 3,
              top: 2,
              child: Text(
                '</>',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Alt satır
            Positioned(
              left: 3,
              bottom: 2,
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 1.5,
                    decoration: BoxDecoration(
                      color: Color(0xFF60A5FA),
                      borderRadius: BorderRadius.circular(0.5),
                    ),
                  ),
                  SizedBox(width: 1.5),
                  Container(
                    width: 10,
                    height: 1.5,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(0.5),
                    ),
                  ),
                ],
              ),
            ),
            // Cursor animasyonu
            Positioned(
              right: 3 + (_codeStreamAnimation.value * 8),
              top: 6,
              child: Container(
                width: 0.8,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton(Color(0xFF10B981)), // Yeşil
        _buildControlButton(Colors.orange),      // Turuncu
        _buildControlButton(Colors.red),         // Kırmızı
      ],
    );
  }

  Widget _buildControlButton(Color color) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(_pulseAnimation.value * 0.5),
              blurRadius: 3,
              spreadRadius: 0.5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRobotBase() {
    return Container(
      width: 60,
      height: 12,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
    );
  }

  Widget _buildRobotArms() {
    return Stack(
      children: [
        // Sol kol - Laptop tutuyor
        Positioned(
          left: 10,
          top: 110,
          child: _buildArmWithLaptop(),
        ),
        // Sağ kol - Normal
        Positioned(
          right: 10,
          top: 110,
          child: _buildNormalArm(),
        ),
      ],
    );
  }

  Widget _buildArmWithLaptop() {
    return Transform.rotate(
      angle: -0.2,
      child: Column(
        children: [
          // Kol
          Container(
            width: 16,
            height: 28,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(height: 1.5),
          // Laptop
          Container(
            width: 20,
            height: 16,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.shade300, Colors.grey.shade400],
              ),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Center(
              child: Container(
                width: 16,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(1.5),
                ),
                child: Center(
                  child: Text(
                    '💻',
                    style: TextStyle(fontSize: 6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalArm() {
    return Transform.rotate(
      angle: 0.1,
      child: Container(
        width: 16,
        height: 28,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF1E40AF).withOpacity(0.3),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeStreams() {
    return AnimatedBuilder(
      animation: _codeStreamAnimation,
      builder: (context, child) => Stack(
        children: [
          // Sol kod akışı
          Positioned(
            left: 0,
            top: 70 + (_codeStreamAnimation.value * 50),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                'if()',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Sağ kod akışı
          Positioned(
            right: 0,
            top: 85 + (_codeStreamAnimation.value * 35),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                '{}',
                style: TextStyle(
                  color: Color(0xFF60A5FA),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Üst kod akışı
          Positioned(
            left: 70,
            top: 45 + (_codeStreamAnimation.value * 15),
            child: Opacity(
              opacity: 0.5,
              child: Text(
                'fun()',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}