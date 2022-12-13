import 'package:flutter/material.dart';
import '../theme/color_schemes.g.dart';
import 'connection_bar.dart';
import 'mini_dashboard.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Size.infinite.width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                blurRadius: 6, offset: const Offset(0, 4), color: Colors.black.withOpacity(0.3))
          ],
          color: lightColorScheme.onPrimaryContainer,
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24))),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hoşgeldiniz!",
                        style: TextStyle(fontSize: 24, color: lightColorScheme.surface),
                      ),
                      ConnectionBar(),
                      const SizedBox(height: 30),
                      MiniDashboard()
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 24)
        ],
      ),
    );
  }
}
