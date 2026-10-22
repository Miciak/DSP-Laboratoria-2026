% Lab 11 - Przyklad 3: Dekompozycja Haar 1D
x = [zeros(1, 32), ones(1, 32), sin(2*pi*(0:63)/16)];
x = x(1:128);

a1 = (x(1:2:end) + x(2:2:end)) / sqrt(2);
d1 = (x(1:2:end) - x(2:2:end)) / sqrt(2);

a2 = (a1(1:2:end) + a1(2:2:end)) / sqrt(2);
d2 = (a1(1:2:end) - a1(2:2:end)) / sqrt(2);

a3 = (a2(1:2:end) + a2(2:2:end)) / sqrt(2);
d3 = (a2(1:2:end) - a2(2:2:end)) / sqrt(2);

figure;
subplot(4,1,1);
plot(x, 'k'); title('Sygnal oryginalny'); ylabel('Amp'); grid on;

subplot(4,1,2);
stem(a3, 'filled'); title('Aproksymacja po 3 poziomach'); ylabel('Amp'); grid on;

subplot(4,1,3);
stem(d3, 'filled'); title('Detale poziomu 3'); ylabel('Amp'); grid on;

subplot(4,1,4);
stem(d1, 'filled'); title('Detale poziomu 1'); xlabel('Indeks'); ylabel('Amp'); grid on;
