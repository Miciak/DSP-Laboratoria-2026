% Lab 11 - Przyklad 2: Wplyw rozmiaru okna na STFT
fs = 1000;
T  = 2;
t  = 0 : 1/fs : T-1/fs;

x = zeros(1, length(t));
x(t < 1)  = sin(2*pi*50*t(t < 1));
x(t >= 1) = sin(2*pi*200*t(t >= 1));

window_sizes = [32, 128, 512];
nfft = 1024;

figure;
for i = 1:3
    Nw = window_sizes(i);
    subplot(1,3,i);
    spectrogram(x, hann(Nw), round(Nw*0.75), nfft, fs, 'yaxis');
    title(sprintf('Okno N=%d', Nw));
    colorbar;
end
sgtitle('Wplyw dlugosci okna na spektrogram');
