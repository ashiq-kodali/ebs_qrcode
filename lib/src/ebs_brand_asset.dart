import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The source kind backing an [EbsBrandAsset].
enum EbsBrandAssetKind {
  svgAsset,
  imageAsset,
  svgNetwork,
  imageNetwork,
  custom
}

/// A logo/brand mark that can be rendered from **any** common source — an SVG
/// asset, a raster asset (PNG / JPEG / WebP / GIF / BMP), a network URL (SVG or
/// raster), or a completely custom widget — with an adjustable size and an
/// optional colour tint.
///
/// Use it for the app logo and the "powered by" company logo in
/// [EbsBrandingFooter], mixing formats freely (e.g. an SVG app logo next to a
/// PNG company logo).
///
/// ```dart
/// // Auto-detects .svg vs raster by file extension:
/// EbsBrandAsset.asset('assets/logo/app_logo.svg', height: 18);
/// EbsBrandAsset.asset('assets/logo/app_logo.png', height: 18);
///
/// // Explicit constructors (const-friendly):
/// const EbsBrandAsset.svg('assets/logo.svg', height: 16);
/// const EbsBrandAsset.image('assets/logo.png', height: 16, color: Colors.white);
///
/// // Network or a fully custom widget:
/// EbsBrandAsset.networkAuto('https://example.com/logo.svg');
/// const EbsBrandAsset.custom(FlutterLogo());
/// ```
@immutable
class EbsBrandAsset {
  /// Which kind of source this asset wraps.
  final EbsBrandAssetKind kind;

  /// Asset path or network URL (null for [EbsBrandAssetKind.custom]).
  final String? source;

  /// Custom widget (only for [EbsBrandAssetKind.custom]).
  final Widget? child;

  /// Explicit height in logical pixels. Falls back to the caller's default.
  final double? height;

  /// Explicit width in logical pixels. Usually left null so the logo scales by
  /// [height] while preserving its aspect ratio.
  final double? width;

  /// Optional tint. For SVG/raster this recolours the mark via `srcIn`, handy
  /// for making a coloured logo match [foregroundColor] on the scanner scrim.
  final Color? color;

  /// The package that owns the asset (set automatically for bundled defaults).
  final String? package;

  /// How the mark is inscribed into its box.
  final BoxFit fit;

  const EbsBrandAsset._({
    required this.kind,
    this.source,
    this.child,
    this.height,
    this.width,
    this.color,
    this.package,
    this.fit = BoxFit.contain,
  });

  /// An SVG asset bundled with your app (or a [package]).
  const EbsBrandAsset.svg(
    String assetPath, {
    double? height,
    double? width,
    Color? color,
    String? package,
    BoxFit fit = BoxFit.contain,
  }) : this._(
          kind: EbsBrandAssetKind.svgAsset,
          source: assetPath,
          height: height,
          width: width,
          color: color,
          package: package,
          fit: fit,
        );

  /// A raster asset (PNG / JPEG / WebP / GIF / BMP) bundled with your app.
  const EbsBrandAsset.image(
    String assetPath, {
    double? height,
    double? width,
    Color? color,
    String? package,
    BoxFit fit = BoxFit.contain,
  }) : this._(
          kind: EbsBrandAssetKind.imageAsset,
          source: assetPath,
          height: height,
          width: width,
          color: color,
          package: package,
          fit: fit,
        );

  /// An SVG fetched from the network.
  const EbsBrandAsset.svgNetwork(
    String url, {
    double? height,
    double? width,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) : this._(
          kind: EbsBrandAssetKind.svgNetwork,
          source: url,
          height: height,
          width: width,
          color: color,
          fit: fit,
        );

  /// A raster image fetched from the network.
  const EbsBrandAsset.imageNetwork(
    String url, {
    double? height,
    double? width,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) : this._(
          kind: EbsBrandAssetKind.imageNetwork,
          source: url,
          height: height,
          width: width,
          color: color,
          fit: fit,
        );

  /// A fully custom widget — use when you need something the other
  /// constructors can't express.
  const EbsBrandAsset.custom(
    Widget child, {
    double? height,
    double? width,
  }) : this._(
          kind: EbsBrandAssetKind.custom,
          child: child,
          height: height,
          width: width,
        );

  /// Builds an asset from a local path, auto-detecting SVG vs raster by the
  /// `.svg` file extension. Not `const` because of the runtime check.
  factory EbsBrandAsset.asset(
    String assetPath, {
    double? height,
    double? width,
    Color? color,
    String? package,
    BoxFit fit = BoxFit.contain,
  }) {
    final isSvg = assetPath.toLowerCase().endsWith('.svg');
    return isSvg
        ? EbsBrandAsset.svg(assetPath,
            height: height,
            width: width,
            color: color,
            package: package,
            fit: fit)
        : EbsBrandAsset.image(assetPath,
            height: height,
            width: width,
            color: color,
            package: package,
            fit: fit);
  }

  /// Builds an asset from a URL, auto-detecting SVG vs raster by the `.svg`
  /// extension in the URL path.
  factory EbsBrandAsset.networkAuto(
    String url, {
    double? height,
    double? width,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) {
    final isSvg = Uri.tryParse(url)?.path.toLowerCase().endsWith('.svg') ??
        url.toLowerCase().contains('.svg');
    return isSvg
        ? EbsBrandAsset.svgNetwork(url,
            height: height, width: width, color: color, fit: fit)
        : EbsBrandAsset.imageNetwork(url,
            height: height, width: width, color: color, fit: fit);
  }

  /// Renders the mark. [fallbackHeight] and [fallbackColor] are applied only
  /// when this asset didn't specify its own [height]/[color], letting callers
  /// (e.g. the footer) supply sensible defaults while explicit values win.
  Widget build({double? fallbackHeight, Color? fallbackColor}) {
    final h = height ?? fallbackHeight;
    final tint = color ?? fallbackColor;

    switch (kind) {
      case EbsBrandAssetKind.svgAsset:
        return SvgPicture.asset(
          source!,
          height: h,
          width: width,
          fit: fit,
          package: package,
          colorFilter:
              tint == null ? null : ColorFilter.mode(tint, BlendMode.srcIn),
        );
      case EbsBrandAssetKind.imageAsset:
        return Image.asset(
          source!,
          height: h,
          width: width,
          fit: fit,
          package: package,
          color: tint,
          colorBlendMode: tint == null ? null : BlendMode.srcIn,
        );
      case EbsBrandAssetKind.svgNetwork:
        return SvgPicture.network(
          source!,
          height: h,
          width: width,
          fit: fit,
          colorFilter:
              tint == null ? null : ColorFilter.mode(tint, BlendMode.srcIn),
        );
      case EbsBrandAssetKind.imageNetwork:
        return Image.network(
          source!,
          height: h,
          width: width,
          fit: fit,
          color: tint,
          colorBlendMode: tint == null ? null : BlendMode.srcIn,
        );
      case EbsBrandAssetKind.custom:
        if (h == null && width == null) return child!;
        return SizedBox(height: h, width: width, child: child);
    }
  }
}
