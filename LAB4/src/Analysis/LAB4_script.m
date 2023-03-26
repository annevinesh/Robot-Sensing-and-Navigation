bag1 = rosbag("C:\Users\Vinesh\Desktop\data_going_in_circles.bag");
bag2 = rosbag("C:\Users\Vinesh\Desktop\data_driving.bag");

circle3 = select(bag1, 'Topic', '/imu');
driving1 = select(bag2, 'Topic', '/gps');
driving3 = select(bag2, 'Topic', '/imu');

circle3_msgs = readMessages(circle3, 'DataFormat', 'Struct');
driving1_msgs = readMessages(driving1, 'DataFormat', 'Struct');
driving3_msgs = readMessages(driving3, 'DataFormat', 'Struct');

magX_c = cellfun(@(i) double(i.MagField.MagneticField_.X),circle3_msgs);
magY_c = cellfun(@(i) double(i.MagField.MagneticField_.Y),circle3_msgs);
secs_gps = cellfun(@(i) double(i.Header.Stamp.Sec), driving1_msgs);
nsecs_gps = cellfun(@(i) double(i.Header.Stamp.Nsec), driving1_msgs);
utmeast = cellfun(@(i) double(i.UTMEasting), driving1_msgs);
utmnorth = cellfun(@(i) double(i.UTMNorthing), driving1_msgs);
secs = cellfun(@(i) double(i.Header.Stamp.Sec), driving3_msgs);
nsecs = cellfun(@(i) double(i.Header.Stamp.Nsec), driving3_msgs);
accx = cellfun(@(i) double(i.Imu.LinearAcceleration.X), driving3_msgs);
accy = cellfun(@(i) double(i.Imu.LinearAcceleration.Y), driving3_msgs);
accz = cellfun(@(i) double(i.Imu.LinearAcceleration.Z), driving3_msgs);
magX_d = cellfun(@(i) double(i.MagField.MagneticField_.X),driving3_msgs);
magY_d = cellfun(@(i) double(i.MagField.MagneticField_.Y),driving3_msgs);
gyroz = cellfun(@(i) double(i.Imu.AngularVelocity.Z), driving3_msgs);
qx= cellfun(@(i) double(i.Imu.Orientation.X), driving3_msgs);
qy= cellfun(@(i) double(i.Imu.Orientation.Y), driving3_msgs);
qz= cellfun(@(i) double(i.Imu.Orientation.Z), driving3_msgs);
qw= cellfun(@(i) double(i.Imu.Orientation.W), driving3_msgs);

figure(1)
[xfit,yfit,Rfit] = circfit(magX_c,magY_c);
plot(magX_c,magY_c)
hold on
rectangle('position',[xfit-Rfit,yfit-Rfit,Rfit*2,Rfit*2],'curvature',[1,1],'linestyle','-','edgecolor','b');
axis equal
grid on;
xlabel('Mag Field X (Gauss)')
ylabel('Mag Field Y (Gauss)')
title('Mag Field Y vs Mag Field X')
ellipset = fit_ellipse(magX_c,magY_c);
syms x y
a=ellipset.long_axis/2;   
b=ellipset.short_axis/2;
c=ellipset.X0_in; 
d=ellipset.Y0_in;
ellipse= (((x-c)^2)/(a^2))+(((y-d)^2)/(b^2))==1;
xlabel('Mag Field X (Gauss)')
ylabel('Mag Field Y (Gauss)')
title('Mag Field Y vs X')
axis equal;
offsetx = ellipset.X0_in;
offsety = ellipset.Y0_in;
magXtransl = magX_c-offsetx;
magYtransl = magY_c-offsety;
ellipset = fit_ellipse(magXtransl,magYtransl);
angle = ellipset.phi;
rotationmat = [cos(angle), sin(angle); -sin(angle), cos(angle)];
MagXmat = [magXtransl, magYtransl];
MagXrot = MagXmat * rotationmat;
MagX1rot = MagXrot(:,1);
MagY1rot = MagXrot(:,2);
ellipset = fit_ellipse(MagX1rot,MagY1rot);
tau = (ellipset.short_axis/2)/(ellipset.long_axis/2);
rescaling_mat = [tau,0;0,1];
MagXrot = MagXrot*rescaling_mat;
MagX = MagXrot(:,1);
MagY = MagXrot(:,2);
plot(MagX, MagY)
grid on;
axis equal;
[xfit,yfit,Rfit] = circfit(MagX,MagY);
rectangle('position',[xfit-Rfit,yfit-Rfit,Rfit*2,Rfit*2],'curvature',[1,1],'linestyle','-','edgecolor','r');
legend('Before correction', 'After correction');
hold off;
MagXdtransl = magX_d - offsetx;
MagYdtransl = magY_d - offsety;
temp = [MagXdtransl,MagYdtransl];
MagXdcor = (temp*rotationmat)*rescaling_mat;
MagXcord = MagXdcor(:,1);
MagYcord = MagXdcor(:,2);
magdyawraw = (atan2(-magY_d,magX_d));
magdyawcor = (atan2(-MagYcord,MagXcord));
time = secs + 10^(-9)*nsecs;
time = time - time(1);

figure(2)
plot(time, unwrap(magdyawcor));
grid on;
hold on;
plot(time, magdyawraw);
hold off;
legend('Corrected Mag Yaw','Mag Yaw');
xlabel('Time (seconds)');
ylabel('Yaw (radians)');
title('Yaw vs Time');
gyroyaw = cumtrapz(time,gyroz);
magdyawcor = magdyawcor - magdyawcor(1);

