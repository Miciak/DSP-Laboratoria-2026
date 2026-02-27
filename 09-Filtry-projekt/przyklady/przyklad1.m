% Lab 9 - Przyklad 1: Projektowanie filtru FIR metoda okien
fs  = 1000;
fp  = 150;
fst = 200;
Wn  = (fp + fst) / 2 / (fs/2);

N = 50;
b_rect  = fir1(N, Wn, 'low');
b_hann  = fir1(N, Wn, 'low', hann(N+1));
b_hamm  = fir1(N, Wn, 'low', hamming(N+1));
b_black = fir1(N, Wn, 'low', blackman(N+1));

[H_rect,  w] = freqz(b_rect,  1, 1024, fs);
[H_hann,  ~] = freqz(b_hann,  1, 1024, fs);
[H_hamm,  ~] = freqz(b_hamm,  1, 1024, fs);
[H_black, ~] = freqz(b_black, 1, 1024, fs);

figure;
plot(w, 20*log10(abs(H_rect)),  'k',  'LineWidth', 1.2); hold on;
plot(w, 20*log10(abs(H_hann)),  'b',  'LineWidth', 1.2);
plot(w, 20*log10(abs(H_hamm)),  'r',  'LineWidth', 1.2);
plot(w, 20*log10(abs(H_black)), 'g',  'LineWidth', 1.2);
legend('Prostokatne', 'Hanninga', 'Hamminga', 'Blackmana');
xlabel('Czestotliwosc [Hz]'); ylabel('|H| [dB]');
title('Porownanie okien - filtr FIR (N=50)'); grid on; ylim([-100 5]);
