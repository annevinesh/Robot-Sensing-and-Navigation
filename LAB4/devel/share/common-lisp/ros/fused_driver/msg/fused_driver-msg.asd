
(cl:in-package :asdf)

(defsystem "fused_driver-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :sensor_msgs-msg
               :std_msgs-msg
)
  :components ((:file "_package")
    (:file "Vectornav" :depends-on ("_package_Vectornav"))
    (:file "_package_Vectornav" :depends-on ("_package"))
    (:file "gps_msg" :depends-on ("_package_gps_msg"))
    (:file "_package_gps_msg" :depends-on ("_package"))
  ))