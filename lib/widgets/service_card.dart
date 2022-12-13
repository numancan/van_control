import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/color_schemes.g.dart';

class ServiceCard extends StatelessWidget {
  final String icon;
  final String title;
  final Widget route;

  const ServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => route)),
      child: Container(
          decoration: BoxDecoration(
              color: lightColorScheme.primaryContainer,
              borderRadius: const BorderRadius.all(Radius.circular(12))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                color: lightColorScheme.onPrimaryContainer,
                width: 64,
                height: 64,
              ),
              const SizedBox(height: 14),
              Text(
                textAlign: TextAlign.center,
                title,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500, color: lightColorScheme.primary),
              )
            ],
          )),
    );
  }
}
