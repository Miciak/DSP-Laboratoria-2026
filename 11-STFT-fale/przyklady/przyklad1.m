% Lab 11 - Przyklad 1: Spektrogram STFT - sygnal chirp
fs  = 1000;
T   = 2;
t   = 0 : 1/fs : T-1/fs;

x = chirp(t, 10, T, 200);

window_len = 128;
overlap    = 120;
nfft       = 256;

figure;
subplot(2,1,1);
plot(t, x); title('Sygnal chirp'); xlabel('t [s]'); grid on;

subplot(2,1,2);
spectrogram(x, hann(window_len), overlap, nfft, fs, 'yaxis');
title('Spektrogram STFT'); colorbar;
