import 'package:flutter/material.dart';
import 'package:van_control/ble_conn_tab.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:rxdart/rxdart.dart' show BehaviorSubject;

class MasterDevice {
  MasterDevice._privateConstructor();
  static final MasterDevice instance = MasterDevice._privateConstructor();

  final BehaviorSubject<bool> _isConnected = BehaviorSubject.seeded(false);
  Stream<bool> get isConnected => _isConnected.stream;

  BluetoothDevice? device;

  set setDevice(BluetoothDevice? _device) {
    _isConnected.add(_device == null ? false : true);
    device = _device;
  }
}

void main() => runApp(const MySmartVanApp());

class MySmartVanApp extends StatelessWidget {
  const MySmartVanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeTab(),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Van'),
        actions: [
          IconButton(
              icon: const Icon(Icons.bluetooth),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BleConnTab(),
                  )))
        ],
      ),
      body: Center(
          child: StreamBuilder<bool>(
        stream: MasterDevice.instance.isConnected,
        initialData: false,
        builder: ((context, snapshot) {
          String text = MasterDevice.instance.device?.name ??
              "Please Connect To Device..";

          return ReadData();
        }),
      )),
    );
  }
}

class ReadData extends StatefulWidget {
  const ReadData({Key? key}) : super(key: key);

  @override
  State<ReadData> createState() => _ReadDataState();
}

class _ReadDataState extends State<ReadData> {
  List<BluetoothService>? services;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => setState(() async {
                  services =
                      await MasterDevice.instance.device?.discoverServices();
                })),
        services != null
            ? CharacteristicTile(
                characteristic: services![2].characteristics[0],
                onReadPressed: () async =>
                    await services![2].characteristics[0].read(),
                onNotificationPressed: () async => {
                  await services![2].characteristics[0].setNotifyValue(
                      !services![2].characteristics[0].isNotifying),
                  print(await services![2].characteristics[0].read())
                },
              )
            : const Text("as")
      ],
    );
  }
}

class CharacteristicTile extends StatelessWidget {
  final BluetoothCharacteristic characteristic;
  final VoidCallback? onReadPressed;
  final VoidCallback? onWritePressed;
  final VoidCallback? onNotificationPressed;

  const CharacteristicTile(
      {Key? key,
      required this.characteristic,
      this.onReadPressed,
      this.onWritePressed,
      this.onNotificationPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: characteristic.value,
      initialData: characteristic.lastValue,
      builder: (c, snapshot) {
        final value = snapshot.data;
        return ExpansionTile(
          title: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Characteristic'),
                Text(
                    '0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Theme.of(context).textTheme.caption?.color))
              ],
            ),
            subtitle: Text(String.fromCharCodes(value!.toList())),
            contentPadding: const EdgeInsets.all(0.0),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.file_download,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
                ),
                onPressed: onReadPressed,
              ),
              IconButton(
                icon: Icon(Icons.file_upload,
                    color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
                onPressed: onWritePressed,
              ),
              IconButton(
                icon: Icon(
                    characteristic.isNotifying
                        ? Icons.sync_disabled
                        : Icons.sync,
                    color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
                onPressed: onNotificationPressed,
              )
            ],
          ),
        );
      },
    );
  }
}
