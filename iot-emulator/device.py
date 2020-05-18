import json
class LightSensor:
    def __init__(self, id):
        self.id = id
        self.light = 0

    def change_light(self):
        self.light = (self.light + 100) % 1024

    def __str__(self):
        return '{{id={}, light={}}}'.format(self.id, self.light)


class Light:
    def __init__(self, id):
        self.mode = False
        self.id = id

    def toggle(self, value):
        self.mode = value

    def __str__(self):
        return '{{id={}, mode={}}}'.format(self.id, "ON" if self.mode else "OFF")