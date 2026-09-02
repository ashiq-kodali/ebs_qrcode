import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  /// If provided, called with **all** non-empty codes found in a single frame,
  /// enabling multi-code scanning. When set, it takes over from [onDetect] /
  /// auto-pop and the scanner keeps running so you control the flow.
  final ValueChanged<List<String>>? onMultiDetect;

  /// If provided, a "Share" action appears in the built-in result sheet
  /// (see [EbsQrConfig.showResultSheet]); wire it to your own share plugin.
  final ValueChanged<String>? onShareResult;

  const EbsQrScanner({
    super.key,
    this.config = const EbsQrConfig(),
    this.onDetect,
    this.onMultiDetect,
    this.onShareResult,
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
  bool _reset = false;
  double _zoom = 0.0;
  double _zoomStart = 0.0;

  EbsQrConfig get _cfg => widget.config;

  /// Handles a single decoded value: haptic, then either the result sheet or
  /// direct delivery. Guarded so it only fires once.
  void _handleCode(String? code) {
    if (_handled || !mounted) return;
    if (code == null || code.isEmpty) return;
    _handled = true;
    _buzz();
    if (_cfg.showResultSheet) {
      _showResultSheet(code);
    } else {
      _deliver(code);
    }
  }

  /// Delivers the value to [onDetect], or pops the route with it.
  void _deliver(String code) {
    if (!mounted) return;
    if (widget.onDetect != null) {
      widget.onDetect!(code);
    } else {
      Navigator.of(context).pop(code);
    }
  }

  /// Plays the configured haptic on a successful detection.
  void _buzz() {
    if (!_cfg.enableHaptics) return;
    switch (_cfg.hapticFeedback) {
      case EbsHaptic.light:
        HapticFeedback.lightImpact();
      case EbsHaptic.medium:
        HapticFeedback.mediumImpact();
      case EbsHaptic.heavy:
        HapticFeedback.heavyImpact();
      case EbsHaptic.selection:
        HapticFeedback.selectionClick();
      case EbsHaptic.vibrate:
        HapticFeedback.vibrate();
    }
  }

  /// Maps a pinch gesture to the camera zoom (0.0–1.0).
  void _onZoom(ScaleUpdateDetails details) {
    final next =
        (_zoomStart + (details.scale - 1.0) * _cfg.zoomSensitivity).clamp(
      0.0,
      1.0,
    );
    if ((next - _zoom).abs() < 0.005) return;
    _zoom = next;
    _controller.setZoomScale(_zoom);
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    final values = <String>[
      for (final b in capture.barcodes)
        if (b.rawValue != null && b.rawValue!.isNotEmpty) b.rawValue!,
    ];
    if (values.isEmpty) return;

    // Multi-code mode: report every code and keep scanning.
    if (widget.onMultiDetect != null) {
      _buzz();
      widget.onMultiDetect!(values);
      return;
    }
    _handleCode(values.first);
  }

  /// Shows the built-in result sheet with copy / share / use / scan-again.
  Future<void> _showResultSheet(String code) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(_cfg.resultSheetTitle,
                    style: Theme.of(sheetContext).textTheme.titleMedium),
                const SizedBox(height: 12),
                SelectableText(code,
                    style: Theme.of(sheetContext).textTheme.bodyLarge),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.copy_rounded, size: 18),
                        label: Text(_cfg.copyLabel),
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: code));
                          _snack(_cfg.copiedMessage);
                        },
                      ),
                    ),
                    if (widget.onShareResult != null) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.ios_share_rounded, size: 18),
                          label: Text(_cfg.shareLabel),
                          onPressed: () => widget.onShareResult!(code),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                FilledButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: Text(_cfg.useResultLabel),
                ),
                TextButton(
                  onPressed: () {
                    _reset = true;
                    Navigator.of(sheetContext).pop();
                  },
                  child: Text(_cfg.scanAgainLabel),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted) return;
    if (_reset) {
      // User chose "scan again": resume scanning.
      _reset = false;
      _handled = false;
    } else {
      _deliver(code);
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
        _handleCode(code);
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

  /// The flash control: a custom widget (fed the live on/off state + toggle)
  /// when [EbsQrConfig.flashButtonBuilder] is set, otherwise the built-in
  /// [EbsFlashButton].
  Widget _buildFlash() {
    final builder = _cfg.flashButtonBuilder;
    if (builder != null) {
      return ValueListenableBuilder<MobileScannerState>(
        valueListenable: _controller,
        builder: (context, state, _) => builder(
          context,
          state.torchState == TorchState.on,
          _controller.toggleTorch,
        ),
      );
    }
    return EbsFlashButton(
      controller: _controller,
      accentColor: _cfg.accentColor,
      foregroundColor: _cfg.foregroundColor,
      onIcon: _cfg.flashOnIcon,
      offIcon: _cfg.flashOffIcon,
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
            child: _cfg.enableZoom
                ? GestureDetector(
                    onScaleStart: (_) => _zoomStart = _zoom,
                    onScaleUpdate: _onZoom,
                    child: MobileScanner(
                        controller: _controller, onDetect: _onDetect),
                  )
                : MobileScanner(controller: _controller, onDetect: _onDetect),
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
                if (_cfg.showFlash) ...[
                  _buildFlash(),
                  const SizedBox(width: 16),
                ],
                if (_cfg.showGallery) ...[
                  _cfg.galleryButtonBuilder?.call(context, _scanFromGallery) ??
                      EbsPillButton(
                        icon: _cfg.galleryIcon,
                        label: _cfg.galleryLabel,
                        onTap: _scanFromGallery,
                        foregroundColor: _cfg.foregroundColor,
                      ),
                  const SizedBox(width: 16),
                ],
                if (_cfg.showFlip)
                  _cfg.flipButtonBuilder
                          ?.call(context, _controller.switchCamera) ??
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
