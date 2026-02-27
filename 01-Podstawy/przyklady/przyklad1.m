% Lab 1 - Przyklad 1: Sygnal sinusoidalny
% Parametry
fs = 1000;          % czestotliwosc probkowania [Hz]
T  = 1;             % czas trwania sygnalu [s]
f  = 5;             % czestotliwosc sygnalu [Hz]
A  = 1;             % amplituda

t = 0 : 1/fs : T-1/fs;   % wektor czasu
x = A * sin(2*pi*f*t);    % sygnal sinusoidalny

figure;
plot(t, x);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Sygnal sinusoidalny f=5 Hz');
grid on;
