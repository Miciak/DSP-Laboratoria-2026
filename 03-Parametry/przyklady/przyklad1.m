% Lab 3 - Przyklad 1: Parametry sygnalu
fs = 1000;
T  = 1;
f  = 5;
t  = 0 : 1/fs : T-1/fs;
x  = 3 * sin(2*pi*f*t) + 0.5;   % sygnal ze skladowa stala

% Obliczenia
mean_x   = mean(x);
rms_x    = sqrt(mean(x.^2));
power_x  = mean(x.^2);
energy_x = sum(x.^2);
peak_x   = max(abs(x));
cf_x     = peak_x / rms_x;

fprintf('=== Parametry sygnalu ===\n');
fprintf('Wartosc srednia:      %.4f\n', mean_x);
fprintf('RMS:                  %.4f\n', rms_x);
fprintf('Moc srednia:          %.4f\n', power_x);
fprintf('Energia:              %.4f\n', energy_x);
fprintf('Wartosc szczytowa:    %.4f\n', peak_x);
fprintf('Wspolczynnik szczytu: %.4f\n', cf_x);

figure;
plot(t, x);
xlabel('Czas [s]'); ylabel('Amplituda');
title(sprintf('Sygnal: srednia=%.2f, RMS=%.2f', mean_x, rms_x));
grid on;
