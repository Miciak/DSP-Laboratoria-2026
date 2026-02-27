% Lab 8 - Przyklad 2: Opoznienie grupowe FIR vs IIR
fs = 1000;
Wn = 0.2;

b_fir = fir1(30, Wn);
[b_iir, a_iir] = butter(5, Wn);

[gd_fir, w_fir] = grpdelay(b_fir, 1, 512, fs);
[gd_iir, w_iir] = grpdelay(b_iir, a_iir, 512, fs);

figure;
plot(w_fir, gd_fir, 'b', 'LineWidth', 1.5); hold on;
plot(w_iir, gd_iir, 'r--', 'LineWidth', 1.5);
legend('FIR (liniowa faza)', 'IIR Butterworth (nieliniowa faza)');
xlabel('Czestotliwosc [Hz]'); ylabel('Opoznienie grupowe [probki]');
title('Opoznienie grupowe FIR vs IIR'); grid on;
