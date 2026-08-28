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

## Configuration (`EbsQrConfig`)

Colours (`accentColor`, `scrimColor`, `borderColor`, `backgroundColor`,
`foregroundColor`), the cut-out (`cutOutSizeFactor`, min/max size, radius,
vertical position), toggles (`showTorch`, `showGallery`, `showFlip`,
`showScanLine`), labels/messages, an optional `footer` widget, allowed
`formats`, and the initial camera facing. Every field has a sensible default.

## License

MIT — see `LICENSE`.
