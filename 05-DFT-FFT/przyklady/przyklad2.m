% Lab 5 - Przyklad 2: Twierdzenie Parsevala
fs = 500;
T  = 0.5;
N  = fs * T;
t  = (0:N-1) / fs;
x  = 2*sin(2*pi*30*t) + cos(2*pi*70*t);

E_time = sum(x.^2);
X = fft(x);
E_freq = sum(abs(X).^2) / N;

fprintf('Energia w dziedzinie czasu:        %.4f\n', E_time);
fprintf('Energia w dziedzinie czest. (FFT): %.4f\n', E_freq);
fprintf('Roznica (powinna byc ~0):          %.2e\n', abs(E_time - E_freq));

freq2 = (-N/2 : N/2-1) * fs / N;
X_shifted = fftshift(X);

figure;
subplot(2,1,1);
plot(t, x); title('Sygnal'); xlabel('t [s]'); grid on;

subplot(2,1,2);
plot(freq2, abs(X_shifted));
title('Dwustronne widmo amplitudowe');
xlabel('Czestotliwosc [Hz]'); ylabel('|X[k]|'); grid on;
