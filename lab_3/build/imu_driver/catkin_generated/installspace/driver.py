import serial
import sys
import rospy
import numpy as np
from cmath import pi
from imu_driver.msg import Vectornav
from std_msgs.msg import String
from imu_driver.srv import convert_to_quaternion_srv

def imu_code():
    Data = Vectornav()
    Data.Header.frame_id = 'imu1_frame'
    publish = rospy.Publisher('imu', Vectornav,queue_size=10)     
    now = rospy.get_rostime()

    while True:
        line= serdata.readline()
        stringline=line.decode("utf-8")
        splitline=stringline.split(",")
        if(splitline[0]=="$VNYMR"):    

            Data.imu.header.frame_id = 'imu1_frame'
            Data.imu.header.seq +=1
            Data.imu.header.stamp.secs=now.secs
            Data.imu.header.stamp.nsecs=now.nsecs

            roll, pitch, yaw=splitline[3],splitline[2],splitline[1]
            
            rospy.wait_for_service('convert')
            try:
                convert = rospy.ServiceProxy('convert', convert_to_quaternion_srv)
                response = convert(roll,pitch,yaw)
            except rospy.ServiceException as e:
                print("Service call failed: %s"%e)

            Data.imu.orientation.x= float(response.x)
            Data.imu.orientation.y= float(response.y)
            Data.imu.orientation.z= float(response.z)
            Data.imu.orientation.w= float(response.w)
	
            Data.mag_field.header.frame_id = 'imu1_frame'
            Data.mag_field.header.seq +=1
            Data.mag_field.header.stamp.secs=now.secs
            Data.mag_field.header.stamp.nsecs=now.nsecs
            
            Data.mag_field.magnetic_field.x=float(splitline[4])
            Data.mag_field.magnetic_field.y=float(splitline[5])
            Data.mag_field.magnetic_field.z=float(splitline[6])

            Data.imu.linear_acceleration.x= float(splitline[7])
            Data.imu.linear_acceleration.y= float(splitline[8])
            Data.imu.linear_acceleration.z= float(splitline[9])

            Data.imu.angular_velocity.x= float(splitline[10])
            Data.imu.angular_velocity.y= float(splitline[11])
            Data.imu.angular_velocity.z= float(splitline[12][:-5])

            Data.Header.seq += 1
            Data.Header.stamp.secs=now.secs
            Data.Header.stamp.nsecs=now.nsecs
            Data.Vectornav = stringline    

        publish.publish(Data)
        print(Data)        

"""def convert_to_quaternions(rollr,rollp,rolly):

    radr=float(rollr)*pi/180
    radp=float(rollp)*pi/180
    rady=float(rolly)*pi/180
    
    qx = np.sin(radr/2) * np.cos(radp/2) * np.cos(rady/2) - np.cos(radr/2) * np.sin(radp/2) * np.sin(rady/2)
    qy = np.cos(radr/2) * np.sin(radp/2) * np.cos(rady/2) + np.sin(radr/2) * np.cos(radp/2) * np.sin(rady/2)
    qz = np.cos(radr/2) * np.cos(radp/2) * np.sin(rady/2) - np.sin(radr/2) * np.sin(radp/2) * np.cos(rady/2)
    qw = np.cos(radr/2) * np.cos(radp/2) * np.cos(rady/2) + np.sin(radr/2) * np.sin(radp/2) * np.sin(rady/2)
    
    return [qx, qy, qz, qw]"""
    

if True:
    try:
        rospy.init_node('imu', anonymous= True)
        serial_port = rospy.myargv(argv=sys.argv)
        main_port = serial_port[1]
        serdata = serial.Serial(port=main_port, baudrate=115200, bytesize=8, timeout = 5, stopbits= serial.STOPBITS_ONE)
        serdata.write(b"VNWRG,07,40*XX")
        imu_code()
    except rospy.ROSInterruptException:
        pass
