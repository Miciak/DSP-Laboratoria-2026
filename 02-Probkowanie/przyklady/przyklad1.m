% Lab 2 - Przyklad 1: Probkowanie i twierdzenie Nyquista
f_sygnal = 5;          % czestotliwosc sygnalu [Hz]
T = 1;                 % czas trwania [s]

% Sygnal "ciagly" (duza czestotliwosc probkowania)
fs_cont = 1000;
t_cont  = 0 : 1/fs_cont : T-1/fs_cont;
x_cont  = sin(2*pi*f_sygnal*t_cont);

% Probkowanie zgodne z Nyquistem (fs = 20 Hz > 2*5 Hz)
fs_ok = 20;
t_ok  = 0 : 1/fs_ok : T-1/fs_ok;
x_ok  = sin(2*pi*f_sygnal*t_ok);

% Niedoprobkowanie (fs = 7 Hz < 2*5 Hz) - aliasing!
fs_bad = 7;
t_bad  = 0 : 1/fs_bad : T-1/fs_bad;
x_bad  = sin(2*pi*f_sygnal*t_bad);

figure;
subplot(3,1,1);
plot(t_cont, x_cont);
title('Sygnal ciagly (fs=1000 Hz)'); xlabel('t [s]'); grid on;

subplot(3,1,2);
stem(t_ok, x_ok);
title('Probkowanie OK (fs=20 Hz >= 2*f)'); xlabel('t [s]'); grid on;

subplot(3,1,3);
stem(t_bad, x_bad);
title('Niedoprobkowanie (fs=7 Hz < 2*f) - ALIASING'); xlabel('t [s]'); grid on;
