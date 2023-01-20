#!/usr/bin/env python3

import rospy
from std_msgs.msg import String

def pblshr():
    pub = rospy.Publisher('cntnt', String, queue_size=10)
    rospy.init_node('pblshr', anonymous=True)
    rate = rospy.Rate(10) # 10hz
    while not rospy.is_shutdown():
        hello_str = "Counter Strike %s" % rospy.get_time()
        rospy.loginfo(hello_str)
        pub.publish(hello_str)
        rate.sleep()

if __name__ == '__main__':
    try:
        pblshr()
    except rospy.ROSInterruptException:
        pass
