% Lab 10 - Przyklad 1: Filtracja 1D - liniowa vs medianowa
fs = 500;
T  = 1;
t  = 0 : 1/fs : T-1/fs;
x_clean = sin(2*pi*10*t);

x_noisy = x_clean;
idx = randperm(length(x_clean), 50);
x_noisy(idx) = sign(randn(1,50));

M     = 5;
h     = ones(1, M) / M;
y_lin = conv(x_noisy, h, 'same');
y_med = medfilt1(x_noisy, M);

figure;
subplot(4,1,1);
plot(t, x_clean); title('Sygnal czysty'); grid on;

subplot(4,1,2);
plot(t, x_noisy); title('Sygnal z szumem impulsowym'); grid on;

subplot(4,1,3);
plot(t, y_lin); title('Po filtracji liniowej (usrednianie)'); grid on;

subplot(4,1,4);
plot(t, y_med); title('Po filtracji medianowej'); grid on;

fprintf('SNR filtr liniowy:    %.2f dB\n', ...
    20*log10(norm(x_clean)/norm(x_clean-y_lin)));
fprintf('SNR filtr medianowy:  %.2f dB\n', ...
    20*log10(norm(x_clean)/norm(x_clean-y_med)));
