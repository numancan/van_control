import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/color_schemes.g.dart';

class ScreenTopBar extends StatelessWidget {
  const ScreenTopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Cihaz Ekle'),
      backgroundColor: lightColorScheme.onPrimaryContainer,
    );
  }
}

// decoration: BoxDecoration(
//     boxShadow: [
//       BoxShadow(
//           blurRadius: 6, offset: const Offset(0, 4), color: Colors.black.withOpacity(0.3))
//     ],
//     color: lightColorScheme.onPrimaryContainer,
//     borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)))