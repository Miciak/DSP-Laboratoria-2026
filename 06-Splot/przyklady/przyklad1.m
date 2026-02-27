% Lab 6 - Przyklad 1: Splot liniowy - filtracja przez filtr usredniajacy
fs = 200;
T  = 1;
t  = 0 : 1/fs : T-1/fs;
x  = sin(2*pi*5*t) + 0.5*randn(size(t));

M  = 10;
h  = ones(1, M) / M;

y   = conv(x, h);
t_y = (0 : length(y)-1) / fs;

figure;
subplot(2,1,1);
plot(t, x); title('Sygnal wejsciowy (zaszumiony)'); xlabel('t [s]'); grid on;

subplot(2,1,2);
plot(t_y, y); title('Po filtracji (splot z filtrem MA)'); xlabel('t [s]'); grid on;
