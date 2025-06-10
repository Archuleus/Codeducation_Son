import 'package:flutter/material.dart';
import 'dart:math' as math;

class EduHappy extends StatefulWidget {
  final double width;
  final double height;

  const EduHappy({
    Key? key,
    this.width = 160,
    this.height = 180,
  }) : super(key: key);

  @override
  _EduHappyState createState() => _EduHappyState();
}

class _EduHappyState extends State<EduHappy> with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _clapController;
  late AnimationController _sparkleController;
  late AnimationController _celebrationController;
  late AnimationController _eyeShineController;

  late Animation<double> _bounceAnimation;
  late Animation<double> _clapAnimation;
  late Animation<double> _sparkleAnimation;
  late Animation<double> _celebrationAnimation;
  late Animation<double> _eyeShineAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startCelebration();
  }

  void _initAnimations() {
    // Zıplama animasyonu
    _bounceController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(
      begin: -15.0,
      end: 15.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.bounceInOut,
    ));

    // Alkış animasyonu
    _clapController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    )..repeat(reverse: true);

    _clapAnimation = Tween<double>(
      begin: -25.0,
      end: 25.0,
    ).animate(CurvedAnimation(
      parent: _clapController,
      curve: Curves.easeInOut,
    ));

    // Işıltı animasyonu
    _sparkleController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    _sparkleAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(_sparkleController);

    // Kutlama animasyonu
    _celebrationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _celebrationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_celebrationController);

    // Göz parıltısı
    _eyeShineController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _eyeShineAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _eyeShineController,
      curve: Curves.easeInOut,
    ));
  }

  void _startCelebration() {
    _bounceController.forward();
    _clapController.forward();
    _sparkleController.forward();
    _celebrationController.forward();
    _eyeShineController.forward();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _clapController.dispose();
    _sparkleController.dispose();
    _celebrationController.dispose();
    _eyeShineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _bounceAnimation.value),
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Kutlama efektleri
              _buildCelebrationEffects(),
              // Ana robot gövdesi
              _buildRobotBody(),
              // Alkış yapan kollar
              _buildClappingArms(),
              // WiFi şapkası (daha parlak)
              _buildHappyWifiHat(),
              // Işıltılar
              _buildSparkles(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCelebrationEffects() {
    return AnimatedBuilder(
      animation: _celebrationAnimation,
      builder: (context, child) => Stack(
        children: [
          // Konfeti efekti
          ...List.generate(8, (index) {
            final angle = (index * math.pi * 2) / 8;
            final radius = 80 + (_celebrationAnimation.value * 20);
            return Positioned(
              left: widget.width/2 + math.cos(angle + _celebrationAnimation.value * 2) * radius,
              top: widget.height/2 + math.sin(angle + _celebrationAnimation.value * 2) * radius,
              child: Transform.rotate(
                angle: _celebrationAnimation.value * 4,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: [
                      Colors.yellow,
                      Colors.pink,
                      Color(0xFF10B981),
                      Color(0xFF60A5FA),
                      Colors.orange,
                    ][index % 5],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRobotBody() {
    return Positioned(
      top: 25,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHappyHead(),
          SizedBox(height: 8),
          _buildExcitedTorso(),
          SizedBox(height: 6),
          _buildBouncyBase(),
        ],
      ),
    );
  }

  Widget _buildHappyHead() {
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
            color: Color(0xFF10B981).withOpacity(0.6),
            blurRadius: 20,
            offset: Offset(0, 6),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(-3, -3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Saç detayları (daha dinamik)
          _buildDancingHair(),
          // Yüz özellikleri
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 8),
              _buildJoyfulEyes(),
              SizedBox(height: 8),
              _buildBigHappySmile(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDancingHair() {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) => Positioned(
        top: 4,
        left: 0,
        right: 0,
        child: Container(
          height: 20,
          child: Stack(
            children: [
              // Sol saç tutamı (dans ediyor)
              Positioned(
                left: 12,
                top: math.sin(_bounceAnimation.value * 0.1) * 2,
                child: Transform.rotate(
                  angle: -0.3 + (math.sin(_bounceAnimation.value * 0.05) * 0.2),
                  child: Container(
                    width: 16,
                    height: 6,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF3B82F6)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              // Orta saç tutamı
              Positioned(
                left: 40,
                top: -1 + math.cos(_bounceAnimation.value * 0.08) * 1.5,
                child: Container(
                  width: 16,
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF3B82F6)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              // Sağ saç tutamı
              Positioned(
                right: 12,
                top: math.sin(_bounceAnimation.value * 0.12) * 2,
                child: Transform.rotate(
                  angle: 0.3 + (math.cos(_bounceAnimation.value * 0.05) * 0.2),
                  child: Container(
                    width: 16,
                    height: 6,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF3B82F6)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJoyfulEyes() {
    return AnimatedBuilder(
      animation: _eyeShineAnimation,
      builder: (context, child) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSparklingEye(),
          SizedBox(width: 16),
          _buildSparklingEye(),
        ],
      ),
    );
  }

  Widget _buildSparklingEye() {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Color(0xFF10B981), width: 2),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF10B981).withOpacity(_eyeShineAnimation.value),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ana göz bebeği (mutlu)
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0xFF10B981), Color(0xFF3B82F6), Color(0xFF60A5FA)],
                stops: [0.3, 0.7, 1.0],
              ),
              shape: BoxShape.circle,
            ),
          ),
          // Çoklu parlak ışık yansımaları
          Positioned(
            top: 2,
            right: 2,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 3,
            left: 3,
            child: Container(
              width: 2,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Mutluluk kıvılcımı
          AnimatedBuilder(
            animation: _sparkleAnimation,
            builder: (context, child) => Positioned(
              top: 1 + math.sin(_sparkleAnimation.value) * 1,
              left: 1 + math.cos(_sparkleAnimation.value) * 1,
              child: Container(
                width: 1,
                height: 1,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBigHappySmile() {
    return Container(
      width: 40,
      height: 20,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade50],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF10B981).withOpacity(0.3),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 28,
          height: 4,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF60A5FA)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildHappyWifiHat() {
    return Positioned(
      top: 0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Şapka tabanı (daha parlak)
          Container(
            width: 110,
            height: 22,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF3B82F6)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF10B981).withOpacity(0.4),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          // Kutlama WiFi sinyali
          Positioned(
            top: 2,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCelebrationWifiSignal(8, Color(0xFF10B981)),
                SizedBox(width: 2),
                _buildCelebrationWifiSignal(12, Color(0xFF10B981)),
                SizedBox(width: 2),
                _buildCelebrationWifiSignal(16, Color(0xFF10B981)),
                SizedBox(width: 6),
                // Parlayan WiFi ikonu
                AnimatedBuilder(
                  animation: _eyeShineAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: _eyeShineAnimation.value * 0.8 + 0.6,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [Colors.yellow, Color(0xFF60A5FA)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow.withOpacity(0.8),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 6),
                _buildCelebrationWifiSignal(16, Color(0xFF10B981)),
                SizedBox(width: 2),
                _buildCelebrationWifiSignal(12, Color(0xFF10B981)),
                SizedBox(width: 2),
                _buildCelebrationWifiSignal(8, Color(0xFF10B981)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCelebrationWifiSignal(double height, Color color) {
    return AnimatedBuilder(
      animation: _eyeShineAnimation,
      builder: (context, child) => Container(
        width: 3,
        height: height * _eyeShineAnimation.value,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.5), Colors.yellow, color],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExcitedTorso() {
    return Container(
      width: 75,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF10B981),
            Color(0xFF3B82F6),
            Color(0xFF2563EB),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF10B981).withOpacity(0.6),
            blurRadius: 15,
            offset: Offset(0, 5),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSuccessDisplay(),
          SizedBox(height: 6),
          _buildPartyButtons(),
        ],
      ),
    );
  }

  Widget _buildSuccessDisplay() {
    return Container(
      width: 50,
      height: 25,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Color(0xFF10B981), width: 2),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF10B981).withOpacity(0.5),
            blurRadius: 6,
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _celebrationAnimation,
        builder: (context, child) => Stack(
          children: [
            // Başarı sembolü
            Center(
              child: Text(
                '✓',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Parlayan kenar efekti
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.yellow.withOpacity(
                        0.5 + 0.5 * math.sin(_celebrationAnimation.value * 4)
                    ),
                    width: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartyButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPartyButton(Color(0xFF10B981)),
        _buildPartyButton(Colors.yellow),
        _buildPartyButton(Colors.orange),
      ],
    );
  }

  Widget _buildPartyButton(Color color) {
    return AnimatedBuilder(
      animation: _eyeShineAnimation,
      builder: (context, child) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(_eyeShineAnimation.value),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBouncyBase() {
    return Container(
      width: 60,
      height: 12,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF2563EB)],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF10B981).withOpacity(0.4),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
    );
  }

  Widget _buildClappingArms() {
    return Stack(
      children: [
        // Sol kol - Alkış
        AnimatedBuilder(
          animation: _clapAnimation,
          builder: (context, child) => Positioned(
            left: 15 + _clapAnimation.value,
            top: 100,
            child: Transform.rotate(
              angle: -0.5 + (_clapAnimation.value * 0.02),
              child: _buildClappingArm(),
            ),
          ),
        ),
        // Sağ kol - Alkış
        AnimatedBuilder(
          animation: _clapAnimation,
          builder: (context, child) => Positioned(
            right: 15 - _clapAnimation.value,
            top: 100,
            child: Transform.rotate(
              angle: 0.5 - (_clapAnimation.value * 0.02),
              child: _buildClappingArm(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClappingArm() {
    return Column(
      children: [
        // Kol
        Container(
          width: 16,
          height: 28,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF3B82F6)],
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF10B981).withOpacity(0.4),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        SizedBox(height: 2),
        // El
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF10B981), Color(0xFF60A5FA)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.yellow.withOpacity(0.6),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSparkles() {
    return AnimatedBuilder(
      animation: _sparkleAnimation,
      builder: (context, child) => Stack(
        children: List.generate(12, (index) {
          final angle = (index * math.pi * 2) / 12 + _sparkleAnimation.value;
          final radius = 60 + (index % 3) * 15;
          final sparkleSize = 2.0 + (index % 3);

          return Positioned(
            left: widget.width/2 + math.cos(angle) * radius,
            top: widget.height/2 + math.sin(angle) * radius,
            child: Transform.rotate(
              angle: _sparkleAnimation.value * 2,
              child: Container(
                width: sparkleSize,
                height: sparkleSize,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.yellow,
                      [Colors.pink, Color(0xFF10B981), Colors.orange][index % 3],
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.yellow.withOpacity(0.6),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}