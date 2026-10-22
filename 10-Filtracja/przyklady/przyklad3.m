% Lab 10 - Przyklad 3: Rozna dlugosc filtru medianowego
n = 0:399;
x = sin(2*pi*0.03*n);
x_noise = x;
x_noise([50, 120, 121, 250, 320]) = [2, -2, 2, -1.5, 1.8];

y3 = medfilt1(x_noise, 3);
y5 = medfilt1(x_noise, 5);
y9 = medfilt1(x_noise, 9);

figure;
subplot(4,1,1);
plot(n, x_noise, 'k');
title('Sygnal z zakloceniami impulsowymi'); ylabel('Amp'); grid on;

subplot(4,1,2);
plot(n, y3, 'b');
title('Filtr medianowy, okno = 3'); ylabel('Amp'); grid on;

subplot(4,1,3);
plot(n, y5, 'r');
title('Filtr medianowy, okno = 5'); ylabel('Amp'); grid on;

subplot(4,1,4);
plot(n, y9, 'g');
title('Filtr medianowy, okno = 9'); xlabel('n'); ylabel('Amp'); grid on;
