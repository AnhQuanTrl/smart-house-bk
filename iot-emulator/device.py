import json
class LightSensor:
    def __init__(self, id):
        self.device_id = id
        self.values = ["0"]

    def change_light(self):
        self.values[0] = str((int(self.values[0]) + 20) % 255)

class Light:
    def __init__(self, id):
        self.id = id
        self.values = ["0", "255"]

    def change(self, value):
        self.values = value
