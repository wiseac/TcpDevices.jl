from time import sleep
import pdb
import clr
import sys
sys.path.append(r"C:\Program Files\Thorlabs\Kinesis")

from System import String
from System import Decimal
from System import Action
from System import UInt64
from System.Collections import *
clr.AddReference("Thorlabs.MotionControl.Controls")
clr.AddReference("Thorlabs.MotionControl.DeviceManagerCLI")
clr.AddReference("Thorlabs.MotionControl.GenericMotorCLI")
clr.AddReference("Thorlabs.MotionControl.IntegratedStepperMotorsCLI")
import Thorlabs.MotionControl.Controls
from Thorlabs.MotionControl.DeviceManagerCLI import *
from Thorlabs.MotionControl.IntegratedStepperMotorsCLI import *


def ParseDec(d):
    return float(str(d))

class LTS:
    def __init__(self):
        self.x_stage = 0
        self.y_stage = 0
        self.z_stage = 0
        self.x_serial = 0
        self.y_serial = 0
        self.z_serial = 0
        self.timeout = 60000

    def init_stage(self, serial):
        d = LongTravelStage.CreateLongTravelStage(serial)
        sleep(1)
        d.Connect(serial)
        sleep(1)
        d.EnableDevice()
        sleep(1)
        d.LoadMotorConfiguration(serial)
        return d


    def init(self):
        DeviceManagerCLI.BuildDeviceList()
        d_list = DeviceManagerCLI.GetDeviceList(45)
        print(d_list)

        if len(d_list) == 0:
            print("No Thorlabs LTS Device connected!")
            return
        elif len(d_list) == 3:
            self.x_serial, self.y_serial, self.z_serial = d_list
            print("X: ", self.x_serial)
            print("Y: ", self.y_serial)
            print("Z: ", self.z_serial)

            self.x_stage = self.init_stage(self.x_serial)
            self.y_stage = self.init_stage(self.y_serial)
            self.z_stage = self.init_stage(self.z_serial)
        else:
            raise Exception(str(len(d_list)) + " stages were detected: " + str(d_list))

    def move_x(self, pos):
        tasks = []
        self.x_stage.MoveTo(Decimal(pos), isDone(tasks))
        sleep(5)
        print(tasks)

    def move_y(self, pos):
        self.y_stage.MoveTo(Decimal(pos), IsDone)

    def move_z(self, pos):
        self.z_stage.MoveTo(Decimal(pos), IsDone)

    def home(self):
        self.x_stage.Home(self.timeout)
        self.y_stage.Home(self.timeout)
        self.z_stage.Home(self.timeout)

    def pos_x(self):
        return ParseDec(self.x_stage.Position)

    def pos_y(self):
        return ParseDec(self.y_stage.Position)

    def pos_z(self):
        return ParseDec(self.z_stage.Position)

def isDone(array):
    def isDoneHelper(taskID):
        print(taskID)
        array.append(taskID)
    return System.Action[System.UInt64](isDoneHelper)

IsDone = System.Action[System.UInt64](isDone)

pdb.set_trace()