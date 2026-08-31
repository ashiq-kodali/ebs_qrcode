## 0.2.0

- Add `EbsBrandingFooter` — a built-in branding line with an app logo + name on
  the left and an overridable "Powered by …" on the right (defaults to Ebsor
  Infosystem with a bundled logo).
- Add `EbsBrandAsset` — render a logo from an SVG asset, a raster asset
  (PNG/JPEG/WebP/…), a network URL (SVG or raster, auto-detected), or a custom
  widget, with adjustable size and optional colour tint. SVG support via
  `flutter_svg`.
- Add customizable control icons to `EbsQrConfig`: `flashOnIcon`,
  `flashOffIcon`, `galleryIcon`, `flipIcon`.
- Add full-widget overrides for the flash, gallery, and flip controls
  (`flashButtonBuilder`, `galleryButtonBuilder`, `flipButtonBuilder`) — replace
  the entire button while the scanner keeps wiring the original action.
- **Breaking:** rename the "torch" API to "flash" — `showTorch` → `showFlash`.
  (New in this release; `torchOnIcon`/`torchOffIcon` are named
  `flashOnIcon`/`flashOffIcon`.)

## 0.1.1

- Replace deprecated `Color.withOpacity` with `Color.withValues(alpha:)` to
  remove analyzer warnings and avoid precision loss (fixes static-analysis
  lints on pub.dev).

## 0.1.0

- Initial release.
- Full-screen `EbsQrScanner` with a modern viewfinder overlay (scrim, rounded
  cut-out, corner accents, animated scan line).
- Attractive circular torch (flash) button that reflects the live torch state,
  plus gallery and camera-flip controls.
- Scan-from-gallery via `image_picker`.
- `EbsQrScanner.scan(context)` helper and an `onDetect` callback API.
- Fully themeable via `EbsQrConfig` (colours, cut-out, toggles, labels, footer,
  formats, camera facing).
