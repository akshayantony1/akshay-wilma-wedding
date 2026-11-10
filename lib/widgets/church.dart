import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme.dart';

/// Stylised illustration of a white twin-towered church inside a window arch.
/// It is an artistic impression, not a photograph of the Basilica.
class ChurchIllustration extends StatelessWidget {
  const ChurchIllustration({super.key, required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Illustration of a church',
      child: SizedBox(
        width: width,
        height: width * 276 / 300,
        child: RepaintBoundary(child: CustomPaint(painter: _ChurchPainter())),
      ),
    );
  }
}

class _ChurchPainter extends CustomPainter {
  static const _w = 300.0;
  static const _h = 276.0;
  static const _ink = Color(0xFF1F3D2B);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / _w);
    final frame = RRect.fromRectAndCorners(
      const Rect.fromLTWH(0, 0, _w, _h),
      topLeft: const Radius.circular(150),
      topRight: const Radius.circular(150),
      bottomLeft: const Radius.circular(18),
      bottomRight: const Radius.circular(18),
    );
    canvas.save();
    canvas.clipRRect(frame);

    // sky
    const sky = Rect.fromLTWH(0, 0, _w, _h);
    canvas.drawRect(
      sky,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF9D7D2), Color(0xFFFDEBDD), Color(0xFFFFF6EE)],
        ).createShader(sky),
    );
    canvas.drawCircle(
      const Offset(150, 110),
      130,
      Paint()
        ..shader = const RadialGradient(colors: [Color(0xCCFFFFFF), Color(0x00FFFFFF)])
            .createShader(Rect.fromCircle(center: const Offset(150, 110), radius: 130)),
    );
    final cloud = Paint()..color = const Color(0x99FFFFFF);
    canvas.drawOval(Rect.fromCenter(center: const Offset(70, 62), width: 64, height: 14), cloud);
    canvas.drawOval(Rect.fromCenter(center: const Offset(92, 56), width: 40, height: 12), cloud);
    canvas.drawOval(Rect.fromCenter(center: const Offset(232, 78), width: 56, height: 12), cloud);

    // palms
    _palm(canvas, const Offset(34, 240), 120, -14);
    _palm(canvas, const Offset(268, 240), 104, 12);

    // ground + water
    canvas.drawRect(const Rect.fromLTWH(0, 232, _w, 16), Paint()..color = const Color(0xFFE3E9D6));
    const water = Rect.fromLTWH(0, 244, _w, 40);
    canvas.drawRect(
      water,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF2D4D2), Color(0xFFE5B9BB)],
        ).createShader(water),
    );
    final wave = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = const Color(0x88FFFFFF);
    for (var i = 0; i < 4; i++) {
      final y = 252.0 + i * 8;
      final p = Path()..moveTo(14.0 + i * 12, y);
      for (var x = 14.0 + i * 12; x < 280; x += 24) {
        p.relativeQuadraticBezierTo(6, -3, 12, 0);
        p.relativeQuadraticBezierTo(6, 3, 12, 0);
      }
      canvas.drawPath(p, wave);
    }

    _church(canvas);
    canvas.restore();

    canvas.drawRRect(
      frame,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.rose.withAlpha(150),
    );
  }

  void _church(Canvas canvas) {
    final white = Paint()..color = const Color(0xFFFFFDFA);
    final shade = Paint()..color = const Color(0xFFF1DDD6);
    final roof = Paint()..color = const Color(0xFFE9D3CB);
    final dark = Paint()..color = const Color(0xFF2E4A39);
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = _ink.withAlpha(80);

    // towers
    for (final x in [66.0, 198.0]) {
      canvas.drawRect(Rect.fromLTWH(x, 112, 36, 112), white);
      canvas.drawRect(Rect.fromLTWH(x + 27, 112, 9, 112), shade);
      canvas.drawRect(Rect.fromLTWH(x, 112, 36, 112), line);
      final belfry = Path()
        ..moveTo(x + 11, 152)
        ..lineTo(x + 11, 138)
        ..arcToPoint(Offset(x + 25, 138), radius: const Radius.circular(7), clockwise: true)
        ..lineTo(x + 25, 152)
        ..close();
      canvas.drawPath(belfry, dark);
      final slit = Path()
        ..moveTo(x + 15, 190)
        ..lineTo(x + 15, 176)
        ..arcToPoint(Offset(x + 21, 176), radius: const Radius.circular(3), clockwise: true)
        ..lineTo(x + 21, 190)
        ..close();
      canvas.drawPath(slit, dark);
      final spire = Path()
        ..moveTo(x - 3, 112)
        ..lineTo(x + 18, 66)
        ..lineTo(x + 39, 112)
        ..close();
      canvas.drawPath(spire, roof);
      canvas.drawPath(spire, line);
      _cross(canvas, Offset(x + 18, 66), 12);
    }

    // nave + pediment
    canvas.drawRect(const Rect.fromLTWH(102, 140, 96, 84), white);
    canvas.drawRect(const Rect.fromLTWH(102, 140, 96, 84), line);
    final pediment = Path()
      ..moveTo(96, 142)
      ..lineTo(204, 142)
      ..lineTo(150, 100)
      ..close();
    canvas.drawPath(pediment, white);
    canvas.drawPath(pediment, line);
    _cross(canvas, const Offset(150, 100), 15);

    // rose window
    canvas.drawCircle(const Offset(150, 158), 12, Paint()..color = AppColors.blushDeep);
    canvas.drawCircle(const Offset(150, 158), 12, line);
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      canvas.drawLine(
        const Offset(150, 158),
        Offset(150 + 12 * math.cos(a), 158 + 12 * math.sin(a)),
        line,
      );
    }

    // side windows
    for (final x in [112.0, 178.0]) {
      final win = Path()
        ..moveTo(x, 204)
        ..lineTo(x, 188)
        ..arcToPoint(Offset(x + 10, 188), radius: const Radius.circular(5), clockwise: true)
        ..lineTo(x + 10, 204)
        ..close();
      canvas.drawPath(win, dark);
    }

    // door
    final door = Path()
      ..moveTo(136, 224)
      ..lineTo(136, 194)
      ..arcToPoint(const Offset(164, 194), radius: const Radius.circular(14), clockwise: true)
      ..lineTo(164, 224)
      ..close();
    canvas.drawPath(door, dark);
    final doorInner = Path()
      ..moveTo(142, 224)
      ..lineTo(142, 197)
      ..arcToPoint(const Offset(158, 197), radius: const Radius.circular(8), clockwise: true)
      ..lineTo(158, 224)
      ..close();
    canvas.drawPath(doorInner, Paint()..color = const Color(0xFF456A52));

    // steps
    final step = Paint()..color = const Color(0xFFF6E7E1);
    canvas.drawRect(const Rect.fromLTWH(94, 224, 112, 6), step);
    canvas.drawRect(const Rect.fromLTWH(94, 224, 112, 6), line);
    canvas.drawRect(const Rect.fromLTWH(86, 230, 128, 6), step);
    canvas.drawRect(const Rect.fromLTWH(86, 230, 128, 6), line);
  }

  void _cross(Canvas canvas, Offset base, double h) {
    final p = Paint()
      ..color = _ink
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(base, base.translate(0, -h), p);
    canvas.drawLine(base.translate(-h * .32, -h * .65), base.translate(h * .32, -h * .65), p);
  }

  void _palm(Canvas canvas, Offset base, double height, double lean) {
    final top = base.translate(lean, -height);
    final trunk = Path()
      ..moveTo(base.dx, base.dy)
      ..quadraticBezierTo(base.dx + lean * .1, base.dy - height * .55, top.dx, top.dy);
    canvas.drawPath(
      trunk,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.4
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF6B5A47).withAlpha(150),
    );
    final frond = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round
      ..color = AppColors.leaf.withAlpha(190);
    for (final a in [-2.9, -2.4, -1.9, -1.2, -0.7, -0.2]) {
      final end = top + Offset(math.cos(a), math.sin(a) * .55) * 34;
      final ctrl = top + Offset(math.cos(a) * 18, math.sin(a) * 18 - 14);
      canvas.drawPath(Path()..moveTo(top.dx, top.dy)..quadraticBezierTo(ctrl.dx, ctrl.dy, end.dx, end.dy + 10), frond);
    }
  }

  @override
  bool shouldRepaint(covariant _ChurchPainter old) => false;
}

/// Bouncing map pin with a soft ripple.
class LocationPin extends StatefulWidget {
  const LocationPin({super.key});

  @override
  State<LocationPin> createState() => _LocationPinState();
}

class _LocationPinState extends State<LocationPin> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1700))..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        width: 84,
        height: 84,
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            final t = _c.value;
            final bounce = (math.sin(t * 2 * math.pi) * .5 + .5);
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned(
                  bottom: 6,
                  child: Opacity(
                    opacity: 1 - t,
                    child: Transform.scale(
                      scale: .5 + t * 1.3,
                      child: Container(
                        width: 36,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.deepRose.withAlpha(160), width: 1.6),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  child: Container(
                    width: 14 - bounce * 4,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.forest.withAlpha(60),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10 + bounce * 12,
                  child: const Icon(Icons.location_on, size: 54, color: AppColors.deepRose),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
