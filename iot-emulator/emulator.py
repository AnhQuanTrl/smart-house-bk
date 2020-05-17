import paho.mqtt.client as mqtt
import time
broker_address = 'localhost'


def on_connect(client, userdata, flags, rc):
    client.subscribe('topic/app')


def on_message(client, userdata, msg):
    print(msg.topic+" "+str(msg.payload))


client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
client.connect(broker_address, 1883, 60)
client.loop_start()
while True:
    client.publish('topic/light', 'Hey')
    time.sleep(10)
