#!/usr/bin/env python3
import utm
import serial
import rospy
import sys
from std_msgs.msg import String
from gnss_driver.msg import gnss_msg

rospy.init_node('init')
port = rospy.get_param("port_number",sys.argv[1])
data = serial.Serial(port=port, baudrate=4800, timeout=5)
publish = rospy.Publisher('/gnss',gnss_msg,queue_size=10)
rate = rospy.Rate(10)

#"code":
while 1:
	line = str(data.readline())
	liner = line.replace('\\r','')
	linen = liner.replace ('\\n','')
	splitline = linen.split(',')
	Data = gnss_msg()
	
	if splitline[0] == 'b\'$GNGGA':
		if(splitline[2]!="" and splitline[4]!="" and splitline[8]!="" and splitline[1]!=""):
			ts=splitline[1]
			print(ts)
			tssec = float(ts[:2])*3600 + float(ts[2:4])*60 + float(ts[4:6])
			Data.Header.stamp.secs = int(tssec)
			tsnsec = float(ts[6:])*10e9
			Data.Header.stamp.nsecs = int(tsnsec)
			Data.Header.frame_id = "GPS1_FRAME"
			
			latitude = splitline[2]
			longitude = splitline[4]
			fix_quality = splitline[6]
			Data.Latitude = float(latitude[ :2])+(float(latitude[2: ])/60)
			Data.Longitude = (float(longitude[ :3])+(float(longitude[3: ])/60))*-1
			
			daata = utm.from_latlon(Data.Latitude, Data.Longitude)
			Data.Altitude = float(splitline[9])
			Data.HDOP = float(splitline[8])
			Data.UTM_easting = daata[0]
			Data.UTM_northing = daata[1]
			Data.UTC = float(splitline[1])
			Data.fix_quality = int (fix_quality)
			Data.Zone = daata[2]
			Data.Letter = daata[3]
			print(Data)
			publish.publish(Data)
			print("......")
		else :
			pass
		
		
