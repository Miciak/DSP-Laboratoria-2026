% Lab 5 - Przyklad 1: FFT - analiza widma sygnalu
fs = 1000;
T  = 1;
N  = fs * T;
t  = (0:N-1) / fs;

f1 = 50; f2 = 120; f3 = 200;
x  = sin(2*pi*f1*t) + 0.5*sin(2*pi*f2*t) + 0.3*sin(2*pi*f3*t);

X     = fft(x);
X_amp = abs(X) / N * 2;
freq  = (0 : N/2-1) * fs / N;

figure;
subplot(2,1,1);
plot(t, x);
xlabel('Czas [s]'); ylabel('Amplituda');
title('Sygnal w dziedzinie czasu'); grid on;

subplot(2,1,2);
plot(freq, X_amp(1:N/2));
xlabel('Czestotliwosc [Hz]'); ylabel('Amplituda');
title('Widmo amplitudowe (FFT)'); grid on;
