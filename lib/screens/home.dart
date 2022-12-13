import 'package:flutter/material.dart';
import 'package:van_control/screens/add_device.dart';
import '../theme/color_schemes.g.dart';
import '../widgets/device_list.dart';
import '../widgets/home_top_bar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: lightColorScheme.background,
      body: Column(
        children: <Widget>[
          const HomeTopBar(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: DeviceList(),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: Colors.black,
        onPressed: () {
          // Device device = Device(name: "Dev${Random().nextInt(10)}", key: 1);
          // var cart = context.read<DeviceModel>();
          // cart.add(device);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDeviceScreen()),
          );

          // showAddDialog(context);
        },
        child: Icon(Icons.add, color: lightColorScheme.onPrimary),
      ),
    );
  }
}
