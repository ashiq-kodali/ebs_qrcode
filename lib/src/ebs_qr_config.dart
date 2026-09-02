import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Builds a custom flash (torch) button. [isOn] reflects the live flash state;
/// call [toggle] to turn the flash on/off — the scanner keeps that behaviour,
/// you only supply the widget.
typedef EbsFlashButtonBuilder = Widget Function(
  BuildContext context,
  bool isOn,
  VoidCallback toggle,
);

/// Builds a custom action button (gallery or camera flip). Call [onTap] to run
/// the original action — the scanner keeps that behaviour, you only supply the
/// widget.
typedef EbsControlButtonBuilder = Widget Function(
  BuildContext context,
  VoidCallback onTap,
);

/// Haptic intensity played on a successful detection (see
/// [EbsQrConfig.hapticFeedback]).
enum EbsHaptic { light, medium, heavy, selection, vibrate }

/// Visual + behavioural configuration for [EbsQrScanner].
///
/// Every field has a sensible default, so `const EbsQrConfig()` gives a
/// polished scanner out of the box. Override only what you need.
@immutable
class EbsQrConfig {
  /// App-bar title. Hidden when null/empty.
  final String? title;

  /// Helper text shown under the viewfinder. Hidden when null/empty.
  final String? instruction;

  /// Primary accent — corner brackets, scan line, active torch, flip.
  final Color accentColor;

  /// The dimmed area outside the viewfinder cut-out.
  final Color scrimColor;

  /// Thin border stroke around the cut-out.
  final Color borderColor;

  /// Scaffold background (behind the camera preview).
  final Color backgroundColor;

  /// Foreground colour for icons/text drawn on the scrim.
  final Color foregroundColor;

  /// Cut-out side length as a fraction of the shortest screen edge.
  final double cutOutSizeFactor;

  /// Clamp bounds for the computed cut-out size.
  final double cutOutMinSize;
  final double cutOutMaxSize;

  /// Corner radius of the cut-out / brackets.
  final double cutOutRadius;

  /// Vertical position of the cut-out centre (0 = top, 1 = bottom).
  final double cutOutCenterYFactor;

  /// Toggle individual controls.
  final bool showFlash;
  final bool showGallery;
  final bool showFlip;
  final bool showScanLine;

  /// Fire a short haptic buzz when a code is detected (camera or gallery).
  /// Uses [hapticFeedback] intensity below. Set to `false` to disable.
  final bool enableHaptics;

  /// The haptic played on a successful detection when [enableHaptics] is true.
  final EbsHaptic hapticFeedback;

  /// Enable pinch-to-zoom on the camera preview.
  final bool enableZoom;

  /// How strongly a pinch gesture maps to zoom (higher = faster zoom).
  final double zoomSensitivity;

  /// Show a built-in result sheet (value + copy/share) on detection instead of
  /// returning immediately. The result is delivered when the user taps
  /// [useResultLabel]; "scan again" dismisses it and resumes scanning.
  final bool showResultSheet;

  /// Result-sheet labels.
  final String resultSheetTitle;
  final String copyLabel;
  final String shareLabel;
  final String useResultLabel;
  final String scanAgainLabel;
  final String copiedMessage;

  /// Control icons. Override to swap the flash, gallery, or camera-flip glyphs
  /// for your own. [flashOnIcon] / [flashOffIcon] reflect the live flash state.
  /// Ignored for a control when its full-widget builder below is set.
  final IconData flashOnIcon;
  final IconData flashOffIcon;
  final IconData galleryIcon;
  final IconData flipIcon;

  /// Full-widget overrides. When set, the entire button is replaced by your
  /// widget while the scanner keeps wiring the original action (toggle flash /
  /// open gallery / flip camera). Leave null to use the built-in buttons.
  final EbsFlashButtonBuilder? flashButtonBuilder;
  final EbsControlButtonBuilder? galleryButtonBuilder;
  final EbsControlButtonBuilder? flipButtonBuilder;

  /// Control labels / messages.
  final String galleryLabel;
  final String noCodeFoundMessage;
  final String imageErrorMessage;

  /// Optional branding/footer pinned near the bottom.
  final Widget? footer;

  /// Restrict recognised formats. Empty = all supported formats.
  final List<BarcodeFormat> formats;

  /// Which camera to start with.
  final CameraFacing initialCameraFacing;

