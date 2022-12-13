import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

enum DeviceType {
  Lamba,
  Klima;

  String toJson() => name;
  static DeviceType fromJson(String json) => values.byName(json);
}

class Device {
  String name;
  int key;
  bool isActive = false;
  DeviceType deviceType;

  Device({required this.name, required this.key, required this.deviceType});

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
        name: json['name'], key: json['key'], deviceType: DeviceType.fromJson(json['deviceType']));
  }

  Map<String, dynamic> toJson() => {"name": name, "key": key, "deviceType": deviceType.toJson()};

  @override
  toString() => "name: $name, key: $key, deviceType: $deviceType";
}

class DeviceModel extends ChangeNotifier {
  final List<Device> _devices = [];

  List<Device> get devices => _devices;

  void add(Device device) async {
    _devices.add(device);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("devices", json.encode(_devices.map((e) => e.toJson()).toList()).toString());

    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  void remove(Device device) async {
    _devices.remove(device);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("devices", json.encode(_devices.map((e) => e.toJson()).toList()).toString());
    // Don't forget to tell dependent widgets to rebuild _every time_
    // you change the model.
    notifyListeners();
  }
}
