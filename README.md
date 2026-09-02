<h1 align="center">ebs_qrcode</h1>

<p align="center">
  <b>A highly customisable, cross-platform QR &amp; barcode scanner widget for Flutter.</b><br/>
  Modern viewfinder · flash · camera flip · scan-from-gallery · configurable branding footer.
</p>

<p align="center">
  <a href="https://pub.dev/packages/ebs_qrcode"><img src="https://img.shields.io/pub/v/ebs_qrcode?logo=dart&color=0175C2" alt="pub version"></a>
  <a href="https://pub.dev/packages/ebs_qrcode/score"><img src="https://img.shields.io/pub/points/ebs_qrcode?logo=dart&color=0175C2" alt="pub points"></a>
  <a href="https://pub.dev/packages/ebs_qrcode/score"><img src="https://img.shields.io/pub/likes/ebs_qrcode?logo=dart&color=0175C2" alt="pub likes"></a>
  <a href="https://github.com/ashiq-kodali/ebs_qrcode/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="license: MIT"></a>
  <a href="https://github.com/ashiq-kodali/ebs_qrcode/pulls"><img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" alt="PRs welcome"></a>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/ashiq-kodali/ebs_qrcode/main/doc/showcase.jpg" alt="ebs_qrcode showcase" width="100%"/>
</p>

---

## ✨ Why ebs_qrcode?

