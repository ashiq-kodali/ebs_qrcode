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
      config: const EbsQrConfig(
        title: 'Scan a code',
        accentColor: Color(0xFF3BBCE5),
        // Swap any control icon for your own.
        galleryIcon: Icons.image_outlined,
        flipIcon: Icons.cameraswitch_outlined,
        torchOnIcon: Icons.flashlight_on_rounded,
        torchOffIcon: Icons.flashlight_off_rounded,
        // Branding footer: your app logo + name on the left, and the default
        // "Powered by Ebsor Infosystem" on the right (override to re-brand).
        footer: EbsBrandingFooter(
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
