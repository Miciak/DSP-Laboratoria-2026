% Lab 4 - Przyklad 2: Widmo szeregu Fouriera sygnalu piloksztaltnego
T0     = 1;
omega0 = 2*pi / T0;
t      = 0 : 0.001 : 3*T0;
N      = 15;

x_approx = zeros(size(t));
amps = zeros(1, N);

for k = 1:N
    ck = (-1)^(k+1) * (2/pi) / k;
    amps(k) = abs(ck);
    x_approx = x_approx + ck * sin(k*omega0*t);
end

figure;
subplot(2,1,1);
plot(t, x_approx); hold on;
plot(t, sawtooth(omega0*t), 'r--');
legend('Aproksymacja (N=15)', 'Oryginalny');
title('Sygnal piloksztaltny - aproksymacja Fouriera');
xlabel('t [s]'); grid on;

subplot(2,1,2);
stem(1:N, amps);
title('Widmo amplitudowe (wspolczynniki Fouriera)');
xlabel('Numer harmonicznej'); ylabel('|C_k|'); grid on;