Drop a beautiful, full-screen scanner into your app in **one line** — then customise every pixel when you need to. Built on the battle-tested [`mobile_scanner`](https://pub.dev/packages/mobile_scanner), with a modern overlay, animated scan line, and a branding footer, all out of the box.

- 📷 **QR & barcodes** — scan QR codes and 1D/2D barcodes (EAN, UPC, Code128, and more).
- 🎨 **Highly customisable** — colours, cut-out size/shape/position, scan line, labels, and control icons.
- 🖼️ **Scan from gallery** — decode a code from an existing image.
- 🔦 **Flash, flip & gallery controls** — swap the icon *or* replace the whole widget while keeping the action wired.
- 🏷️ **Branding footer** — app logo + name and a "Powered by …" line, with logos in **any format** (SVG / PNG / JPEG / network / custom widget).
- 📳 **Haptic feedback** — a configurable buzz on each successful scan.
- 🔍 **Pinch-to-zoom** — zoom the camera preview with a pinch gesture.
- 🔢 **Multi-code detection** — get every code in a frame via `onMultiDetect`.
- 🧾 **Built-in result sheet** — optional sheet with copy / share / scan-again.
- ⚡ **Lightweight & fast** — a thin, well-documented layer with sensible defaults.

## 📱 Platforms

| Android | iOS | macOS | Web |
|:-------:|:---:|:-----:|:---:|
|   ✅    | ✅  |  ✅   | ✅  |

> Camera + gallery availability follows the underlying `mobile_scanner` / `image_picker` support for each platform.

## 🚀 Getting started

Add the dependency:

```yaml
dependencies:
  ebs_qrcode: ^0.2.0
```

```bash
flutter pub add ebs_qrcode
```

### Permissions

- **iOS** — add to `Info.plist`:
  - `NSCameraUsageDescription` — "Used to scan QR codes and barcodes."
  - `NSPhotoLibraryUsageDescription` — "Used to scan a code from a photo." *(gallery scanning)*
- **Android** — the plugins declare the `CAMERA` permission via manifest merge; use `minSdkVersion 21+`.

## ⚡ Quick start

Push the scanner and await the decoded value:

```dart
import 'package:ebs_qrcode/ebs_qrcode.dart';

final code = await EbsQrScanner.scan(context);
if (code != null) {
  debugPrint('Scanned: $code');
}
```

Customise it:

```dart
final code = await EbsQrScanner.scan(
  context,
  config: const EbsQrConfig(
    title: 'Scan to sign in',
    accentColor: Color(0xFF3BBCE5),
    formats: [BarcodeFormat.qrCode],
    showFlip: false,
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

## 🏷️ Branding footer

Add a polished branding line — your **app logo + name** on the left and a **"Powered by …"** on the right — with `EbsBrandingFooter`:

```dart
EbsQrConfig(
  footer: EbsBrandingFooter(
    appLogo: EbsBrandAsset.asset('assets/logo/app_logo.svg'), // any format
    appName: 'CodeBook',
    // The "Powered by" side is a sensible default; override to re-brand:
    // companyName: 'Acme Inc',
    // companyLogo: EbsBrandAsset.asset('assets/acme.png'),
    // showPoweredBy: false, // …or hide it entirely
  ),
);
```

`EbsBrandAsset` renders a logo from **any** source, at **any** size:

```dart
EbsBrandAsset.asset('assets/logo.svg', height: 20);   // auto-detects SVG/raster
EbsBrandAsset.asset('assets/logo.png', height: 20, color: Colors.white);
EbsBrandAsset.networkAuto('https://example.com/logo.svg');
EbsBrandAsset.custom(const FlutterLogo());
```

> SVG rendering is powered by [`flutter_svg`](https://pub.dev/packages/flutter_svg).

## 🎛️ Custom controls (flash / gallery / flip)

**Swap just the icon** — the quickest option:

```dart
EbsQrConfig(
  flashOnIcon: Icons.flashlight_on_rounded,
  flashOffIcon: Icons.flashlight_off_rounded,
  galleryIcon: Icons.image_outlined,
  flipIcon: Icons.cameraswitch_outlined,
);
```

**Replace the whole widget** — supply your own button; the scanner keeps wiring the action:

```dart
EbsQrConfig(
  // Flash builder receives the live on/off state + a toggle callback.
  flashButtonBuilder: (context, isOn, toggle) => IconButton.filled(
    onPressed: toggle,
    icon: Icon(isOn ? Icons.flash_on : Icons.flash_off),
  ),
  // Gallery / flip builders receive just the action callback.
  galleryButtonBuilder: (context, onTap) =>
      TextButton(onPressed: onTap, child: const Text('Upload')),
  flipButtonBuilder: (context, onTap) => FloatingActionButton.small(
    onPressed: onTap,
    child: const Icon(Icons.cameraswitch),
  ),
);
```

## 📳 Haptics

A short haptic fires on every successful scan (camera or gallery). Tune or turn
it off:

```dart
EbsQrConfig(
  enableHaptics: true,                 // default
  hapticFeedback: EbsHaptic.medium,    // light / medium / heavy / selection / vibrate
);
```

## 🔍 Pinch-to-zoom

Enabled by default — pinch the preview to zoom. Tune or disable it:

```dart
EbsQrConfig(
  enableZoom: true,        // default
  zoomSensitivity: 1.0,    // higher = faster zoom
);
```

## 🔢 Multi-code detection

Get **every** code found in a frame (the scanner keeps running so you drive the
flow):

```dart
EbsQrScanner(
  onMultiDetect: (codes) => debugPrint('Found ${codes.length}: $codes'),
);
```

## 🧾 Built-in result sheet

Show a sheet with the value + **Copy** / **Scan again** (and **Share** when you
provide `onShareResult`) instead of returning immediately:

```dart
EbsQrScanner(
  config: const EbsQrConfig(showResultSheet: true),
  onShareResult: (code) => Share.share(code), // optional; your share plugin
);
```

Copy uses the built-in clipboard — no extra dependency. Share is delegated to
your own plugin via `onShareResult`, so the package stays dependency-light.

## 🔧 Configuration reference (`EbsQrConfig`)

| Group | Fields |
|---|---|
| **Text** | `title`, `instruction`, `galleryLabel`, `noCodeFoundMessage`, `imageErrorMessage` |
| **Colours** | `accentColor`, `scrimColor`, `borderColor`, `backgroundColor`, `foregroundColor` |
| **Cut-out** | `cutOutSizeFactor`, `cutOutMinSize`, `cutOutMaxSize`, `cutOutRadius`, `cutOutCenterYFactor` |
| **Toggles** | `showFlash`, `showGallery`, `showFlip`, `showScanLine` |
| **Control icons** | `flashOnIcon`, `flashOffIcon`, `galleryIcon`, `flipIcon` |
| **Control widgets** | `flashButtonBuilder`, `galleryButtonBuilder`, `flipButtonBuilder` |
| **Branding** | `footer` (see `EbsBrandingFooter`) |
| **Haptics** | `enableHaptics`, `hapticFeedback` (`EbsHaptic.light/medium/heavy/selection/vibrate`) |
| **Zoom** | `enableZoom`, `zoomSensitivity` |
| **Result sheet** | `showResultSheet`, `resultSheetTitle`, `copyLabel`, `shareLabel`, `useResultLabel`, `scanAgainLabel`, `copiedMessage` |
| **Scanning** | `formats`, `initialCameraFacing` |

Callbacks live on the `EbsQrScanner` widget: `onDetect` (single),
`onMultiDetect` (all codes in a frame), and `onShareResult` (result-sheet share).

Every field has a sensible default — `const EbsQrConfig()` gives a polished scanner out of the box.

## 🧑‍💻 Full example

See a fully-customised scanner (theming, cut-out geometry, format restriction, re-branded footer, and all three control builders) in
[`example/lib/fully_custom.dart`](https://github.com/ashiq-kodali/ebs_qrcode/blob/main/example/lib/fully_custom.dart), and a minimal one in
[`example/lib/main.dart`](https://github.com/ashiq-kodali/ebs_qrcode/blob/main/example/lib/main.dart).

## 🗺️ Roadmap (planned)

These are **not yet implemented** — planned for future releases:

- [ ] Sound (beep) feedback on detect *(needs an audio dependency)*
- [ ] Tap-to-focus *(pending an upstream `mobile_scanner` focus API)*

**Recently shipped (0.2.1):** ✅ haptic feedback · ✅ pinch-to-zoom · ✅ multi-code
detection · ✅ built-in result sheet (copy / share / scan-again).

Have an idea? [Open an issue](https://github.com/ashiq-kodali/ebs_qrcode/issues) 💬

## 🤝 Contributing & collaboration

Contributions of every size are welcome and appreciated — this package grows with its community.

- 🐛 **Found a bug?** [Open an issue](https://github.com/ashiq-kodali/ebs_qrcode/issues) with steps to reproduce.
- 💡 **Have an idea?** Start a discussion or open a feature-request issue.
- 🔧 **Want to code?** Fork the repo, create a branch, and send a PR — see below.
- ⭐ **Like it?** A [pub.dev like](https://pub.dev/packages/ebs_qrcode) and a GitHub star help others find it.

```bash
git clone https://github.com/ashiq-kodali/ebs_qrcode.git
cd ebs_qrcode
flutter pub get
flutter analyze && dart format --set-exit-if-changed .
```

Please keep PRs focused, run the analyzer/formatter, and update the `CHANGELOG.md`.
Looking for a maintainer or co-author? **I'm actively open to collaboration** — reach out below. 🙌

## 👋 Author's note

Hi, I'm **Ashiq Kodali** — I built `ebs_qrcode` while working on real production apps at **Ebsor Infosystem**, because every project seemed to re-implement the same scanner UI from scratch. The goal here is a scanner that looks great by default, yet bends to *your* brand without fighting the framework.

If this package saved you time, I'd love to hear about it — and if you'd like to help shape where it goes next, let's build it together.

- 📧 Email: [itzmeask@gmail.com](mailto:itzmeask@gmail.com)
- 🐙 GitHub: [@ashiq-kodali](https://github.com/ashiq-kodali)
- 🏢 Ebsor Infosystem

## 📄 License

Released under the [MIT License](LICENSE) — free for personal and commercial use.

<p align="center"><sub>Made with 💙 for the Flutter community by Ebsor Infosystem.</sub></p>
