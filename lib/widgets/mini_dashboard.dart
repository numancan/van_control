import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/color_schemes.g.dart';

class MiniDashboard extends StatelessWidget {
  const MiniDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: lightColorScheme.tertiary)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const DashTile(assetName: 'assets/icons/temp.svg', title: "Sıcaklık", value: "35°C"),
          verticalDivider(),
          const DashTile(assetName: 'assets/icons/energy.svg', title: "Tüketim", value: "15 kWH"),
          verticalDivider(),
          const DashTile(assetName: 'assets/icons/energy.svg', title: "Tüketim", value: "15 kWH")
        ],
      ),
    );
  }

  SizedBox verticalDivider() {
    return SizedBox(
      height: 80,
      child: VerticalDivider(
          width: 20, thickness: 1, indent: 0, endIndent: 0, color: lightColorScheme.tertiary),
    );
  }
}

class DashTile extends StatelessWidget {
  final String assetName;
  final String title;
  final String value;

  // double? iconWidth;
  // double? iconHeight;

  const DashTile({super.key, required this.assetName, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          assetName,
          color: lightColorScheme.surface,
          width: 18,
          height: 32,
        ),
        const SizedBox(height: 8),
        Text(title,
            style: TextStyle(color: lightColorScheme.surfaceVariant, fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(color: lightColorScheme.surfaceVariant))
      ],
    );
  }
}
