import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/models/devices/light_sensor.dart';
import 'package:smarthouse/models/trigger.dart';
import 'package:smarthouse/providers/dialog_provider.dart';

class AddTriggerForm extends StatefulWidget {
  final LightSensor lightSensor;

  const AddTriggerForm({Key key, this.lightSensor}) : super(key: key);

  @override
  _AddTriggerFormState createState() => _AddTriggerFormState();
}

class _AddTriggerFormState extends State<AddTriggerForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _options = [
    DropdownMenuItem<bool>(
      child: Text('off if less than'),
      value: false,
    ),
    DropdownMenuItem(
      child: Text('on if more than'),
      value: true,
    ),
  ];

  Map<String, Object> _formData = {
    "deviceName": "",
    "triggerValue": null,
    "releaseValue": null
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(top: 0, bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      content: Form(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Add New Trigger",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Trigger device"),
                    keyboardType: TextInputType.text,
                    onSaved: (value) {
                      _formData['deviceName'] = value;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "On after value"),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      if (value.isNotEmpty)
                        _formData['triggerValue'] = int.parse(value);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Off before value"),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      if (value.isNotEmpty)
                        _formData['releaseValue'] = int.parse(value);
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Center(
                        child: FlatButton(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                                fontSize: 20, color: Colors.orangeAccent),
                          ),
                          onPressed: () {
                            _submit();
                          },
                        ),
                      )
              ],
            ),
          ),
        ),
        key: _formKey,
      ),
    );
  }

  Future<void> _submit() async {
    DialogProvider dialogProvider =
        Provider.of<DialogProvider>(context, listen: false);
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.lightSensor.addTrigger(_formData);
      Navigator.of(context).pop();
    } catch (e) {
      Navigator.of(context).pop();
      dialogProvider.showCustomDialog(e.toString(), context, isSuccess: false);
    }
    setState(() {
      _isLoading = false;
    });
  }
}
