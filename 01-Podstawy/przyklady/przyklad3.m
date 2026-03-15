% Lab 1 - Przyklad 3: Suma dwoch sinusoid
fs = 1000;                 % czestotliwosc probkowania [Hz]
T  = 2;                    % czas obserwacji [s]
t  = 0 : 1/fs : T-1/fs;

A1 = 1.0;  f1 = 3;  phi1 = 0;
A2 = 0.6;  f2 = 7;  phi2 = pi/4;

x1 = A1 * sin(2*pi*f1*t + phi1);
x2 = A2 * sin(2*pi*f2*t + phi2);
x  = x1 + x2;

figure;
subplot(3,1,1);
plot(t, x1);
title('Skladnik 1: 3 Hz'); xlabel('Czas [s]'); ylabel('Amp'); grid on;

subplot(3,1,2);
plot(t, x2);
title('Skladnik 2: 7 Hz, faza pi/4'); xlabel('Czas [s]'); ylabel('Amp'); grid on;

subplot(3,1,3);
plot(t, x, 'k');
title('Suma dwoch sinusoid'); xlabel('Czas [s]'); ylabel('Amp'); grid on;
