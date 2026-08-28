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
