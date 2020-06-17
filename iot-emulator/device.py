import json
class LightSensor:
    def __init__(self, id):
        self.device_id = id
        self.values = [0]

    def change_light(self):
        self.values[0] = (self.values[0] + 100) % 1024

class Light:
    def __init__(self, id):
        self.id = id
        self.values = [0, 255]

    def change(self, value):
        self.values = value
