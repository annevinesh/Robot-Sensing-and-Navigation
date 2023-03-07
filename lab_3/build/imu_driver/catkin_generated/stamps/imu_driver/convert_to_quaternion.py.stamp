#!/usr/bin/env python3

from imu_driver.srv import convert_to_quaternion_srv,convert_to_quaternion_srvResponse
import rospy
from cmath import pi
import numpy as np

def handle_euler_angles(req):
    radr=float(req.roll)*pi/180
    radp=float(req.pitch)*pi/180
    rady=float(req.yaw)*pi/180
    
    qx = np.sin(radr/2) * np.cos(radp/2) * np.cos(rady/2) - np.cos(radr/2) * np.sin(radp/2) * np.sin(rady/2)
    qy = np.cos(radr/2) * np.sin(radp/2) * np.cos(rady/2) + np.sin(radr/2) * np.cos(radp/2) * np.sin(rady/2)
    qz = np.cos(radr/2) * np.cos(radp/2) * np.sin(rady/2) - np.sin(radr/2) * np.sin(radp/2) * np.cos(rady/2)
    qw = np.cos(radr/2) * np.cos(radp/2) * np.cos(rady/2) + np.sin(radr/2) * np.sin(radp/2) * np.sin(rady/2)
    
    return convert_to_quaternion_srvResponse(qx, qy, qz, qw)

def convert_to_quaternion_srv():
    rospy.init_node('convert_to_quaternion')
    s = rospy.Service('convert', convert_to_quaternion_srv, handle_euler_angles)
    rospy.spin()

if _name_ == "_main_":
    convert_to_quaternion_srv()