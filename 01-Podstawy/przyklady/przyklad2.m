% Lab 1 - Przyklad 2: Porownanie roznych typow sygnalow
fs = 1000;
T  = 1;
f  = 3;
t  = 0 : 1/fs : T-1/fs;

x_sin  = sin(2*pi*f*t);
x_cos  = cos(2*pi*f*t);
x_sq   = square(2*pi*f*t);
x_saw  = sawtooth(2*pi*f*t);

figure;
subplot(2,2,1);
plot(t, x_sin); title('Sinus'); xlabel('t [s]'); grid on;

subplot(2,2,2);
plot(t, x_cos); title('Cosinus'); xlabel('t [s]'); grid on;

subplot(2,2,3);
plot(t, x_sq);  title('Prostokat'); xlabel('t [s]'); grid on;

subplot(2,2,4);
plot(t, x_saw); title('Piloksztaltny'); xlabel('t [s]'); grid on;
