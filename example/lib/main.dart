import 'package:ebs_qrcode/ebs_qrcode.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ebs_qrcode example',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _result;

  Future<void> _scan() async {
    final code = await EbsQrScanner.scan(
      context,
      config: EbsQrConfig(
        title: 'Scan a code',
        accentColor: const Color(0xFF3BBCE5),
        // Simplest customization — just swap the control icons.
        galleryIcon: Icons.image_outlined,
        flipIcon: Icons.cameraswitch_outlined,
        flashOnIcon: Icons.flashlight_on_rounded,
        flashOffIcon: Icons.flashlight_off_rounded,
        // Full-widget override — replace the entire flip button while the
        // scanner keeps wiring the flip action for you.
        flipButtonBuilder: (context, onTap) => FloatingActionButton.small(
          heroTag: 'flip',
          onPressed: onTap,
          child: const Icon(Icons.cameraswitch),
        ),
        // Branding footer: your app logo + name on the left, and the default
        // "Powered by Ebsor Infosystem" on the right (override to re-brand).
        footer: const EbsBrandingFooter(
          // appLogo: EbsBrandAsset.asset('assets/logo/app_logo.svg'),
          appName: 'CodeBook',
        ),
      ),
    );
    setState(() => _result = code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ebs_qrcode example')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_result == null ? 'No scan yet' : 'Scanned: $_result'),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _scan,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan'),
            ),
          ],
        ),
      ),
    );
  }
}
