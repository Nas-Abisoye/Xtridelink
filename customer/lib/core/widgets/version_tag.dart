import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionTag extends StatelessWidget {
  const VersionTag({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final version = snapshot.data?.version ?? '';
        return Text('Version: $version');
      },
    );
  }
}
