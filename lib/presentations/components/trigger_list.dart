import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarthouse/models/devices/light_sensor.dart';
import 'package:smarthouse/models/trigger.dart';

class TriggerList extends StatefulWidget {
  @override
  _TriggerListState createState() => _TriggerListState();
}

class _TriggerListState extends State<TriggerList> {
  bool _isLoading = true;
  @override
  void initState() {
    Provider.of<LightSensor>(context, listen: false).fetch().then((_) => {
          setState(() {
            _isLoading = false;
          })
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LightSensor lightSensor = Provider.of<LightSensor>(context);
    List<Trigger> triggers = lightSensor.triggers;
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.separated(
            itemCount: triggers.length,
            itemBuilder: (_, i) => Dismissible(
              key: UniqueKey(),
              onDismissed: (_) {
                lightSensor.deleteTrigger(triggers[i].id);
              },
              child: ListTile(
                trailing: Container(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.arrow_upward),
                            Text(triggers[i].triggerValue.toString())
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.arrow_downward),
                            Text(triggers[i].releaseValue.toString())
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                title: Text(triggers[i].control),
              ),
            ),
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey,
            ),
          );
  }
}
