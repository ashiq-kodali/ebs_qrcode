/// ebs_qrcode — a customizable, cross-platform QR / barcode scanner for Flutter.
///
/// Built on `mobile_scanner` (Android, iOS, macOS, web) with an optional
/// scan-from-gallery via `image_picker`. Provides a modern full-screen
/// viewfinder with a torch toggle, camera flip, animated scan line, and a
/// fully themeable overlay.
library;

export 'src/ebs_brand_asset.dart';
export 'src/ebs_branding_footer.dart';
export 'src/ebs_qr_config.dart';
export 'src/ebs_qr_scanner.dart';

// Re-export the enums used in EbsQrConfig's public API so consumers don't need
// to import mobile_scanner directly.
export 'package:mobile_scanner/mobile_scanner.dart'
    show BarcodeFormat, CameraFacing;
