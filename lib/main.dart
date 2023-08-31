import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:van_control/models/device.dart';
import 'package:van_control/screens/home.dart';
import 'theme/color_schemes.g.dart';
import 'package:provider/provider.dart';

// TODO: try to make this class provider
class ESP32 {
  ESP32._privateConstructor();
  static final ESP32 instance = ESP32._privateConstructor();

  BluetoothDevice? _device;
  BluetoothCharacteristic? _rxChar;
  BluetoothCharacteristic? _txChar;

  Stream<BluetoothDeviceState>? get state => _device?.state;

  Future? disconnect() => _device?.disconnect();

  void init(BluetoothDevice bluetoothDevice) => _device = bluetoothDevice;

  void deinit() => _device = null;

  void discoverServices() async {
    List<BluetoothService> services = await _device!.discoverServices();

    _rxChar = services[2].characteristics[0];
    _txChar = services[2].characteristics[1];

    _device?.requestMtu(223);
    _rxChar?.setNotifyValue(true);
  }

  Future write(String data) async => await _txChar?.write(data.codeUnits);
  Future<List<int>?> read() async => await _rxChar?.read();
}

void main() => runApp(
    ChangeNotifierProvider(create: (context) => DeviceModel(), child: const MySmartVanApp()));

class MySmartVanApp extends StatelessWidget {
  const MySmartVanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme, fontFamily: "Poppins"),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: Home(),
    );
  }
}
