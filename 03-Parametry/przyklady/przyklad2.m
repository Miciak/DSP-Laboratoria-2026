% Lab 3 - Przyklad 2: Aliasing - demonstracja
fs   = 40;
T    = 1;
t    = 0 : 1/fs : T-1/fs;

f_real  = 45;   % prawdziwa czestotliwosc
f_alias = 5;    % czestotliwosc aliasu (45 - 40 = 5)

x_real  = sin(2*pi*f_real*t);
x_alias = sin(2*pi*f_alias*t);

figure;
subplot(2,1,1);
stem(t, x_real, 'b');
hold on;
stem(t, x_alias, 'r--');
legend('f=45 Hz (oryg.)', 'f=5 Hz (alias)');
title('Aliasing: f=45 Hz probkowany z fs=40 Hz wyglada jak f=5 Hz');
xlabel('t [s]'); grid on;

N    = length(x_real);
freq = (0:N-1) * fs / N;
X_real  = abs(fft(x_real));
X_alias = abs(fft(x_alias));

subplot(2,1,2);
stem(freq(1:N/2), X_real(1:N/2), 'b'); hold on;
stem(freq(1:N/2), X_alias(1:N/2), 'r--');
legend('f=45 Hz', 'f=5 Hz');
title('Widmo FFT'); xlabel('Czestotliwosc [Hz]'); grid on;
