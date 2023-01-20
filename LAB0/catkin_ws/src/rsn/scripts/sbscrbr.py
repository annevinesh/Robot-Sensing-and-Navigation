#!/usr/bin/env python3

import rospy
from std_msgs.msg import String

def callback(data):
    rospy.loginfo(rospy.get_caller_id() + "I heard %s", data.data)
    
def sbscrbr():


    rospy.init_node('sbscrbr', anonymous=True)

    rospy.Subscriber("cntnt", String, callback)

    rospy.spin()

if __name__ == '__main__':
    sbscrbr()
