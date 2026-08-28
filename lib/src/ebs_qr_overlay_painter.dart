import 'package:flutter/material.dart';

/// Paints a translucent scrim with a transparent rounded cut-out, a thin border
/// stroke, and thicker accent brackets at each corner.
class EbsQrOverlayPainter extends CustomPainter {
  final Rect cutOut;
  final Color scrimColor;
  final Color borderColor;
  final Color accentColor;
  final double radius;

  EbsQrOverlayPainter({
    required this.cutOut,
    required this.scrimColor,
    required this.borderColor,
    required this.accentColor,
    this.radius = 16,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(cutOut, Radius.circular(radius));

    // Scrim everywhere except the cut-out.
    final scrim = Paint()..color = scrimColor;
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(rrect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, scrim);

    // Thin border stroke.
    final border = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(rrect, border);

    // Corner accents.
    final accent = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    const len = 26.0;
    final r = cutOut;
    const cr = Radius.circular(14);

    // Top-left
    canvas.drawPath(
        Path()
          ..moveTo(r.left, r.top + len)
          ..lineTo(r.left, r.top + 14)
          ..arcToPoint(Offset(r.left + 14, r.top), radius: cr)
          ..lineTo(r.left + len, r.top),
        accent);
    // Top-right
    canvas.drawPath(
        Path()
          ..moveTo(r.right - len, r.top)
          ..lineTo(r.right - 14, r.top)
          ..arcToPoint(Offset(r.right, r.top + 14), radius: cr)
          ..lineTo(r.right, r.top + len),
        accent);
    // Bottom-right
    canvas.drawPath(
        Path()
          ..moveTo(r.right, r.bottom - len)
          ..lineTo(r.right, r.bottom - 14)
          ..arcToPoint(Offset(r.right - 14, r.bottom), radius: cr)
          ..lineTo(r.right - len, r.bottom),
        accent);
    // Bottom-left
    canvas.drawPath(
        Path()
          ..moveTo(r.left + len, r.bottom)
          ..lineTo(r.left + 14, r.bottom)
          ..arcToPoint(Offset(r.left, r.bottom - 14), radius: cr)
          ..lineTo(r.left, r.bottom - len),
        accent);
  }

  @override
  bool shouldRepaint(EbsQrOverlayPainter old) =>
      old.cutOut != cutOut ||
      old.scrimColor != scrimColor ||
      old.borderColor != borderColor ||
      old.accentColor != accentColor ||
      old.radius != radius;
}
