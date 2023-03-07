
(cl:in-package :asdf)

(defsystem "imu_driver-srv"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "convert_to_quaternion_srv" :depends-on ("_package_convert_to_quaternion_srv"))
    (:file "_package_convert_to_quaternion_srv" :depends-on ("_package"))
  ))