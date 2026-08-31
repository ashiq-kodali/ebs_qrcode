import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'ebs_qr_config.dart';
import 'ebs_qr_controls.dart';
import 'ebs_qr_overlay_painter.dart';

/// A full-screen, customizable QR / barcode scanner.
///
/// Push it and await the decoded value with the [scan] helper:
///
/// ```dart
/// final code = await EbsQrScanner.scan(context);
/// ```
///
/// Or embed it and receive results via [onDetect] (you control navigation).
class EbsQrScanner extends StatefulWidget {
  /// Visual + behavioural configuration.
  final EbsQrConfig config;

  /// If provided, called with each decoded value and the scanner does NOT pop.
  /// If null, the scanner pops with the decoded value (via [Navigator.pop]).
  final ValueChanged<String>? onDetect;

  const EbsQrScanner({
    super.key,
    this.config = const EbsQrConfig(),
    this.onDetect,
  });

  /// Pushes a full-screen scanner and resolves to the first decoded value,
  /// or `null` if the user backs out.
  static Future<String?> scan(
    BuildContext context, {
    EbsQrConfig config = const EbsQrConfig(),
  }) {
    return Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => EbsQrScanner(config: config)),
    );
  }

  @override
  State<EbsQrScanner> createState() => _EbsQrScannerState();
}

class _EbsQrScannerState extends State<EbsQrScanner>
    with SingleTickerProviderStateMixin {
  late final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: widget.config.initialCameraFacing,
    formats: widget.config.formats,
  );

  late final AnimationController _lineController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat(reverse: true);

  bool _handled = false;

  EbsQrConfig get _cfg => widget.config;

  void _finish(String? code) {
    if (_handled || !mounted) return;
    if (code == null || code.isEmpty) return;
    _handled = true;
    if (widget.onDetect != null) {
      widget.onDetect!(code);
    } else {
      Navigator.of(context).pop(code);
    }
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;
      if (value != null && value.isNotEmpty) {
        _finish(value);
        return;
      }
    }
  }

  Future<void> _scanFromGallery() async {
    try {
      final XFile? file =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file == null) return;
      final BarcodeCapture? result = await _controller.analyzeImage(file.path);
      final code = (result != null && result.barcodes.isNotEmpty)
          ? result.barcodes.first.rawValue
          : null;
      if (!mounted) return;
      if (code != null && code.isNotEmpty) {
        _finish(code);
      } else {
        _snack(_cfg.noCodeFoundMessage);
      }
    } catch (_) {
      _snack(_cfg.imageErrorMessage);
    }
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  void dispose() {
    _lineController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final size = media.size;
    final cut = (size.shortestSide * _cfg.cutOutSizeFactor)
        .clamp(_cfg.cutOutMinSize, _cfg.cutOutMaxSize);
    final cutRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * _cfg.cutOutCenterYFactor),
      width: cut,
      height: cut,
    );

    return Scaffold(
      backgroundColor: _cfg.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: _cfg.foregroundColor,
        title: (_cfg.title == null || _cfg.title!.isEmpty)
            ? null
            : Text(_cfg.title!, style: TextStyle(color: _cfg.foregroundColor)),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: MobileScanner(controller: _controller, onDetect: _onDetect),
          ),

          // Scrim + viewfinder cut-out with corner accents.
          Positioned.fill(
            child: CustomPaint(
              painter: EbsQrOverlayPainter(
                cutOut: cutRect,
                scrimColor: _cfg.scrimColor,
                borderColor: _cfg.borderColor,
                accentColor: _cfg.accentColor,
                radius: _cfg.cutOutRadius,
              ),
            ),
          ),

          // Animated scan line.
          if (_cfg.showScanLine)
            Positioned.fromRect(
              rect: cutRect.deflate(6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_cfg.cutOutRadius - 2),
                child: AnimatedBuilder(
                  animation: _lineController,
                  builder: (context, _) {
                    return Align(
                      alignment: Alignment(0, (_lineController.value * 2) - 1),
                      child: Container(
                        height: 2.5,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: LinearGradient(colors: [
                            _cfg.accentColor.withValues(alpha: 0),
                            _cfg.accentColor,
                            _cfg.accentColor.withValues(alpha: 0),
                          ]),
                          boxShadow: [
                            BoxShadow(
                                color: _cfg.accentColor.withValues(alpha: 0.6),
                                blurRadius: 8),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Instruction text.
          if (_cfg.instruction != null && _cfg.instruction!.isNotEmpty)
            Positioned(
              top: cutRect.bottom + 24,
              left: 24,
              right: 24,
              child: Text(
                _cfg.instruction!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: _cfg.foregroundColor.withValues(alpha: 0.75),
                    fontSize: 14),
              ),
            ),

          // Bottom controls (torch / gallery / flip).
          Positioned(
            left: 0,
            right: 0,
            bottom: media.padding.bottom + (_cfg.footer != null ? 58 : 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_cfg.showTorch) ...[
                  EbsTorchButton(
                    controller: _controller,
                    accentColor: _cfg.accentColor,
                    foregroundColor: _cfg.foregroundColor,
                    onIcon: _cfg.torchOnIcon,
                    offIcon: _cfg.torchOffIcon,
                  ),
                  const SizedBox(width: 16),
                ],
                if (_cfg.showGallery) ...[
                  EbsPillButton(
                    icon: _cfg.galleryIcon,
                    label: _cfg.galleryLabel,
                    onTap: _scanFromGallery,
                    foregroundColor: _cfg.foregroundColor,
                  ),
                  const SizedBox(width: 16),
                ],
                if (_cfg.showFlip)
                  EbsCircleButton(
                    icon: _cfg.flipIcon,
                    tooltip: 'Flip camera',
                    onTap: () => _controller.switchCamera(),
                    foregroundColor: _cfg.foregroundColor,
                  ),
              ],
            ),
          ),

          // Optional branding footer.
          if (_cfg.footer != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: media.padding.bottom + 14,
              child: _cfg.footer!,
            ),
        ],
      ),
    );
  }
}
