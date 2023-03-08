bag1 = rosbag('C:\Users\Vinesh\Desktop\StatData.bag');
bagselect1 = select(bag1,'topic','/imu');
msgstruct1 = readMessages(bagselect1,'DataFormat','struct');
msgstruct1{1}.Imu.AngularVelocity.X;
msgstruct1{1}.Imu.AngularVelocity.Y;
msgstruct1{1}.Imu.AngularVelocity.Z;
msgstruct1{1}.Imu.LinearAcceleration.X;
msgstruct1{1}.Imu.LinearAcceleration.Y;
msgstruct1{1}.Imu.LinearAcceleration.Z;
msgstruct1{1}.Imu.Orientation.X;
msgstruct1{1}.Imu.Orientation.Y;
msgstruct1{1}.Imu.Orientation.Z;
msgstruct1{1}.Imu.Orientation.W;
msgstruct1{1}.Header.Stamp.Sec;

gyroX = cellfun(@(m)double(m.Imu.AngularVelocity.X),msgstruct1);
gyroY = cellfun(@(m)double(m.Imu.AngularVelocity.Y),msgstruct1);
gyroZ = cellfun(@(m)double(m.Imu.AngularVelocity.Z),msgstruct1);
accelX = cellfun(@(m)double(m.Imu.LinearAcceleration.X),msgstruct1);
accelY = cellfun(@(m)double(m.Imu.LinearAcceleration.Y),msgstruct1);
accelZ = cellfun(@(m)double(m.Imu.LinearAcceleration.Z),msgstruct1);
orienX = cellfun(@(m)double(m.Imu.Orientation.X),msgstruct1);
orienY = cellfun(@(m)double(m.Imu.Orientation.Y),msgstruct1);
orienZ = cellfun(@(m)double(m.Imu.Orientation.Z),msgstruct1);
orienW = cellfun(@(m)double(m.Imu.Orientation.W),msgstruct1);
time = cellfun(@(m) double(m.Header.Stamp.Sec),msgstruct1);

qt = [orienW,orienX,orienY,orienZ];
eulXYZ = quat2eul(qt, "XYZ");
eulXYZ = rad2deg(eulXYZ);
figure(1);
subplot(3,1,1);
plot(time, gyroX);
title ('Time series - Gyro');
ylabel('Gyro X (m/sec)');
subplot(3,1,2);
plot(time, gyroY);
ylabel('Gyro Y (m/sec)');
subplot(3,1,3);
plot(time, gyroZ);
ylabel('Gyro Z (m/sec)');
xlabel('Time (seconds)');
figure(2);
subplot(3,1,1);
plot(time, accelX);
title ('Time series - Acceleration');
ylabel('Accel X (m/sec^2)');
subplot(3,1,2);
plot(time, accelY);
ylabel('Accel Y (m/sec^2)');
subplot(3,1,3);
plot(time, accelZ);
ylabel('Accel Z (m/sec^2)');
xlabel('Time (seconds)');
figure(3);
subplot(3,1,1);
plot(time, orienX);
title ('Time series - Orientation');
ylabel('Orien X (degrees)');
subplot(3,1,2);
plot(time, orienY);
ylabel('Orien Y (degrees)');
subplot(3,1,3);
plot(time, orienZ);
ylabel('Orien Z (degrees)');
xlabel('Time (seconds)');

Median = median(accelX)
Mean = mean(accelX)
Standard_Deviation = std(accelX)

figure(4);
histogram(accelX)
hista = histogram(accelX);
title('Output distribution for accelX');
ylabel('samples');
xlabel('accelX (m/sec^2)');

figure(5);
histogram(gyroX)
title('Output distribution for gyroX');
ylabel('samples');
xlabel('gyroX (m/sec)');