import 'package:flutter/material.dart';
import '../theme/color_schemes.g.dart';
import '../main.dart';
import '../widgets/screen_top_bar.dart';

List<int> lambIndexs = [13, 12, 14, 27, 26, 25, 33, 32, 23, 22, 1, 3, 21, 19];

class Lambs extends StatelessWidget {
  const Lambs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Kusucam
    lambIndexs.sort();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const ScreenTopBar(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              GridView(
                padding: const EdgeInsets.only(top: 18),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  crossAxisCount: 4,
                ),
                children: lambIndexs.map((index) {
                  bool lambState = true;
                  return InkWell(
                    onTap: () {
                      ESP32.instance.write("switch.$index.${lambState ? 1 : 0}\n");
                      lambState = !lambState;
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: lambState
                                ? lightColorScheme.onPrimary
                                : lightColorScheme.primaryContainer,
                            borderRadius: const BorderRadius.all(Radius.circular(12))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              index.toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: lightColorScheme.primary),
                            )
                          ],
                        )),
                  );
                }).toList(),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
