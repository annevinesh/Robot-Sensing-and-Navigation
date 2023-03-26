;; Auto-generated. Do not edit!


(when (boundp 'fused_driver::Vectornav)
  (if (not (find-package "FUSED_DRIVER"))
    (make-package "FUSED_DRIVER"))
  (shadow 'Vectornav (find-package "FUSED_DRIVER")))
(unless (find-package "FUSED_DRIVER::VECTORNAV")
  (make-package "FUSED_DRIVER::VECTORNAV"))

(in-package "ROS")
;;//! \htmlinclude Vectornav.msg.html
(if (not (find-package "SENSOR_MSGS"))
  (ros::roseus-add-msgs "sensor_msgs"))
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass fused_driver::Vectornav
  :super ros::object
  :slots (_Header _imu _mag_field _Vectornav ))

(defmethod fused_driver::Vectornav
  (:init
   (&key
    ((:Header __Header) (instance std_msgs::Header :init))
    ((:imu __imu) (instance sensor_msgs::Imu :init))
    ((:mag_field __mag_field) (instance sensor_msgs::MagneticField :init))
    ((:Vectornav __Vectornav) "")
    )
   (send-super :init)
   (setq _Header __Header)
   (setq _imu __imu)
   (setq _mag_field __mag_field)
   (setq _Vectornav (string __Vectornav))
   self)
  (:Header
   (&rest __Header)
   (if (keywordp (car __Header))
       (send* _Header __Header)
     (progn
       (if __Header (setq _Header (car __Header)))
       _Header)))
  (:imu
   (&rest __imu)
   (if (keywordp (car __imu))
       (send* _imu __imu)
     (progn
       (if __imu (setq _imu (car __imu)))
       _imu)))
  (:mag_field
   (&rest __mag_field)
   (if (keywordp (car __mag_field))
       (send* _mag_field __mag_field)
     (progn
       (if __mag_field (setq _mag_field (car __mag_field)))
       _mag_field)))
  (:Vectornav
   (&optional __Vectornav)
   (if __Vectornav (setq _Vectornav __Vectornav)) _Vectornav)
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _Header
    (send _Header :serialization-length)
    ;; sensor_msgs/Imu _imu
    (send _imu :serialization-length)
    ;; sensor_msgs/MagneticField _mag_field
    (send _mag_field :serialization-length)
    ;; string _Vectornav
    4 (length _Vectornav)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _Header
       (send _Header :serialize s)
     ;; sensor_msgs/Imu _imu
       (send _imu :serialize s)
     ;; sensor_msgs/MagneticField _mag_field
       (send _mag_field :serialize s)
     ;; string _Vectornav
       (write-long (length _Vectornav) s) (princ _Vectornav s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _Header
     (send _Header :deserialize buf ptr-) (incf ptr- (send _Header :serialization-length))
   ;; sensor_msgs/Imu _imu
     (send _imu :deserialize buf ptr-) (incf ptr- (send _imu :serialization-length))
   ;; sensor_msgs/MagneticField _mag_field
     (send _mag_field :deserialize buf ptr-) (incf ptr- (send _mag_field :serialization-length))
   ;; string _Vectornav
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _Vectornav (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;;
   self)
  )

(setf (get fused_driver::Vectornav :md5sum-) "f5da213f855be49e15ef0f2ad1aaea34")
(setf (get fused_driver::Vectornav :datatype-) "fused_driver/Vectornav")
(setf (get fused_driver::Vectornav :definition-)
      "Header Header
sensor_msgs/Imu imu
sensor_msgs/MagneticField mag_field
string Vectornav

================================================================================
MSG: std_msgs/Header
# Standard metadata for higher-level stamped data types.
# This is generally used to communicate timestamped data 
# in a particular coordinate frame.
# 
# sequence ID: consecutively increasing ID 
uint32 seq
#Two-integer timestamp that is expressed as:
# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
# time-handling sugar is provided by the client library
time stamp
#Frame this data is associated with
string frame_id

================================================================================
MSG: sensor_msgs/Imu
# This is a message to hold data from an IMU (Inertial Measurement Unit)
#
# Accelerations should be in m/s^2 (not in g's), and rotational velocity should be in rad/sec
#
# If the covariance of the measurement is known, it should be filled in (if all you know is the 
# variance of each measurement, e.g. from the datasheet, just put those along the diagonal)
# A covariance matrix of all zeros will be interpreted as \"covariance unknown\", and to use the
# data a covariance will have to be assumed or gotten from some other source
#
# If you have no estimate for one of the data elements (e.g. your IMU doesn't produce an orientation 
# estimate), please set element 0 of the associated covariance matrix to -1
# If you are interpreting this message, please check for a value of -1 in the first element of each 
# covariance matrix, and disregard the associated estimate.

Header header

geometry_msgs/Quaternion orientation
float64[9] orientation_covariance # Row major about x, y, z axes

geometry_msgs/Vector3 angular_velocity
float64[9] angular_velocity_covariance # Row major about x, y, z axes

geometry_msgs/Vector3 linear_acceleration
float64[9] linear_acceleration_covariance # Row major x, y z 

================================================================================
MSG: geometry_msgs/Quaternion
# This represents an orientation in free space in quaternion form.

float64 x
float64 y
float64 z
float64 w

================================================================================
MSG: geometry_msgs/Vector3
# This represents a vector in free space. 
# It is only meant to represent a direction. Therefore, it does not
# make sense to apply a translation to it (e.g., when applying a 
# generic rigid transformation to a Vector3, tf2 will only apply the
# rotation). If you want your data to be translatable too, use the
# geometry_msgs/Point message instead.

float64 x
float64 y
float64 z
================================================================================
MSG: sensor_msgs/MagneticField
 # Measurement of the Magnetic Field vector at a specific location.

 # If the covariance of the measurement is known, it should be filled in
 # (if all you know is the variance of each measurement, e.g. from the datasheet,
 #just put those along the diagonal)
 # A covariance matrix of all zeros will be interpreted as \"covariance unknown\",
 # and to use the data a covariance will have to be assumed or gotten from some
 # other source


 Header header                        # timestamp is the time the
                                      # field was measured
                                      # frame_id is the location and orientation
                                      # of the field measurement

 geometry_msgs/Vector3 magnetic_field # x, y, and z components of the
                                      # field vector in Tesla
                                      # If your sensor does not output 3 axes,
                                      # put NaNs in the components not reported.

 float64[9] magnetic_field_covariance # Row major about x, y, z axes
                                      # 0 is interpreted as variance unknown
")



(provide :fused_driver/Vectornav "f5da213f855be49e15ef0f2ad1aaea34")


