import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:van_control/main.dart';

class BleConnTab extends StatelessWidget {
  const BleConnTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Devices"),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) => snapshot.data!
            ? FloatingActionButton(
                onPressed: () => FlutterBlue.instance.stopScan(),
                backgroundColor: Colors.red,
                child: const Icon(Icons.stop),
              )
            : FloatingActionButton(
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: const Duration(seconds: 4)),
                child: const Icon(Icons.search)),
      ),
      body: StreamBuilder<List<ScanResult>>(
        stream: FlutterBlue.instance.scanResults,
        initialData: const [],
        builder: (context, snapshot) {
          final data =
              snapshot.data!.where((e) => e.device.name.isNotEmpty).toList();

          return ListView.builder(
              itemCount: data.length,
              itemBuilder: ((context, index) {
                final device = data[index].device;
                return ListTile(
                    title: Text(device.name),
                    trailing: StreamBuilder<BluetoothDeviceState>(
                      stream: device.state,
                      builder: (context, snapshot) {
                        VoidCallback? onPressed;
                        String text;
                        switch (snapshot.data) {
                          case BluetoothDeviceState.connected:
                            MasterDevice.instance.setDevice = device;

                            onPressed = () => {device.disconnect()};
                            text = 'DISCONNECT';
                            break;
                          case BluetoothDeviceState.disconnected:
                            MasterDevice.instance.setDevice = null;

                            onPressed = () => device.connect();
                            text = 'CONNECT';
                            break;
                          default:
                            onPressed = null;
                            text = snapshot.data
                                .toString()
                                .substring(21)
                                .toUpperCase();
                            break;
                        }
                        return TextButton(
                          onPressed: onPressed,
                          child: Text(text),
                        );
                      },
                    ));
              }));
        },
      ),
    );
  }
}
