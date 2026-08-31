import 'package:ebs_qrcode/ebs_qrcode.dart';
import 'package:flutter/material.dart';

/// A fully customized scanner showcasing (nearly) every `ebs_qrcode` option:
/// theming, cut-out geometry, format restriction, a re-branded footer, and the
/// full-widget builders for the flash / gallery / flip controls.
///
/// Run it from a button:
///
/// ```dart
/// final code = await const FullyCustomScanner().open(context);
/// ```
class FullyCustomScanner extends StatelessWidget {
  const FullyCustomScanner({super.key});

  /// Opens the scanner and resolves to the decoded value (or null).
  Future<String?> open(BuildContext context) =>
      EbsQrScanner.scan(context, config: _config);

  static final EbsQrConfig _config = EbsQrConfig(
    title: 'Scan to check in',
    instruction: 'Hold steady — the code scans automatically',

    // ── Theming ────────────────────────────────────────────────────────
    accentColor: const Color(0xFF7C4DFF),
    scrimColor: const Color(0xB3000000),
    foregroundColor: Colors.white,

    // ── Cut-out geometry ───────────────────────────────────────────────
    cutOutSizeFactor: 0.72,
    cutOutRadius: 22,
    cutOutCenterYFactor: 0.40,

    // ── Show/hide controls (note: showFlash, not showTorch) ────────────
    showFlash: true,
    showGallery: true,
    showFlip: true,

    // ── Full-widget overrides — the action stays wired for you ─────────
    // Flash: you get the live on/off state + a toggle callback.
    flashButtonBuilder: (context, isOn, toggle) => IconButton.filled(
      onPressed: toggle,
      isSelected: isOn,
      icon: Icon(isOn ? Icons.flash_on : Icons.flash_off),
    ),
    // Gallery: you get the "open gallery" callback.
    galleryButtonBuilder: (context, onTap) => OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.upload_file, color: Colors.white),
      label: const Text('Upload', style: TextStyle(color: Colors.white)),
    ),
    // Flip: you get the "switch camera" callback.
    flipButtonBuilder: (context, onTap) => FloatingActionButton.small(
      heroTag: 'flip',
      onPressed: onTap,
      child: const Icon(Icons.cameraswitch),
    ),

    // ── Formats + starting camera ──────────────────────────────────────
    formats: const [BarcodeFormat.qrCode, BarcodeFormat.ean13],
    initialCameraFacing: CameraFacing.back,

    // ── Branding footer ────────────────────────────────────────────────
    // App side shown by name only here so the sample runs without bundling
    // an asset. To use a logo, declare it in this app's pubspec and pass:
    //   appLogo: EbsBrandAsset.asset('assets/logo/app_logo.svg', height: 18),
    // The "Powered by Ebsor Infosystem" side is the built-in default; override
    // companyLogo / companyName to re-brand it.
    footer: const EbsBrandingFooter(appName: 'CodeBook'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fully customized')),
      body: Center(
        child: FilledButton.icon(
          onPressed: () async {
            final code = await open(context);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(code ?? 'Cancelled')),
              );
            }
          },
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text('Open scanner'),
        ),
      ),
    );
  }
}
