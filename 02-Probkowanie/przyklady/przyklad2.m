% Lab 2 - Przyklad 2: Kwantyzacja sygnalu
fs = 1000;
T  = 0.5;
f  = 4;
t  = 0 : 1/fs : T-1/fs;
x  = sin(2*pi*f*t);

% Kwantyzacja 3-bitowa (8 poziomow)
bits = 3;
L    = 2^bits;
x_q3 = round(x * (L/2)) / (L/2);

% Kwantyzacja 8-bitowa (256 poziomow)
bits8 = 8;
L8    = 2^bits8;
x_q8  = round(x * (L8/2)) / (L8/2);

figure;
subplot(3,1,1);
plot(t, x); title('Oryginalny sygnal'); ylabel('Amp'); grid on;

subplot(3,1,2);
stairs(t, x_q3); title('Kwantyzacja 3-bitowa (8 poziomow)'); ylabel('Amp'); grid on;

subplot(3,1,3);
plot(t, x_q8); title('Kwantyzacja 8-bitowa (256 poziomow)'); ylabel('Amp'); grid on;

% Blad kwantyzacji
blad = x - x_q3;
fprintf('Maksymalny blad kwantyzacji 3-bit: %.4f\n', max(abs(blad)));
