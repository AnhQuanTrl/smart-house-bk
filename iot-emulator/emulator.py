import paho.mqtt.client as mqtt
import time
import json
from device import *
broker_address = 'localhost'
light_sensors = [LightSensor("Light"), LightSensor("Light2")]
lights = [Light("LightD"), Light("LightD2")]


def on_connect(client, userdata, flags, rc):
    client.subscribe('Topic/LightD')


def on_message(client, userdata, msg):
    if msg.topic == 'Topic/LightD':
        m_decode = str(msg.payload.decode('utf-8'))
        print(m_decode)
        light_values = json.loads(m_decode)
        for light_value in light_values:
            light = list(filter(lambda x: x.device_id == light_value['device_id'], lights))[0]
            light.change(light_value['values'])
        client.publish('Topic/LightD', msg)


client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
client.connect(broker_address, 1883, 60)
client.loop_start()

while True:
    client.publish('Topic/Light', json.dumps([obj.__dict__ for obj in light_sensors]))
    for sensor in light_sensors:
        #client.publish('Topic/Light', json.dumps(sensor.__dict__))
        sensor.change_light()
    # for light in lights:
    #     client.publish('topic/iot', json.dumps(light.__dict__))
    time.sleep(5)
