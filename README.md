# ebs_qrcode

A customizable, cross-platform **QR / barcode scanner** widget for Flutter with a
modern viewfinder, an attractive torch (flash) button, camera flip, an animated
scan line, and **scan-from-gallery**.

Built on [`mobile_scanner`](https://pub.dev/packages/mobile_scanner) with
[`image_picker`](https://pub.dev/packages/image_picker) for gallery scanning.

## Platforms

| Android | iOS | macOS | Web |
|:------:|:---:|:-----:|:---:|
|   ✅   | ✅  |  ✅   | ✅  |

(Camera + gallery availability follows the underlying `mobile_scanner` /
`image_picker` support for each platform.)

## Install

```yaml
dependencies:
  ebs_qrcode:
    path: ../ebs_qrcode   # or a git/pub reference
```

### Permissions
- **iOS** `Info.plist`: `NSCameraUsageDescription` (and
  `NSPhotoLibraryUsageDescription` for gallery scanning).
- **Android**: the plugins declare the `CAMERA` permission via manifest merge;
  `minSdkVersion 21+`.

## Usage

Push the scanner and await the decoded value:

```dart
final code = await EbsQrScanner.scan(context);
if (code != null) {
  // use the scanned value
}
```

Customize it:

```dart
final code = await EbsQrScanner.scan(
  context,
  config: EbsQrConfig(
    title: 'Scan to sign in',
    accentColor: Color(0xFF3BBCE5),
    showFlip: false,
    formats: [BarcodeFormat.qrCode],
    footer: MyBrandFooter(),
  ),
);
```

Embed it and control navigation yourself:

```dart
EbsQrScanner(
  config: const EbsQrConfig(instruction: 'Point at a barcode'),
  onDetect: (value) => debugPrint('Scanned: $value'),
);
```

## Branding footer

Add a polished branding line — your **app logo + name** on the left and a
**"Powered by …"** on the right — with `EbsBrandingFooter`. The powered-by side
defaults to *Ebsor Infosystem* (with a bundled logo), since it rarely changes;
the app side is what you usually customize per app.

```dart
EbsQrConfig(
  footer: EbsBrandingFooter(
    appLogo: EbsBrandAsset.asset('assets/logo/app_logo.svg'), // any format
    appName: 'CodeBook',
    // Powered-by side kept as the Ebsor default. To re-brand:
    // companyName: 'Acme Inc',
    // companyLogo: EbsBrandAsset.asset('assets/acme.png'),
    // showPoweredBy: false,   // or hide it entirely
  ),
);
```

`EbsBrandAsset` renders a logo from **any** source, and you can tune its size:

```dart
EbsBrandAsset.asset('assets/logo.svg', height: 20);   // auto-detects SVG/raster
EbsBrandAsset.asset('assets/logo.png', height: 20, color: Colors.white);
EbsBrandAsset.networkAuto('https://example.com/logo.svg');
EbsBrandAsset.custom(const FlutterLogo());
```

SVG rendering uses [`flutter_svg`](https://pub.dev/packages/flutter_svg).

## Custom control icons

Swap the flashlight, gallery, and camera-flip glyphs via `EbsQrConfig`:

```dart
EbsQrConfig(
  torchOnIcon: Icons.flashlight_on_rounded,
  torchOffIcon: Icons.flashlight_off_rounded,
  galleryIcon: Icons.image_outlined,
  flipIcon: Icons.cameraswitch_outlined,
);
```

## Configuration (`EbsQrConfig`)

Colours (`accentColor`, `scrimColor`, `borderColor`, `backgroundColor`,
`foregroundColor`), the cut-out (`cutOutSizeFactor`, min/max size, radius,
vertical position), toggles (`showTorch`, `showGallery`, `showFlip`,
`showScanLine`), control icons (`torchOnIcon`, `torchOffIcon`, `galleryIcon`,
`flipIcon`), labels/messages, an optional `footer` widget (see
`EbsBrandingFooter`), allowed `formats`, and the initial camera facing. Every
field has a sensible default.

## License

MIT — see `LICENSE`.
