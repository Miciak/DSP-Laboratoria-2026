% Lab 5 - Przyklad 3: Okna i przeciek widma
fs = 256;
N  = 256;
t  = (0:N-1) / fs;
f0 = 50.5;
x  = sin(2*pi*f0*t);

windows = {ones(1, N), hanning(N)', hamming(N)'};
names   = {'Prostokatne', 'Hann', 'Hamming'};
f       = (0:N-1) * fs / N;

figure;
for i = 1:3
    xw = x .* windows{i};
    X  = abs(fft(xw)) / N;

    subplot(3,1,i);
    plot(f(1:N/2), 20*log10(X(1:N/2) + eps));
    title(sprintf('Widmo po zastosowaniu okna: %s', names{i}));
    xlabel('Czestotliwosc [Hz]'); ylabel('Amplituda [dB]'); grid on;
end
