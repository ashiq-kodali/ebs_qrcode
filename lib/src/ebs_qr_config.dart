import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
  final bool showTorch;
  final bool showGallery;
  final bool showFlip;
  final bool showScanLine;

  /// Control icons. Override to swap the flashlight, gallery, or camera-flip
  /// glyphs for your own. [torchOnIcon] / [torchOffIcon] reflect the live
  /// torch state.
  final IconData torchOnIcon;
  final IconData torchOffIcon;
  final IconData galleryIcon;
  final IconData flipIcon;

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
    this.showTorch = true,
    this.showGallery = true,
    this.showFlip = true,
    this.showScanLine = true,
    this.torchOnIcon = Icons.flash_on_rounded,
    this.torchOffIcon = Icons.flash_off_rounded,
    this.galleryIcon = Icons.photo_library_outlined,
    this.flipIcon = Icons.flip_camera_ios_outlined,
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
    bool? showTorch,
    bool? showGallery,
    bool? showFlip,
    bool? showScanLine,
    IconData? torchOnIcon,
    IconData? torchOffIcon,
    IconData? galleryIcon,
    IconData? flipIcon,
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
      showTorch: showTorch ?? this.showTorch,
      showGallery: showGallery ?? this.showGallery,
      showFlip: showFlip ?? this.showFlip,
      showScanLine: showScanLine ?? this.showScanLine,
      torchOnIcon: torchOnIcon ?? this.torchOnIcon,
      torchOffIcon: torchOffIcon ?? this.torchOffIcon,
      galleryIcon: galleryIcon ?? this.galleryIcon,
      flipIcon: flipIcon ?? this.flipIcon,
      galleryLabel: galleryLabel ?? this.galleryLabel,
      noCodeFoundMessage: noCodeFoundMessage ?? this.noCodeFoundMessage,
      imageErrorMessage: imageErrorMessage ?? this.imageErrorMessage,
      footer: footer ?? this.footer,
      formats: formats ?? this.formats,
      initialCameraFacing: initialCameraFacing ?? this.initialCameraFacing,
    );
  }
}
