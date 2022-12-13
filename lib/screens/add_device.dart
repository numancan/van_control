// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:van_control/models/device.dart';
import '../theme/color_schemes.g.dart';

class AddDeviceScreen extends StatelessWidget {
  AddDeviceScreen({super.key});
  final Device _newDevice = Device(name: "", key: -1, deviceType: DeviceType.Lamba);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Cihaz Ekle', style: TextStyle(color: lightColorScheme.onPrimary, fontSize: 18)),
        backgroundColor: lightColorScheme.onPrimaryContainer,
        iconTheme: IconThemeData(color: lightColorScheme.onPrimary),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DevicesDropdown(onSaved: (value) => _newDevice.deviceType = value!),
                  const SizedBox(height: 18),
                  textField("İsim", (value) => _newDevice.name = value!),
                  const SizedBox(height: 18),
                  textField(
                      "Cihaz Anahtarı",
                      digitOnly: true,
                      (value) => _newDevice.key = int.parse(value!)),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          DeviceModel deviceModel = context.read<DeviceModel>();
                          deviceModel.add(_newDevice);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Ekle'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration inputDecoration(String labelText) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(color: lightColorScheme.tertiary, fontSize: 12),
    counterText: "",
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: lightColorScheme.primary)),
  );
}

TextFormField textField(String labelText, Function(String?) onSaved,
    {bool digitOnly = false, int? maxLength}) {
  return TextFormField(
    maxLength: maxLength,
    keyboardType: digitOnly ? TextInputType.number : null,
    inputFormatters:
        digitOnly ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly] : null,
    decoration: inputDecoration(labelText),
    onSaved: onSaved,
    validator: (value) => value!.isEmpty ? "Boş olamaz" : null,
  );
}

class DevicesDropdown extends StatefulWidget {
  final Function(DeviceType?) onSaved;
  const DevicesDropdown({super.key, required this.onSaved});

  @override
  State<DevicesDropdown> createState() => _DevicesDropdownState();
}

class _DevicesDropdownState extends State<DevicesDropdown> {
  DeviceType? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<DeviceType>(
      isExpanded: true,
      value: dropdownValue,
      style: TextStyle(color: lightColorScheme.primary),
      decoration: inputDecoration("Cihaz Tipi"),
      onChanged: (DeviceType? value) => setState(() {
        dropdownValue = value!;
      }),
      onSaved: widget.onSaved,
      validator: (value) => value == null ? "Boş olamaz" : null,
      // onSaved: (value) => print(value),
      items: DeviceType.values.map<DropdownMenuItem<DeviceType>>((DeviceType value) {
        return DropdownMenuItem<DeviceType>(value: value, child: Text(describeEnum(value)));
      }).toList(),
    );
  }
}
