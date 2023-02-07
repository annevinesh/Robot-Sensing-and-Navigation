#!/usr/bin/env python3
import utm
import serial
import rospy
import sys
from std_msgs.msg import String
from gps_driver.msg import gps_msg

rospy.init_node('init')
port = rospy.get_param("port_number",sys.argv[1])
data = serial.Serial(port=port, baudrate=4800, timeout=5)
publish = rospy.Publisher('/gps',String,queue_size=10)
rate = rospy.Rate(10)

while 1:
	line = str(data.readline())
	liner = line.replace('\\r','')
	linen = liner.replace ('\\n','')
	splitline = linen.split(',')
	Data = gps_msg()
	
	if splitline[0] == 'b\'$GPGGA':
		ts=splitline[1]
		tssec=(float(ts[ :2]*3600)+(float(ts[2:4])*60)+float(ts[4:6]))
		Data.Header.stamp.secs = int(tssec)
		tsnsec = float(ts[6:])*10e9
		Data.Header.stamp.nsecs = int(tsnsec)
		Data.Header.frame_id = 'GPS1_Frame'
		
		latitude = splitline[2]
		longitude = splitline[4]
		Data.Latitude = float(latitude[ :2])+(float(latitude[2: ])/60)
		Data.Longitude = (float(longitude[ :3])+(float(longitude[3: ])/60))*-1
		
		daata = utm.from_latlon(Data.Latitude, Data.Longitude)
		Data.Altitude = float(splitline[9])
		Data.HDOP = float(splitline[8])
		Data.UTM_easting = daata[1]
		Data.UTM_northing = daata[0]
		Data.UTC = float(splitline[1])
		Data.Zone = daata[2]
		Data.Letter = daata[3]
		
		publish.publish(Data)
		
		
