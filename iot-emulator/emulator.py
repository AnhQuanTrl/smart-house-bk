import paho.mqtt.client as mqtt
import time
import json
from device import *
broker_address = 'localhost'
light_sensors = [LightSensor(1), LightSensor(2)]
lights = [Light(3), Light(4)]


def on_connect(client, userdata, flags, rc):
    client.subscribe('topic/app')


def on_message(client, userdata, msg):
    if msg.topic == 'topic/app':
        m_decode = str(msg.payload.decode('utf-8'))
        print(m_decode)
        light_value = json.loads(m_decode)
        light = next(filter(lambda x: x.id == light_value['id'], lights))
        light.toggle(light_value['value'])


client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
client.connect(broker_address, 1883, 60)
client.loop_start()
while True:
    for sensor in light_sensors:
        client.publish('topic/iot', json.dumps(sensor.__dict__))
        sensor.change_light()
    for light in lights:
        client.publish('topic/iot', json.dumps(light.__dict__))
    time.sleep(10)
