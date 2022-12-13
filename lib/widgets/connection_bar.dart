import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import '../main.dart';
import '../theme/color_schemes.g.dart';

class ConnectionBar extends StatefulWidget {
  const ConnectionBar({super.key});

  @override
  State<ConnectionBar> createState() => _ConnectionBarState();
}

class _ConnectionBarState extends State<ConnectionBar> {
  void refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (await ESP32.instance.state?.first == BluetoothDeviceState.connected) {
          await ESP32.instance.disconnect();
          refresh();
          return;
        }

        showScanResult(context, refresh);
      },
      child: SizedBox(
        height: 50,
        child: StreamBuilder<BluetoothDeviceState>(
            stream: ESP32.instance.state,
            initialData: BluetoothDeviceState.disconnected,
            builder: (context, snapshot) {
              Color indicatorColor = Colors.red;
              String stateText = "";

              switch (snapshot.data) {
                case BluetoothDeviceState.disconnected:
                  indicatorColor = Colors.red;
                  stateText = "Cihaz bağlı değil!";
                  break;

                case BluetoothDeviceState.connecting:
                  indicatorColor = Colors.yellow;
                  stateText = "Bağlanıyor..";
                  break;

                case BluetoothDeviceState.connected:
                  indicatorColor = Colors.green;
                  stateText = "Cihaz bağlı";
                  break;
                default:
              }

              return Row(
                children: [
                  Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: indicatorColor,
                        shape: BoxShape.circle,
                      )),
                  Text(
                    stateText,
                    style: TextStyle(fontSize: 12, color: lightColorScheme.background),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Future<void> showScanResult(BuildContext context, VoidCallback notifyParent) async {
    // TODO: if there is already scanning stop and restart
    FlutterBlue.instance.startScan(timeout: const Duration(seconds: 4));

    return showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      clipBehavior: Clip.hardEdge,
      context: context,
      builder: (BuildContext context) {
        double deviceHeight = MediaQuery.of(context).size.height;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 18, left: 12, right: 12),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(
                    "Aktif Cihazlar",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: lightColorScheme.onSurface),
                  ),
                  IconButton(
                      onPressed: () async {
                        if (await FlutterBlue.instance.isScanning.first) return;

                        FlutterBlue.instance.startScan(timeout: const Duration(seconds: 4));
                      },
                      icon: const Icon(
                        Icons.refresh,
                        size: 28,
                      ))
                ]),
                SizedBox(
                    height: deviceHeight * 0.5,
                    child: StreamBuilder<List<ScanResult>>(
                        stream: FlutterBlue.instance.scanResults,
                        initialData: const [],
                        builder: (context, snapshot) {
                          final scanResult =
                              snapshot.data!.where((e) => e.device.name.isNotEmpty).toList();

                          if (scanResult.isEmpty) {
                            return const Center(
                              child: SizedBox(
                                  height: 60, width: 60, child: CircularProgressIndicator()),
                            );
                          }

                          return ListView.separated(
                            itemCount: scanResult.length,
                            itemBuilder: (context, index) {
                              final device = scanResult[index].device;

                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                onTap: () async {
                                  // TODO: Check device which want to connect is ESP32
                                  // Connect metodunda hata var
                                  // Connect request'i attıktan sonra connect olana kadar bekliyor
                                  // Hiçbir zaman connect olmaz ise öylece kalıyor
                                  // Timeout olması halinde ise hata veriyor
                                  // Ya timeout olduğunda state beklemesi bir şekilde iptal edilecek
                                  device.connect(timeout: const Duration(seconds: 3));
                                  ESP32.instance.init(device);
                                  notifyParent();

                                  Future.delayed(Duration.zero, () {
                                    Navigator.pop(context);
                                  });
                                },
                                title: Text(device.name,
                                    style:
                                        TextStyle(fontSize: 16, color: lightColorScheme.primary)),
                              );
                            },
                            separatorBuilder: ((context, index) => Divider(
                                indent: 10,
                                endIndent: 10,
                                color: lightColorScheme.primary.withOpacity(0.5))),
                          );
                        })),
              ],
            ),
          ),
        );
      },
    );
  }
}
