% Lab 8 - Przyklad 3: Rozne okna filtru FIR
fs = 1000;
fc = 120;
N  = 40;
wn = fc / (fs/2);

b_hamm = fir1(N, wn, 'low', hamming(N+1));
b_black = fir1(N, wn, 'low', blackman(N+1));
b_kais = fir1(N, wn, 'low', kaiser(N+1, 5));

[H1, w] = freqz(b_hamm, 1, 1024, fs);
H2 = freqz(b_black, 1, 1024, fs);
H3 = freqz(b_kais, 1, 1024, fs);

figure;
plot(w, 20*log10(abs(H1) + eps), 'b', 'LineWidth', 1); hold on;
plot(w, 20*log10(abs(H2) + eps), 'r', 'LineWidth', 1);
plot(w, 20*log10(abs(H3) + eps), 'k', 'LineWidth', 1);
title('Porownanie charakterystyk FIR dla roznych okien');
xlabel('Czestotliwosc [Hz]'); ylabel('Amplituda [dB]');
legend('Hamming', 'Blackman', 'Kaiser'); grid on;
