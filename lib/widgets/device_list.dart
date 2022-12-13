import 'dart:convert';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:van_control/models/device.dart';
import '../main.dart';
import '../theme/color_schemes.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceList extends StatefulWidget {
  const DeviceList({super.key});

  @override
  State<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  @override
  void initState() {
    super.initState();
    initDevices();
  }

  initDevices() async {
    DeviceModel deviceModel = context.read<DeviceModel>();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String devicesDecoded = prefs.getString('devices') ?? '';

    if (devicesDecoded.isNotEmpty) {
      List<dynamic> devices = jsonDecode(devicesDecoded);

      devices.forEach((element) {
        deviceModel.add(Device.fromJson(element));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Device> devices = context.watch<DeviceModel>().devices;

    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            " Cihazlar",
            style: TextStyle(
              fontSize: 18,
              color: lightColorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.builder(
          padding: const EdgeInsets.only(top: 18),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 64,
            mainAxisSpacing: 32,
            crossAxisCount: 2,
          ),
          itemCount: devices.length,
          itemBuilder: (context, index) {
            return DeviceTile(device: devices[index]);
          },
        )
      ],
    );
  }
}

class DeviceTile extends StatefulWidget {
  final Device device;
  const DeviceTile({super.key, required this.device});

  @override
  State<DeviceTile> createState() => _DeviceTileState();
}

class _DeviceTileState extends State<DeviceTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ESP32.instance.write("switch.${widget.device.key}.${widget.device.isActive ? 0 : 1}\n");
        widget.device.isActive = !widget.device.isActive;
        setState(() {});
      },
      child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: lightColorScheme.primaryContainer,
              borderRadius: const BorderRadius.all(Radius.circular(12))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              statusIndicator(widget.device.isActive ? Colors.green : Colors.red),
              SvgPicture.asset(
                widget.device.deviceType == DeviceType.Lamba
                    ? "assets/icons/lamp.svg"
                    : "assets/icons/ac.svg",
                color: lightColorScheme.onPrimaryContainer,
                width: 64,
                height: 64,
              ),
              Text(widget.device.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500, color: lightColorScheme.primary))
            ],
          )),
    );
  }

  Widget statusIndicator(MaterialColor color) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          )),
    );
  }
}
