import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Attractive circular flash (torch) button that reflects the live flash state:
/// filled with the accent colour when on, translucent when off.
class EbsFlashButton extends StatelessWidget {
  final MobileScannerController controller;
  final Color accentColor;
  final Color foregroundColor;
  final IconData onIcon;
  final IconData offIcon;

  const EbsFlashButton({
    super.key,
    required this.controller,
    required this.accentColor,
    required this.foregroundColor,
    this.onIcon = Icons.flash_on_rounded,
    this.offIcon = Icons.flash_off_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MobileScannerState>(
      valueListenable: controller,
      builder: (context, state, _) {
        final on = state.torchState == TorchState.on;
        return _EbsRoundButton(
          icon: on ? onIcon : offIcon,
          tooltip: 'Toggle flash',
          onTap: () => controller.toggleTorch(),
          background:
              on ? accentColor : foregroundColor.withValues(alpha: 0.14),
          iconColor: on ? Colors.black : foregroundColor,
          borderColor:
              on ? accentColor : foregroundColor.withValues(alpha: 0.30),
        );
      },
    );
  }
}

/// Generic circular icon button (used for camera flip).
class EbsCircleButton extends StatelessWidget {
  final IconData icon;
  final String? tooltip;
  final VoidCallback onTap;
  final Color foregroundColor;

  const EbsCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.foregroundColor,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return _EbsRoundButton(
      icon: icon,
      tooltip: tooltip,
      onTap: onTap,
      background: foregroundColor.withValues(alpha: 0.14),
      iconColor: foregroundColor,
      borderColor: foregroundColor.withValues(alpha: 0.30),
    );
  }
}

/// Rounded pill button with an icon + label (used for gallery).
class EbsPillButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color foregroundColor;

  const EbsPillButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: foregroundColor.withValues(alpha: 0.14),
      shape: StadiumBorder(
        side: BorderSide(color: foregroundColor.withValues(alpha: 0.30)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: foregroundColor, size: 20),
              const SizedBox(width: 8),
              Text(label,
                  style: TextStyle(color: foregroundColor, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}

class _EbsRoundButton extends StatelessWidget {
  final IconData icon;
  final String? tooltip;
  final VoidCallback onTap;
  final Color background;
  final Color iconColor;
  final Color borderColor;

  const _EbsRoundButton({
    required this.icon,
    required this.onTap,
    required this.background,
    required this.iconColor,
    required this.borderColor,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: background,
      shape: CircleBorder(side: BorderSide(color: borderColor)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Icon(icon, color: iconColor, size: 22),
        ),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}