  const EbsQrConfig({
    this.title = 'Scan QR',
    this.instruction = 'Align the code within the frame to scan',
    this.accentColor = const Color(0xFF3BBCE5),
    this.scrimColor = const Color(0x8C000000),
    this.borderColor = const Color(0xE6FFFFFF),
    this.backgroundColor = Colors.black,
    this.foregroundColor = Colors.white,
    this.cutOutSizeFactor = 0.68,
    this.cutOutMinSize = 220,
    this.cutOutMaxSize = 300,
    this.cutOutRadius = 16,
    this.cutOutCenterYFactor = 0.42,
    this.showFlash = true,
    this.showGallery = true,
    this.showFlip = true,
    this.showScanLine = true,
    this.enableHaptics = true,
    this.hapticFeedback = EbsHaptic.medium,
    this.enableZoom = true,
    this.zoomSensitivity = 1.0,
    this.showResultSheet = false,
    this.resultSheetTitle = 'Scan result',
    this.copyLabel = 'Copy',
    this.shareLabel = 'Share',
    this.useResultLabel = 'Use',
    this.scanAgainLabel = 'Scan again',
    this.copiedMessage = 'Copied to clipboard',
    this.flashOnIcon = Icons.flash_on_rounded,
    this.flashOffIcon = Icons.flash_off_rounded,
    this.galleryIcon = Icons.photo_library_outlined,
    this.flipIcon = Icons.flip_camera_ios_outlined,
    this.flashButtonBuilder,
    this.galleryButtonBuilder,
    this.flipButtonBuilder,
    this.galleryLabel = 'Gallery',
    this.noCodeFoundMessage = 'No code found in the image',
    this.imageErrorMessage = 'Could not scan the selected image',
    this.footer,
    this.formats = const [],
    this.initialCameraFacing = CameraFacing.back,
  });

  EbsQrConfig copyWith({
    String? title,
    String? instruction,
    Color? accentColor,
    Color? scrimColor,
    Color? borderColor,
    Color? backgroundColor,
    Color? foregroundColor,
    double? cutOutSizeFactor,
    double? cutOutMinSize,
    double? cutOutMaxSize,
    double? cutOutRadius,
    double? cutOutCenterYFactor,
    bool? showFlash,
    bool? showGallery,
    bool? showFlip,
    bool? showScanLine,
    bool? enableHaptics,
    EbsHaptic? hapticFeedback,
    bool? enableZoom,
    double? zoomSensitivity,
    bool? showResultSheet,
    String? resultSheetTitle,
    String? copyLabel,
    String? shareLabel,
    String? useResultLabel,
    String? scanAgainLabel,
    String? copiedMessage,
    IconData? flashOnIcon,
    IconData? flashOffIcon,
    IconData? galleryIcon,
    IconData? flipIcon,
    EbsFlashButtonBuilder? flashButtonBuilder,
    EbsControlButtonBuilder? galleryButtonBuilder,
    EbsControlButtonBuilder? flipButtonBuilder,
    String? galleryLabel,
    String? noCodeFoundMessage,
    String? imageErrorMessage,
    Widget? footer,
    List<BarcodeFormat>? formats,
    CameraFacing? initialCameraFacing,
  }) {
    return EbsQrConfig(
      title: title ?? this.title,
      instruction: instruction ?? this.instruction,
      accentColor: accentColor ?? this.accentColor,
      scrimColor: scrimColor ?? this.scrimColor,
      borderColor: borderColor ?? this.borderColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      cutOutSizeFactor: cutOutSizeFactor ?? this.cutOutSizeFactor,
      cutOutMinSize: cutOutMinSize ?? this.cutOutMinSize,
      cutOutMaxSize: cutOutMaxSize ?? this.cutOutMaxSize,
      cutOutRadius: cutOutRadius ?? this.cutOutRadius,
      cutOutCenterYFactor: cutOutCenterYFactor ?? this.cutOutCenterYFactor,
      showFlash: showFlash ?? this.showFlash,
      showGallery: showGallery ?? this.showGallery,
      showFlip: showFlip ?? this.showFlip,
      showScanLine: showScanLine ?? this.showScanLine,
      enableHaptics: enableHaptics ?? this.enableHaptics,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      enableZoom: enableZoom ?? this.enableZoom,
      zoomSensitivity: zoomSensitivity ?? this.zoomSensitivity,
      showResultSheet: showResultSheet ?? this.showResultSheet,
      resultSheetTitle: resultSheetTitle ?? this.resultSheetTitle,
      copyLabel: copyLabel ?? this.copyLabel,
      shareLabel: shareLabel ?? this.shareLabel,
      useResultLabel: useResultLabel ?? this.useResultLabel,
      scanAgainLabel: scanAgainLabel ?? this.scanAgainLabel,
      copiedMessage: copiedMessage ?? this.copiedMessage,
      flashOnIcon: flashOnIcon ?? this.flashOnIcon,
      flashOffIcon: flashOffIcon ?? this.flashOffIcon,
      galleryIcon: galleryIcon ?? this.galleryIcon,
      flipIcon: flipIcon ?? this.flipIcon,
      flashButtonBuilder: flashButtonBuilder ?? this.flashButtonBuilder,
      galleryButtonBuilder: galleryButtonBuilder ?? this.galleryButtonBuilder,
      flipButtonBuilder: flipButtonBuilder ?? this.flipButtonBuilder,
      galleryLabel: galleryLabel ?? this.galleryLabel,
      noCodeFoundMessage: noCodeFoundMessage ?? this.noCodeFoundMessage,
      imageErrorMessage: imageErrorMessage ?? this.imageErrorMessage,
      footer: footer ?? this.footer,
      formats: formats ?? this.formats,
      initialCameraFacing: initialCameraFacing ?? this.initialCameraFacing,
    );
  }
}
