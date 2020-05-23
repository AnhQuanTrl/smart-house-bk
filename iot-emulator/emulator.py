import paho.mqtt.client as mqtt
import time
import json
from device import *
broker_address = 'localhost'
light_sensors = [LightSensor("ls1"), LightSensor("ls2")]
lights = [Light("lb3"), Light("lb4")]


def on_connect(client, userdata, flags, rc):
    client.subscribe('topic/app')


def on_message(client, userdata, msg):
    if msg.topic == 'topic/app':
        m_decode = str(msg.payload.decode('utf-8'))
        print(m_decode)
        light_value = json.loads(m_decode)
        light = next(filter(lambda x: x.id == light_value['id'], lights))
        light.toggle(light_value['mode'])


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
