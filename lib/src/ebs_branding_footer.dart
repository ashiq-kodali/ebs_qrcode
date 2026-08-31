import 'package:flutter/material.dart';

import 'ebs_brand_asset.dart';

/// A compact branding line for the bottom of [EbsQrScanner]:
///
/// ```
/// [app logo]  App Name  |  Powered by  [company logo]  Company Name
/// ```
///
/// Pass it to `EbsQrConfig(footer: ...)`. Everything is optional and has a
/// sensible default:
///
/// * The **app** side ([appLogo] + [appName]) is what usually changes per app —
///   supply your own logo in any format (SVG / PNG / JPEG / network / custom
///   widget via [EbsBrandAsset]) and your app's name.
/// * The **"Powered by"** side defaults to *Ebsor Infosystem* and its bundled
///   logo, since it rarely changes. Override [companyLogo] / [companyName] to
///   re-brand it, or set [showPoweredBy] to `false` to hide it entirely.
///
/// Sizes match the original CodeBook footer out of the box; tune them with
/// [appLogoHeight], [companyLogoHeight], and the text style fields, or by
/// giving each [EbsBrandAsset] its own explicit `height`.
///
/// ```dart
/// EbsQrConfig(
///   footer: EbsBrandingFooter(
///     appLogo: EbsBrandAsset.asset('assets/logo/app_logo.svg'),
///     appName: 'CodeBook',
///     // Powered-by side left as the Ebsor default.
///   ),
/// );
/// ```
class EbsBrandingFooter extends StatelessWidget {
  /// The app's logo (any format). Hidden when null.
  final EbsBrandAsset? appLogo;

  /// The app's name shown next to [appLogo]. Hidden when null/empty.
  final String? appName;

  /// Height applied to [appLogo] when it doesn't set its own.
  final double appLogoHeight;

  /// Text style for [appName]. Defaults to a bold white 11pt label.
  final TextStyle? appNameStyle;

  /// Whether to render the "Powered by …" segment at all.
  final bool showPoweredBy;

  /// The small "Powered by" lead-in label.
  final String poweredByLabel;

  /// The company logo for the "Powered by" segment. Defaults to the bundled
  /// Ebsor logo, tinted to [foregroundColor].
  final EbsBrandAsset? companyLogo;

  /// The company name. Defaults to `'Ebsor Infosystem'`. Hidden when empty.
  final String? companyName;

  /// Height applied to [companyLogo] when it doesn't set its own.
  final double companyLogoHeight;

  /// Base colour for text and the default company-logo tint.
  final Color foregroundColor;

  /// The bundled default company logo (Ebsor). Rendered tinted to the footer's
  /// [foregroundColor].
  static const EbsBrandAsset defaultCompanyLogo =
      EbsBrandAsset.image('assets/ebsor_logo.png', package: 'ebs_qrcode');

  const EbsBrandingFooter({
    super.key,
    this.appLogo,
    this.appName,
    this.appLogoHeight = 16,
    this.appNameStyle,
    this.showPoweredBy = true,
    this.poweredByLabel = 'Powered by',
    this.companyLogo,
    this.companyName = 'Ebsor Infosystem',
    this.companyLogoHeight = 13,
    this.foregroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final hasApp = appLogo != null || (appName != null && appName!.isNotEmpty);
    final effectiveCompanyLogo = companyLogo ?? defaultCompanyLogo;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── App side ─────────────────────────────────────────────────
          if (appLogo != null)
            appLogo!.build(
              fallbackHeight: appLogoHeight,
            ),
          if (appLogo != null && appName != null && appName!.isNotEmpty)
            const SizedBox(width: 5),
          if (appName != null && appName!.isNotEmpty)
            Text(
              appName!,
              style: appNameStyle ??
                  TextStyle(
                    color: foregroundColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
            ),

          // ── Divider between app + powered-by ─────────────────────────
          if (hasApp && showPoweredBy)
            Container(
              width: 1,
              height: 12,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: foregroundColor.withValues(alpha: 0.24),
            ),

          // ── Powered-by side ──────────────────────────────────────────
          if (showPoweredBy) ...[
            if (poweredByLabel.isNotEmpty)
              Text(
                poweredByLabel,
                style: TextStyle(
                  color: foregroundColor.withValues(alpha: 0.54),
                  fontSize: 9,
                ),
              ),
            if (poweredByLabel.isNotEmpty) const SizedBox(width: 5),
            effectiveCompanyLogo.build(
              fallbackHeight: companyLogoHeight,
              fallbackColor: foregroundColor,
            ),
            if (companyName != null && companyName!.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                companyName!,
                style: TextStyle(
                  color: foregroundColor.withValues(alpha: 0.70),
                  fontSize: 9,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
