% Lab 9 - Przyklad 2: Filtr IIR Butterworth - projektowanie i filtracja
fs = 1000;
fc = 100;
N  = 4;

[b, a] = butter(N, fc/(fs/2), 'low');

[H, w] = freqz(b, a, 1024, fs);
figure;
subplot(2,1,1);
plot(w, 20*log10(abs(H)), 'b', 'LineWidth', 1.5);
title(sprintf('Butterworth LP, N=%d, fc=%d Hz', N, fc));
xlabel('Czestotliwosc [Hz]'); ylabel('|H| [dB]'); grid on; ylim([-80 5]);

t  = 0 : 1/fs : 1-1/fs;
x  = sin(2*pi*50*t) + sin(2*pi*300*t);
y  = filter(b, a, x);

subplot(2,1,2);
plot(t, x, 'b'); hold on; plot(t, y, 'r', 'LineWidth', 1.5);
legend('Wejscie (50+300 Hz)', 'Wyjscie (po filtracji)');
title('Filtracja sygnalem testowym'); xlabel('t [s]'); grid on;
