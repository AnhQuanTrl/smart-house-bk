import paho.mqtt.client as mqtt
import time
from device import *
broker_address = 'localhost'
light_sensor = LightSensor(1)
light = Light(5)


def on_connect(client, userdata, flags, rc):
    client.subscribe('topic/app')


def on_message(client, userdata, msg):
    if msg.topic == 'topic/app':
        command = msg.payload.decode('UTF-8')
        print(command)
        if command == "ON":
            light.toggle(True)
        elif command == "OFF":
            light.toggle(False)


client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
client.connect(broker_address, 1883, 60)
client.loop_start()
while True:
    client.publish('topic/light', str(light_sensor) + " " + str(light))
    time.sleep(10)
