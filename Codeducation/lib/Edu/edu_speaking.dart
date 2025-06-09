import 'package:flutter/material.dart';
import 'dart:math' as math;

class EduSpeaking extends StatefulWidget {
  final double width;
  final double height;
  final bool isActive;
  final String? currentText;

  const EduSpeaking({
    Key? key,
    this.width = 160,
    this.height = 180,
    this.isActive = true,
    this.currentText,
  }) : super(key: key);

  @override
  _EduSpeakingState createState() => _EduSpeakingState();
}

class _EduSpeakingState extends State<EduSpeaking>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _eyeBlinkController;
  late AnimationController _pulseController;
  late AnimationController _codeStreamController;
  late AnimationController _speakingController;
  late AnimationController _headNodController;
  late AnimationController _gestureController;

  late Animation<double> _floatingAnimation;
  late Animation<double> _eyeBlinkAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _codeStreamAnimation;
  late Animation<double> _speakingAnimation;
  late Animation<double> _headNodAnimation;
  late Animation<double> _gestureAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startBlinking();
    if (widget.isActive) {
      _startSpeaking();
    }
  }

  @override
  void didUpdateWidget(EduSpeaking oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _startSpeaking();
      } else {
        _stopSpeaking();
      }
    }
  }

  void _initAnimations() {
    // Floating animation - daha yumuşak konuşma sırasında
    _floatingController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(
      begin: -4.0,
      end: 6.0,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    // Eye blink animation
    _eyeBlinkController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );

    _eyeBlinkAnimation = Tween<double>(
      begin: 1.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _eyeBlinkController,
      curve: Curves.easeOut,
    ));

    // Pulse animation - daha hızlı konuşma sırasında
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Code stream animation - daha aktif
    _codeStreamController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _codeStreamAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_codeStreamController);

    // Speaking animation - ağız hareketleri
    _speakingController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _speakingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _speakingController,
      curve: Curves.easeInOut,
    ));

    // Head nod animation - baş sallama
    _headNodController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _headNodAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headNodController,
      curve: Curves.easeInOut,
    ));

    // Gesture animation - el hareketleri
    _gestureController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _gestureAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _gestureController,
      curve: Curves.easeInOut,
    ));
  }

  void _startSpeaking() {
    _speakingController.repeat(reverse: true);
    _headNodController.repeat(reverse: true);
    _gestureController.repeat(reverse: true);
  }

  void _stopSpeaking() {
    _speakingController.stop();
    _headNodController.stop();
    _gestureController.stop();
    _speakingController.reset();
    _headNodController.reset();
    _gestureController.reset();
  }

  void _startBlinking() {
    Future.delayed(Duration(seconds: 1 + (DateTime.now().millisecond % 3)), () {
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
    _speakingController.dispose();
    _headNodController.dispose();
    _gestureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _floatingAnimation,
        _headNodAnimation,
      ]),
      builder: (context, child) => Transform.translate(
        offset: Offset(
          _headNodAnimation.value * math.sin(_headNodAnimation.value * math.pi * 2) * 3,
          _floatingAnimation.value,
        ),
        child: Transform.rotate(
          angle: _headNodAnimation.value * math.sin(_headNodAnimation.value * math.pi * 2) * 0.1,
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Ana robot gövdesi
                _buildRobotBody(),
                // Kollar - animasyonlu
                _buildAnimatedRobotArms(),
                // WiFi şapkası - daha aktif
                _buildActiveWifiHat(),
                // Kod akışları - daha yoğun
                _buildActiveCodeStreams(),
                // Konuşma efektleri
                _buildSpeakingEffects(),
              ],
            ),
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
          _buildSpeakingHead(),
          SizedBox(height: 8),
          _buildActiveTorso(),
          SizedBox(height: 6),
          _buildRobotBase(),
        ],
      ),
    );
  }

  Widget _buildSpeakingHead() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) => Transform.scale(
        scale: _pulseAnimation.value,
        child: Container(
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
                color: Color(0xFF3B82F6).withOpacity(0.6 * _pulseAnimation.value),
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
              // Saç detayları - hareket eden
              _buildAnimatedHairDetails(),
              // Yüz özellikleri
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 8),
                  _buildExpressiveEyes(),
                  SizedBox(height: 10),
                  _buildAnimatedMouth(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedHairDetails() {
    return Positioned(
      top: 4,
      left: 0,
      right: 0,
      child: Container(
        height: 20,
        child: AnimatedBuilder(
          animation: _gestureAnimation,
          builder: (context, child) => Stack(
            children: [
              // Sol saç tutamı - hareket eden
              Positioned(
                left: 12 + _gestureAnimation.value * math.sin(_gestureAnimation.value * math.pi * 4) * 2,
                top: 0,
                child: Transform.rotate(
                  angle: -0.3 + _gestureAnimation.value * 0.2,
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
                top: -1 + _gestureAnimation.value * math.sin(_gestureAnimation.value * math.pi * 3) * 1,
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
              // Sağ saç tutamı - hareket eden
              Positioned(
                right: 12 + _gestureAnimation.value * math.sin(_gestureAnimation.value * math.pi * 4) * -2,
                top: 0,
                child: Transform.rotate(
                  angle: 0.3 - _gestureAnimation.value * 0.2,
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
      ),
    );
  }

  Widget _buildExpressiveEyes() {
    return AnimatedBuilder(
      animation: _eyeBlinkAnimation,
      builder: (context, child) => Transform.scale(
        scaleY: _eyeBlinkAnimation.value,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildExpressiveEye(),
            SizedBox(width: 16),
            _buildExpressiveEye(),
          ],
        ),
      ),
    );
  }

  Widget _buildExpressiveEye() {
    return AnimatedBuilder(
      animation: _speakingAnimation,
      builder: (context, child) => Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Color(0xFF1E40AF), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF60A5FA).withOpacity(0.7 + _speakingAnimation.value * 0.3),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ana göz bebeği - konuşma sırasında hafif hareket eder
            Transform.translate(
              offset: Offset(
                _speakingAnimation.value * math.sin(_speakingAnimation.value * math.pi * 8) * 1,
                0,
              ),
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFF1E40AF),
                      Color(0xFF3B82F6),
                      Color(0xFF60A5FA)
                    ],
                    stops: [0.3, 0.7, 1.0],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Parlak ışık yansıması - daha belirgin
            Positioned(
              top: 3,
              right: 3,
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.8),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedMouth() {
    return AnimatedBuilder(
      animation: _speakingAnimation,
      builder: (context, child) {
        // Konuşma sırasında ağız şekli değişir
        double mouthWidth = 30 + _speakingAnimation.value * 8;
        double mouthHeight = 15 + _speakingAnimation.value * 5;

        return Container(
          width: mouthWidth,
          height: mouthHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade50],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 100),
              width: 20 + _speakingAnimation.value * 6,
              height: 2.5 + _speakingAnimation.value * 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF3B82F6),
                    Color(0xFF60A5FA),
                    widget.isActive ? Color(0xFF10B981) : Color(0xFF60A5FA)
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActiveWifiHat() {
    return Positioned(
      top: 0,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) => Transform.scale(
          scale: 1.0 + _pulseAnimation.value * 0.05,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Şapka tabanı - daha parlak
              Container(
                width: 110,
                height: 22,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1E40AF),
                      Color(0xFF3B82F6),
                      Color(0xFF60A5FA)
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF3B82F6).withOpacity(0.4),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
              // WiFi sinyali - daha aktif
              Positioned(
                top: 2,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildActiveWifiSignal(6, Color(0xFF10B981)),
                    SizedBox(width: 2),
                    _buildActiveWifiSignal(10, Color(0xFF10B981)),
                    SizedBox(width: 2),
                    _buildActiveWifiSignal(14, Color(0xFF10B981)),
                    SizedBox(width: 6),
                    // WiFi ikonu ortada - daha büyük ve parlak
                    Transform.scale(
                      scale: _pulseAnimation.value * 0.8 + 0.6,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [Colors.white, Color(0xFF60A5FA)],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.8),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    _buildActiveWifiSignal(14, Color(0xFF10B981)),
                    SizedBox(width: 2),
                    _buildActiveWifiSignal(10, Color(0xFF10B981)),
                    SizedBox(width: 2),
                    _buildActiveWifiSignal(6, Color(0xFF10B981)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveWifiSignal(double height, Color color) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _speakingAnimation]),
      builder: (context, child) {
        double animatedHeight = height * (_pulseAnimation.value + _speakingAnimation.value * 0.3);
        return Container(
          width: 3,
          height: animatedHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.3),
                color,
                Colors.white.withOpacity(0.8)
              ],
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
        );
      },
    );
  }

  Widget _buildActiveTorso() {
    return AnimatedBuilder(
      animation: _speakingAnimation,
      builder: (context, child) => Container(
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
              color: Color(0xFF1E40AF).withOpacity(0.4 + _speakingAnimation.value * 0.2),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActiveCodeDisplay(),
            SizedBox(height: 6),
            _buildActiveControlButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveCodeDisplay() {
    return Container(
      width: 50,
      height: 25,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: widget.isActive ? Color(0xFF10B981) : Color(0xFF3B82F6),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (widget.isActive ? Color(0xFF10B981) : Color(0xFF3B82F6)).withOpacity(0.3),
            blurRadius: 6,
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _codeStreamAnimation,
        builder: (context, child) => Stack(
          children: [
            // Kod metni simülasyonu - daha aktif
            Positioned(
              left: 3,
              top: 2,
              child: Text(
                '</>',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Color(0xFF10B981).withOpacity(0.5),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            ),
            // Alt satır - hareketli
            Positioned(
              left: 3 + _codeStreamAnimation.value * 5,
              bottom: 2,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 1.5,
                    decoration: BoxDecoration(
                      color: Color(0xFF60A5FA),
                      borderRadius: BorderRadius.circular(0.5),
                    ),
                  ),
                  SizedBox(width: 1.5),
                  Container(
                    width: 12,
                    height: 1.5,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(0.5),
                    ),
                  ),
                ],
              ),
            ),
            // Cursor animasyonu - daha hızlı
            Positioned(
              right: 3 + (_codeStreamAnimation.value * 12),
              top: 6,
              child: Container(
                width: 1,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.8),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActiveControlButton(Color(0xFF10B981)), // Yeşil
        _buildActiveControlButton(Colors.orange),      // Turuncu
        _buildActiveControlButton(Colors.red),         // Kırmızı
      ],
    );
  }

  Widget _buildActiveControlButton(Color color) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _speakingAnimation]),
      builder: (context, child) => Container(
        width: 8 + _speakingAnimation.value * 2,
        height: 8 + _speakingAnimation.value * 2,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity((_pulseAnimation.value + _speakingAnimation.value) * 0.7),
              blurRadius: 5,
              spreadRadius: 1,
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

  Widget _buildAnimatedRobotArms() {
    return AnimatedBuilder(
      animation: _gestureAnimation,
      builder: (context, child) => Stack(
        children: [
          // Sol kol - Laptop tutuyor, konuşma sırasında hareket eder
          Positioned(
            left: 10,
            top: 110 + _gestureAnimation.value * math.sin(_gestureAnimation.value * math.pi * 3) * 3,
            child: Transform.rotate(
              angle: -0.2 + _gestureAnimation.value * math.sin(_gestureAnimation.value * math.pi * 4) * 0.3,
              child: _buildArmWithLaptop(),
            ),
          ),
          // Sağ kol - Konuşma jestleri
          Positioned(
            right: 10,
            top: 110 + _gestureAnimation.value * math.sin(_gestureAnimation.value * math.pi * 2.5) * 4,
            child: Transform.rotate(
              angle: 0.1 + _gestureAnimation.value * math.sin(_gestureAnimation.value * math.pi * 3) * 0.4,
              child: _buildGesturingArm(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArmWithLaptop() {
    return Column(
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
        // Laptop - konuşma sırasında parlıyor
        AnimatedBuilder(
          animation: _speakingAnimation,
          builder: (context, child) => Container(
            width: 20,
            height: 16,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.shade300, Colors.grey.shade400],
              ),
              borderRadius: BorderRadius.circular(3),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF60A5FA).withOpacity(_speakingAnimation.value * 0.3),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 16,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(1.5),
                  border: Border.all(
                    color: Color(0xFF10B981).withOpacity(0.5 + _speakingAnimation.value * 0.5),
                    width: 0.5,
                  ),
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
        ),
      ],
    );
  }

  Widget _buildGesturingArm() {
    return Container(
      width: 16,
      height: 28,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1E40AF).withOpacity(0.4),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        // El işareti - konuşma sırasında değişir
        child: AnimatedBuilder(
          animation: _speakingAnimation,
          builder: (context, child) => Text(
            _speakingAnimation.value > 0.5 ? '👍' : '✋',
            style: TextStyle(fontSize: 8),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveCodeStreams() {
    return AnimatedBuilder(
      animation: _codeStreamAnimation,
      builder: (context, child) => Stack(
        children: [
          // Sol kod akışı - daha hızlı
          Positioned(
            left: -5 + _codeStreamAnimation.value * 10,
            top: 60 + (_codeStreamAnimation.value * 60),
            child: Opacity(
              opacity: 0.8,
              child: Text(
                'if(learn)',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Color(0xFF10B981).withOpacity(0.6),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Sağ kod akışı - daha aktif
          Positioned(
            right: -5 + _codeStreamAnimation.value * 15,
            top: 75 + (_codeStreamAnimation.value * 45),
            child: Opacity(
              opacity: 0.7,
              child: Text(
                'fun()',
                style: TextStyle(
                  color: Color(0xFF60A5FA),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Color(0xFF60A5FA).withOpacity(0.5),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Üst kod akışı - hızlı hareket
          Positioned(
            left: 65 + _codeStreamAnimation.value * 20,
            top: 40 + (_codeStreamAnimation.value * 25),
            child: Opacity(
              opacity: 0.6,
              child: Text(
                'class{}',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.orange.withOpacity(0.5),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Ekstra kod parçacıkları - konuşma sırasında
          Positioned(
            left: 20 + _codeStreamAnimation.value * 30,
            top: 95 + (_codeStreamAnimation.value * 20),
            child: Opacity(
              opacity: 0.5,
              child: Text(
                'try{}',
                style: TextStyle(
                  color: Color(0xFFEF4444),
                  fontSize: 7,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Hareket eden nokta efektleri
          Positioned(
            right: 25 + _codeStreamAnimation.value * 25,
            top: 50 + (_codeStreamAnimation.value * 35),
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [Color(0xFF10B981), Colors.transparent],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 80 + _codeStreamAnimation.value * 15,
            top: 80 + (_codeStreamAnimation.value * 30),
            child: Container(
              width: 3,
              height: 3,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [Colors.orange, Colors.transparent],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeakingEffects() {
    if (!widget.isActive) return SizedBox.shrink();

    return AnimatedBuilder(
      animation: _speakingAnimation,
      builder: (context, child) => Stack(
        children: [
          // Konuşma dalgaları - kafanın etrafında
          Positioned(
            top: 50,
            left: 120,
            child: Opacity(
              opacity: _speakingAnimation.value * 0.6,
              child: Transform.scale(
                scale: 0.8 + _speakingAnimation.value * 0.4,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF60A5FA),
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 70,
            left: 125,
            child: Opacity(
              opacity: _speakingAnimation.value * 0.4,
              child: Transform.scale(
                scale: 1.0 + _speakingAnimation.value * 0.6,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF10B981),
                      width: 1.5,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          // Sol taraf konuşma efektleri
          Positioned(
            top: 60,
            left: -15,
            child: Opacity(
              opacity: _speakingAnimation.value * 0.5,
              child: Transform.scale(
                scale: 0.6 + _speakingAnimation.value * 0.5,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.orange,
                      width: 1.5,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          // Enerji parçacıkları
          ...List.generate(5, (index) {
            double angle = index * (math.pi * 2 / 5);
            double radius = 40 + _speakingAnimation.value * 15;
            return Positioned(
              top: 75 + math.sin(angle + _speakingAnimation.value * math.pi * 2) * radius,
              left: 80 + math.cos(angle + _speakingAnimation.value * math.pi * 2) * radius,
              child: Opacity(
                opacity: _speakingAnimation.value * 0.3,
                child: Container(
                  width: 3,
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        [Color(0xFF10B981), Color(0xFF60A5FA), Colors.orange, Color(0xFFEF4444), Color(0xFF8B5CF6)][index],
                        Colors.transparent
                      ],
                    ),
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