figure(3)
plot(time,unwrap(gyroyaw))
hold on;
grid on;
plot(time, unwrap(magdyawcor))
legend('Gyro Yaw', 'Mag Yaw')
xlabel('Time (seconds)')
ylabel('Yaw (radians)')
title('Mag Yaw with Gyro Yaw')
hold off;
lowpassmagdyaw = lowpass(unwrap(magdyawcor),0.0001,40);

figure(4);
plot(time,unwrap(lowpassmagdyaw));
grid on;
hold on;
highpassgyroyaw = highpass(unwrap(gyroyaw),0.07,40);
plot(time,unwrap(highpassgyroyaw))
qt = [qw,qx,qy,qz];
eulXYZ = quat2eul(qt, "XYZ");
imu_yaw = eulXYZ(:,3);
addedmaggyro = highpassgyroyaw + lowpassmagdyaw;
plot(time, unwrap(addedmaggyro))
legend('LP Mag Yaw','HP Gyro Yaw', 'CPF Yaw')
xlabel('Time (seconds)')
ylabel('Yaw (radians)')
title('LP Mag Yaw, HP Gyro Yaw, CPF Yaw')
hold off;
velocity_imu = cumtrapz(time,accx);
timegps = secs_gps + 10^(-9)*nsecs_gps;
timegps = timegps - timegps(1); 
utmeast = utmeast - utmeast(1);
utmnorth = utmnorth - utmnorth(1);
utmcombine = [utmeast,utmnorth];
velocitygps= zeros(length(timegps)-1,1);
for i = 1:length(timegps)-1
    velocitygps(i) = norm(utmcombine(i+1,:)-utmcombine(i,:))/(timegps(i+1)-timegps(i));
end
velocitygps = [0,transpose(velocitygps)];
velocitygps= transpose(velocitygps);
vel_gps_truesiz = velocitygps;
velocitygps = interp(velocitygps,40);

figure(5)
plot(velocitygps)
grid on;
hold on;
plot(velocity_imu)
xlabel('Time (seconds)')
ylabel('Velocity (m/sec)')
title('Velocity from GPS and IMU before adjustment')
legend('Velocity GPS','Velocity IMU')
hold off;
bias_pos = [0,5067,6317,7357,8263,10226,12133,13291,14721,15933,19639,21899,23883,25706,27637,27895,28638,29235,29966,31789,33102,33734,34555,35900,37182,43248];
accXcorrected = zeros(size(accx));
for i = 1:length(bias_pos)
    if i==length(bias_pos)-1
        meanbias = mean(accx(bias_pos(1,i):bias_pos(1,i+1)));
        accXcorrected(bias_pos(1,i):bias_pos(1,i+1)) = accx(bias_pos(1,i):bias_pos(1,i+1)) - meanbias; 
        break
    end
    if i == 1
        meanbias = mean(accx(1:bias_pos(1,2)));
        accXcorrected(1:bias_pos(1,3)) = accx(1:bias_pos(1,3))-meanbias;
    else 
        meanbias = mean(accx(bias_pos(1,i):bias_pos(1,i+1)));
        accXcorrected(bias_pos(1,i):bias_pos(1,i+2)) = accx(bias_pos(1,i):bias_pos(1,i+2))-meanbias;
    end
end
velocityimucor = cumtrapz(accXcorrected*(1/40));

figure(6)
plot(velocitygps)
hold on;
plot(velocityimucor)         
grid on;
legend('Velocity GPS','Velocity IMU')
xlabel('Time (seconds)')
ylabel('Velocity (m/sec)')
title('Velocity from GPS and IMU after adjustment')
hold off;
displacementimu = cumtrapz(velocityimucor);
displacementgps = cumtrapz(velocitygps);

figure(7)
plot(displacementimu)
grid on;
hold on;
plot(displacementgps)
legend('Displacement IMU','Displacement GPS')
xlabel('Time (seconds)')
ylabel('Displacement (meters)')
title('Displacement vs Time')
hold off;
xdods = accXcorrected;
xd = velocityimucor;
wxd = gyroz.*xd;
ydods = accy + wxd;
xddods_filt = lowpass(xdods,0.001,40);
yddods_filt = lowpass(ydods,0.001,40);

figure(8)
plot(time, wxd )
grid on;
hold on;
plot(time,yddods_filt)
legend('𝜔𝑋̇','𝑦̈𝑜𝑏𝑠')
xlabel('Time (seconds)')
ylabel('Acceleration (m/sec^2)')
title('𝜔𝑋̇ and 𝑦̈𝑜𝑏𝑠')
hold off;
complyaw = addedmaggyro - 0.15;
ve = velocitygps.*sin(complyaw(1:43240));
vn = velocitygps.*cos(complyaw(1:43240));
vi = velocity_imu(3:end);
ve1 = vi.*sin(gyroyaw(1:43246));
vn2 = vi.*cos(gyroyaw(1:43246));
vic = velocityimucor(3:end);
ve3 = vic.*sin(gyroyaw(1:43246));
vn4 = vic.*cos(gyroyaw(1:43246));
xe = cumtrapz(ve.*(1/40));
xn = cumtrapz(vn.*(1/40));
xe1 = cumtrapz(ve1.*(1/40));
xn2 = cumtrapz(vn2.*(1/40));
xe3 = cumtrapz(ve3.*(1/40));
xn4 = cumtrapz(vn4.*(1/40));

figure(9)
plot(xe,xn)
grid on;
hold on;
plot(utmeast,utmnorth)
legend('Estimation using CPF Yaw','Path followed shown dy GPS', 'Location','SE')
xlabel('Easting (meters)')
ylabel('Northing (meters)')
title('Path from GPS & CPF Output')
hold off;