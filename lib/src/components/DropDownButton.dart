import 'package:flutter/material.dart';

class DropdownButtonBox extends StatefulWidget {
  @override
  _DropdownButtonBoxState createState() {
    return _DropdownButtonBoxState();
  }
}

class _DropdownButtonBoxState extends State<DropdownButtonBox> {
  String _value;

  @override
  Widget build(BuildContext context) {

    return DropdownButton<String>(
      items: <String>["Extra Small", "Small", "Medium", "Large", "Extra Large"].map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: new Text(value),
        );
      }).toList(),
      onChanged: (String value) {
        setState(() {
          _value = value;
        });
        print(_value);
      },
      hint: Text('Size'),
      value: _value,
    );
  }
}
