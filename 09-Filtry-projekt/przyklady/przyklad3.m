% Lab 9 - Przyklad 3: Filtr pasmowoprzepustowy FIR
fs = 1000;
t  = 0 : 1/fs : 1-1/fs;
x  = sin(2*pi*100*t) + 0.8*sin(2*pi*300*t) + 0.5*sin(2*pi*450*t);

N = 60;
Wn = [200 400] / (fs/2);
b = fir1(N, Wn, 'bandpass', kaiser(N+1, 5));
y = filter(b, 1, x);

[H, w] = freqz(b, 1, 1024, fs);

figure;
subplot(3,1,1);
plot(t, x);
title('Sygnal wejsciowy'); xlabel('Czas [s]'); ylabel('Amp'); grid on;

subplot(3,1,2);
plot(w, 20*log10(abs(H) + eps));
title('Charakterystyka amplitudowa filtru pasmowoprzepustowego');
xlabel('Czestotliwosc [Hz]'); ylabel('Amplituda [dB]'); grid on;

subplot(3,1,3);
plot(t, y);
title('Sygnal po filtracji'); xlabel('Czas [s]'); ylabel('Amp'); grid on;
