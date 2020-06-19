import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/models/devices/light_bulb.dart';
import 'package:smarthouse/providers/device_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

class LightBulbDetailsPage extends StatelessWidget {
  static const String routeName = "/light-bulb";
  final int id;

  const LightBulbDetailsPage({this.id});
  @override
  Widget build(BuildContext context) {
    LightBulb lb = Provider.of<DeviceProvider>(context, listen: false)
        .findById(id) as LightBulb;
    return ChangeNotifierProvider.value(
      value: lb,
      child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            title: Text("Light Bulb " + lb.name),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(15.0), child: LightBulbSettings()),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: LightIndicator(),
                )
              ],
            ),
          )),
    );
  }
}

class LightBulbSettings extends StatefulWidget {
  @override
  _LightBulbSettingsState createState() => _LightBulbSettingsState();
}

class _LightBulbSettingsState extends State<LightBulbSettings> {
  TextEditingController _controller = new TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    LightBulb lb = Provider.of<LightBulb>(context, listen: false);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        SizedBox(
          width: 200,
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Change Light"),
            controller: _controller,
          ),
        ),
        RaisedButton(
          child: Text("Submit"),
          onPressed: () async {
            try {
              int value = int.parse(_controller.text);
              if (value < 0 || value > 255) {
                throw Exception("Unaccepted value");
              }
              _controller.text = "";
              await lb.changeValue(value);
            } catch (e) {
              _showErrorDialog(e.toString());
            }
          },
        )
      ],
    );
  }
}

class LightIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int value = context.watch<LightBulb>().value;
    print(value);
    return LinearPercentIndicator(
      width: 200.0,
      animation: true,
      animationDuration: 1000,
      lineHeight: 30.0,
      percent: value / 255,
      center: Text(
        value.toString(),
        style: new TextStyle(fontSize: 12.0),
      ),
      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(
          Icons.lightbulb_outline,
          color: Colors.grey,
        ),
      ),
      trailing: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(
          Icons.lightbulb_outline,
          color: Colors.yellow,
        ),
      ),
      backgroundColor: Colors.grey,
      progressColor: Colors.yellow,
    );
  }
}
