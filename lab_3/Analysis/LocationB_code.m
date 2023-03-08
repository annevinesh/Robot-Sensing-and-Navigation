bag = rosbag("C:\Users\Vinesh\Desktop\LocationB.bag");
bSel = select(bag, 'Topic', '/vectornav');
msgStructs = readMessages(bSel, 'DataFormat', 'struct');
gyroData = zeros(length(msgStructs), 3);
timestamps = zeros(length(msgStructs), 1);
msg = msgStructs{1}.Data;
for i = 1:length(msgStructs)
   msg = msgStructs{i}.Data;
   if contains(msg, '$VNYMR')
       C = strsplit(msg, ',');
        if length(C) >= 13 
           strng = C{13}(1:10);
           gyroData(i,:) = [str2double(C{11}), str2double(C{12}), str2double(strng)];
           timestamps(i) = msgStructs{i}.Header.Stamp.Sec + msgStructs{i}.Header.Stamp.Nsec*1e-9;
        end
   end
end
timestamps = timestamps - timestamps(1);

figure(5);
subplot(3,1,1);
plot(timestamps, gyroData(:,1), 'r', 'LineWidth', 2);
ylabel('GyroX (rad/s)');
legend('Gyro X');
title("Location B")
subplot(3,1,2);
plot(timestamps, gyroData(:,2), 'g', 'LineWidth', 2);
legend('Gyro Y');
ylabel('GyroY (rad/s)');
subplot(3,1,3);
plot(timestamps, gyroData(:,3), 'b', 'LineWidth', 2);
legend('Gyro Z');
xlabel('Time (s)');
ylabel('GyroZ (rad/s)');
t0 = 1/40;
thetax = cumsum(gyroData(:, 1))*t0;
maxNumMx = 100;
Lx = size(thetax, 1);
maxMx = 2^floor(log2(Lx/2));
mx = logspace(log10(1), log10(maxMx), maxNumMx)';
mx = ceil(mx); % m must be an integer.
mx = unique(mx); % Remove duplicates.
taux = mx*t0;
avarx = zeros(numel(mx), 1);
for i = 1:numel(mx)
    mi = mx(i);
    avarx(i) = sum(...
        (thetax(1+2*mi:Lx) - 2*thetax(1+mi:Lx-mi) + thetax(1:Lx-2*mi)).^2, 1);
end
avarx = avarx ./ (2*taux.^2 .* (Lx - 2*mx));
adevx = sqrt(avarx);
thetay = cumsum(gyroData(:, 2))*t0;
maxNumMy = 100;
Ly = size(thetay, 1);
maxMy = 2^floor(log2(Ly/2));
my = logspace(log10(1), log10(maxMy), maxNumMy)';
my = ceil(my); 
my = unique(my); 
tauy = my*t0;
avary = zeros(numel(my), 1);
for i = 1:numel(my)
    mi = my(i);
    avary(i) = sum(...
        (thetay(1+2*mi:Ly) - 2*thetay(1+mi:Ly-mi) + thetay(1:Ly-2*mi)).^2, 1);
end
avary = avary ./ (2*taux.^2 .* (Ly - 2*my));
adevy = sqrt(avary);

thetaz = cumsum(gyroData(:, 3))*t0;
maxNumMz = 100;
Lz = size(thetaz, 1);
maxMz = 2^floor(log2(Lz/2));
mz = logspace(log10(1), log10(maxMz), maxNumMz)';
mz = ceil(mz); 
mz = unique(mz); 
tauz = mz*t0;
avarz = zeros(numel(mz), 1);
for i = 1:numel(mz)
    mi = mz(i);
    avarz(i) = sum(...
        (thetaz(1+2*mi:Lz) - 2*thetaz(1+mi:Lz-mi) + thetaz(1:Lz-2*mi)).^2, 1);
end
avarz = avarz ./ (2*taux.^2 .* (Lz - 2*mz));
adevz = sqrt(avarz);

figure(6);
loglog(taux, adevx)
title('Allan Deviation')
xlabel('\tau');
ylabel('\sigma(\tau)')
grid on
hold on
loglog(tauy, adevy)
title('Allan Deviation')
xlabel('\tau');
ylabel('\sigma(\tau)')
grid on
hold on
loglog(tauz, adevz)
title('Allan Deviation')
xlabel('\tau');
ylabel('\sigma(\tau)')
grid on
legend("x","y","z")
axis equal
hold off
slope = -0.5;
logtau = log10(taux);
logadev = log10(adevx);
dlogadev = diff(logadev) ./ diff(logtau);
[~, i] = min(abs(dlogadev - slope));
b = logadev(i) - slope*logtau(i);
logN = slope*log(1) + b;
N = 10^logN
tauN = 1;
lineN = N ./ sqrt(taux);

figure(7);
loglog(taux, adevx, taux, lineN, '--', tauN, N, 'o')
title('Allan Deviation with Angle Random Walk')
xlabel('\tau')
ylabel('\sigma(\tau)')
legend('\sigma', '\sigma_N')
text(tauN, N, 'N')
grid on
axis equal
slope = 0.5;
logtau = log10(taux);
logadev = log10(adevx);
dlogadev = diff(logadev) ./ diff(logtau);
[~, i] = min(abs(dlogadev - slope));
b = logadev(i) - slope*logtau(i);
logK = slope*log10(3) + b;
K = 10^logK
tauK = 3;
lineK = K .* sqrt(taux/3);

figure(8);
loglog(taux, adevx, taux, lineK, '--', tauK, K, 'o')
title('Allan Deviation with Rate Random Walk')
xlabel('\tau')
ylabel('\sigma(\tau)')
legend('\sigma', '\sigma_K')
text(tauK, K, 'K')
grid on
axis equal
slope = 0;
logtau = log10(taux);
logadev = log10(adevx);
dlogadev = diff(logadev) ./ diff(logtau);
[~, i] = min(abs(dlogadev - slope));
b = logadev(i) - slope*logtau(i);
scfB = sqrt(2*log(2)/pi);
logB = b - log10(scfB);
B = 10^logB
tauB = taux(i);
lineB = B * scfB * ones(size(taux));

figure(9);
loglog(taux, adevx, taux, lineB, '--', tauB, scfB*B, 'o')
title('Allan Deviation with Bias Instability')
xlabel('\tau')
ylabel('\sigma(\tau)')
legend('\sigma', '\sigma_B')
text(tauB, scfB*B, '0.664B')
grid on
axis equal
tauParams = [tauN, tauK, tauB];
params = [N, K, scfB*B];

figure(10);
loglog(taux, adevx, taux, [lineN, lineK, lineB], '--', ...
    tauParams, params, 'o')
title('Allan Deviation with Noise Parameters')
xlabel('\tau')
ylabel('\sigma(\tau)')
legend('$\sigma (rad/s)$', '$\sigma_N ((rad/s)/\sqrt{Hz})$', ...
    '$\sigma_K ((rad/s)\sqrt{Hz})$', '$\sigma_B (rad/s)$', 'Interpreter', 'latex')
text(tauParams, params, {'N', 'K', '0.664B'})
grid on
axis equal
