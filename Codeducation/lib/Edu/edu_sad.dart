import 'package:flutter/material.dart';
import 'dart:math' as math;

class EduUpset extends StatefulWidget {
  final double width;
  final double height;

  const EduUpset({
    Key? key,
    this.width = 160,
    this.height = 180,
  }) : super(key: key);

  @override
  _EduUpsetState createState() => _EduUpsetState();
}

class _EduUpsetState extends State<EduUpset> with TickerProviderStateMixin {
  late AnimationController _trembleController;
  late AnimationController _tearController;
  late AnimationController _sigillController;
  late AnimationController _sadnessController;
  late AnimationController _droopController;

  late Animation<double> _trembleAnimation;
  late Animation<double> _tearAnimation;
  late Animation<double> _sigillAnimation;
  late Animation<double> _sadnessAnimation;
  late Animation<double> _droopAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startSadness();
  }

  void _initAnimations() {
    // Titreme animasyonu
    _trembleController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    )..repeat(reverse: true);

    _trembleAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _trembleController,
      curve: Curves.easeInOut,
    ));

    // Gözyaşı animasyonu
    _tearController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _tearAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _tearController,
      curve: Curves.easeInOut,
    ));

    // İç çekme animasyonu
    _sigillController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _sigillAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _sigillController,
      curve: Curves.easeInOut,
    ));

    // Üzüntü animasyonu
    _sadnessController = AnimationController(
      duration: Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();

    _sadnessAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(_sadnessController);

    // Çökmüş duruş animasyonu
    _droopController = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);

    _droopAnimation = Tween<double>(
      begin: 0.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _droopController,
      curve: Curves.easeInOut,
    ));
  }

  void _startSadness() {
    _trembleController.forward();
    _tearController.forward();
    _sigillController.forward();
    _sadnessController.forward();
    _droopController.forward();
  }

  @override
  void dispose() {
    _trembleController.dispose();
    _tearController.dispose();
    _sigillController.dispose();
    _sadnessController.dispose();
    _droopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _trembleAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(_trembleAnimation.value, 0),
        child: AnimatedBuilder(
          animation: _droopAnimation,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, _droopAnimation.value),
            child: SizedBox(
              width: widget.width,
              height: widget.height,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Üzüntü efektleri
                  _buildSadnessEffects(),
                  // Ana robot gövdesi
                  _buildRobotBody(),
                  // Üzgün kollar
                  _buildSadArms(),
                  // Söndürülmüş WiFi şapkası
                  _buildSadWifiHat(),
                  // Gözyaşları
                  _buildTears(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSadnessEffects() {
    return AnimatedBuilder(
      animation: _sadnessAnimation,
      builder: (context, child) => Stack(
        children: [
          // Üzüntü bulutu efekti
          ...List.generate(6, (index) {
            final angle = (index * math.pi * 2) / 6;
            final radius = 70 + math.sin(_sadnessAnimation.value + index) * 10;
            return Positioned(
              left: widget.width/2 + math.cos(angle + _sadnessAnimation.value * 0.3) * radius,
              top: widget.height/2 + math.sin(angle + _sadnessAnimation.value * 0.3) * radius,
              child: Opacity(
                opacity: 0.3 + 0.2 * math.sin(_sadnessAnimation.value * 2 + index),
                child: Container(
                  width: 8 + (index % 3) * 2,
                  height: 8 + (index % 3) * 2,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
          // Yağmur damlacıkları
          ...List.generate(4, (index) {
            return Positioned(
              left: 20 + index * 30,
              top: 40 + (_sadnessAnimation.value * 60) % 120,
              child: Opacity(
                opacity: 0.4,
                child: Container(
                  width: 3,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    borderRadius: BorderRadius.circular(2),
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
          _buildSadHead(),
          SizedBox(height: 8),
          _buildDepressedTorso(),
          SizedBox(height: 6),
          _buildSlumpedBase(),
        ],
      ),
    );
  }

  Widget _buildSadHead() {
    return AnimatedBuilder(
      animation: _sigillAnimation,
      builder: (context, child) => Transform.scale(
        scale: _sigillAnimation.value,
        child: Container(
          width: 100,
          height: 85,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF94A3B8),
                Color(0xFF64748B),
                Color(0xFF475569),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade600.withOpacity(0.4),
                blurRadius: 15,
                offset: Offset(0, 8),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Üzgün saç detayları
              _buildDroopyHair(),
              // Yüz özellikleri
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 8),
                  _buildSadEyes(),
                  SizedBox(height: 12),
                  _buildFrown(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDroopyHair() {
    return AnimatedBuilder(
      animation: _droopAnimation,
      builder: (context, child) => Positioned(
        top: 4,
        left: 0,
        right: 0,
        child: Container(
          height: 20,
          child: Stack(
            children: [
              // Sol saç tutamı (sarkık)
              Positioned(
                left: 12,
                top: 2 + _droopAnimation.value * 0.3,
                child: Transform.rotate(
                  angle: -0.6 - (_droopAnimation.value * 0.02),
                  child: Container(
                    width: 16,
                    height: 6,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF475569), Color(0xFF64748B)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              // Orta saç tutamı (aşağı düşük)
              Positioned(
                left: 40,
                top: 1 + _droopAnimation.value * 0.2,
                child: Container(
                  width: 16,
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF475569), Color(0xFF64748B)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              // Sağ saç tutamı (sarkık)
              Positioned(
                right: 12,
                top: 2 + _droopAnimation.value * 0.3,
                child: Transform.rotate(
                  angle: 0.6 + (_droopAnimation.value * 0.02),
                  child: Container(
                    width: 16,
                    height: 6,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF475569), Color(0xFF64748B)],
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

  Widget _buildSadEyes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCryingEye(),
        SizedBox(width: 16),
        _buildCryingEye(),
      ],
    );
  }

  Widget _buildCryingEye() {
    return AnimatedBuilder(
      animation: _tearAnimation,
      builder: (context, child) => Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Color(0xFF475569), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400.withOpacity(0.5),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Üzgün göz bebeği
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [Color(0xFF475569), Color(0xFF64748B), Color(0xFF94A3B8)],
                  stops: [0.3, 0.7, 1.0],
                ),
                shape: BoxShape.circle,
              ),
            ),
            // Solgun ışık yansıması
            Positioned(
              top: 3,
              right: 3,
              child: Container(
                width: 2,
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Göz kapağı efekti (yarı kapalı)
            Positioned(
              top: 0,
              child: Container(
                width: 18,
                height: 6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF64748B).withOpacity(0.3),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(9),
                    topRight: Radius.circular(9),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrown() {
    return Container(
      width: 35,
      height: 18,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade100],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Transform.rotate(
          angle: math.pi, // Ters çevrilmiş gülümseme (üzgün)
          child: Container(
            width: 22,
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF64748B), Color(0xFF94A3B8)],
              ),
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSadWifiHat() {
    return Positioned(
      top: 0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Söndürülmüş şapka tabanı
          Container(
            width: 110,
            height: 22,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF475569), Color(0xFF64748B)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),
          // Zayıf WiFi sinyali
          Positioned(
            top: 2,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildWeakWifiSignal(4, Colors.red.shade300),
                SizedBox(width: 2),
                _buildWeakWifiSignal(6, Colors.red.shade400),
                SizedBox(width: 2),
                _buildWeakWifiSignal(3, Colors.red.shade200),
                SizedBox(width: 6),
                // Söndürülmüş WiFi ikonu
                AnimatedBuilder(
                  animation: _sigillAnimation,
                  builder: (context, child) => Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [Colors.grey.shade400, Colors.grey.shade600],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '×',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 6,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 6),
                _buildWeakWifiSignal(3, Colors.red.shade200),
                SizedBox(width: 2),
                _buildWeakWifiSignal(6, Colors.red.shade400),
                SizedBox(width: 2),
                _buildWeakWifiSignal(4, Colors.red.shade300),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeakWifiSignal(double height, Color color) {
    return AnimatedBuilder(
      animation: _sigillAnimation,
      builder: (context, child) => Container(
        width: 3,
        height: height * (_sigillAnimation.value * 0.5 + 0.3),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.3), color.withOpacity(0.8)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          borderRadius: BorderRadius.circular(1.5),
        ),
      ),
    );
  }

  Widget _buildDepressedTorso() {
    return AnimatedBuilder(
      animation: _sigillAnimation,
      builder: (context, child) => Transform.scale(
        scale: _sigillAnimation.value,
        child: Container(
          width: 75,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF64748B),
                Color(0xFF475569),
                Color(0xFF334155),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade600.withOpacity(0.4),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildErrorDisplay(),
              SizedBox(height: 6),
              _buildSadButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorDisplay() {
    return Container(
      width: 50,
      height: 25,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.red.shade400, width: 1),
      ),
      child: AnimatedBuilder(
        animation: _sadnessAnimation,
        builder: (context, child) => Stack(
          children: [
            // Hata sembolü
            Center(
              child: Text(
                '!',
                style: TextStyle(
                  color: Colors.red.shade400,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Yanıp sönen kenar
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.red.withOpacity(
                        0.3 + 0.3 * math.sin(_sadnessAnimation.value * 3)
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

  Widget _buildSadButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSadButton(Colors.red.shade300),
        _buildSadButton(Colors.grey.shade400),
        _buildSadButton(Colors.orange.shade300),
      ],
    );
  }

  Widget _buildSadButton(Color color) {
    return AnimatedBuilder(
      animation: _sigillAnimation,
      builder: (context, child) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: color.withOpacity(_sigillAnimation.value * 0.5 + 0.3),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildSlumpedBase() {
    return Container(
      width: 60,
      height: 12,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF475569), Color(0xFF334155)],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
    );
  }

  Widget _buildSadArms() {
    return Stack(
      children: [
        // Sol kol - Aşağı sarkık
        Positioned(
          left: 5,
          top: 120,
          child: Transform.rotate(
            angle: 0.8,
            child: _buildDroopyArm(),
          ),
        ),
        // Sağ kol - Aşağı sarkık
        Positioned(
          right: 5,
          top: 120,
          child: Transform.rotate(
            angle: -0.8,
            child: _buildDroopyArm(),
          ),
        ),
      ],
    );
  }

  Widget _buildDroopyArm() {
    return AnimatedBuilder(
      animation: _droopAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _droopAnimation.value * 0.5),
        child: Column(
          children: [
            // Kol
            Container(
              width: 16,
              height: 28,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF64748B), Color(0xFF475569)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(height: 2),
            // El
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF64748B), Color(0xFF94A3B8)],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTears() {
    return AnimatedBuilder(
      animation: _tearAnimation,
      builder: (context, child) => Stack(
        children: [
          // Sol gözyaşı
          Positioned(
            left: widget.width/2 - 20,
            top: 55 + (_tearAnimation.value * 40),
            child: Opacity(
              opacity: 0.8,
              child: Container(
                width: 4,
                height: 8 + (_tearAnimation.value * 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade200.withOpacity(0.8),
                      Colors.blue.shade400,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          // Sağ gözyaşı
          Positioned(
            left: widget.width/2 + 16,
            top: 57 + (_tearAnimation.value * 38),
            child: Opacity(
              opacity: 0.8,
              child: Container(
                width: 4,
                height: 8 + (_tearAnimation.value * 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade200.withOpacity(0.8),
                      Colors.blue.shade400,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          // Gözyaşı damlacıkları
          ...List.generate(3, (index) {
            return Positioned(
              left: widget.width/2 - 10 + (index * 8),
              top: 100 + (_tearAnimation.value * 20) + (index * 15),
              child: Opacity(
                opacity: 0.6 - (index * 0.2),
                child: Container(
                  width: (3 - index).toDouble(),
                  height: (3 - index).toDouble(),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
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
}