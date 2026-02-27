% Lab 8 - Przyklad 1: Porownanie FIR vs IIR - charakterystyki amplitudowe
fs = 1000;
fc = 100;
Wn = fc / (fs/2);

N_fir = 40;
b_fir = fir1(N_fir, Wn, 'low', hamming(N_fir+1));
a_fir = 1;

[b_iir, a_iir] = butter(4, Wn, 'low');

[H_fir, w] = freqz(b_fir, a_fir, 1024, fs);
[H_iir, ~] = freqz(b_iir, a_iir, 1024, fs);

figure;
subplot(2,1,1);
plot(w, 20*log10(abs(H_fir)), 'b', 'LineWidth', 1.5); hold on;
plot(w, 20*log10(abs(H_iir)), 'r--', 'LineWidth', 1.5);
legend('FIR (N=40, Hamming)', 'IIR Butterworth (N=4)');
xlabel('Czestotliwosc [Hz]'); ylabel('|H| [dB]');
title('Charakterystyka amplitudowa'); grid on; ylim([-80 5]);

subplot(2,1,2);
plot(w, unwrap(angle(H_fir))*180/pi, 'b'); hold on;
plot(w, unwrap(angle(H_iir))*180/pi, 'r--');
legend('FIR', 'IIR');
xlabel('Czestotliwosc [Hz]'); ylabel('Faza [stopnie]');
title('Charakterystyka fazowa'); grid on;
