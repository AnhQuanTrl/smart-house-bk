import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/models/devices/light_sensor.dart';
import 'package:smarthouse/models/trigger.dart';

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
    "triggerValue": 0,
    "mode": false
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Visibility(
            visible: !_isLoading,
            child: Positioned(
              right: -40.0,
              top: -40.0,
              child: InkResponse(
                onTap: () => Navigator.of(context).pop(),
                child: CircleAvatar(
                  child: Icon(Icons.close),
                  backgroundColor: Colors.red,
                ),
              ),
            ),
          ),
          Form(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Trigger device"),
                    keyboardType: TextInputType.text,
                    onSaved: (value) {
                      _formData['deviceName'] = value;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: DropdownButton(
                    hint: Text('Choose Trigger Type'),
                    items: _options,
                    value: _formData['mode'],
                    onChanged: (value) {
                      setState(() {
                        _formData['mode'] = value;
                      });
                    },
                    isExpanded: true,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "At value"),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _formData['triggerValue'] = int.parse(value);
                    },
                  ),
                ),
                _isLoading
                    ? CircularProgressIndicator()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text("Submit"),
                          onPressed: () {
                            _submit();
                          },
                        ),
                      )
              ],
            ),
            key: _formKey,
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    widget.lightSensor.addTrigger(_formData);
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }
}
