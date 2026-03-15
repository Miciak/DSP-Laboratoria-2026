% Lab 7 - Przyklad 3: Porownanie polozenia biegunow
r_values = [0.5, 0.8, 0.98];
theta    = pi/4;

figure;
for i = 1:length(r_values)
    r = r_values(i);
    b = 1;
    a = [1, -2*r*cos(theta), r^2];

    subplot(length(r_values), 2, 2*i-1);
    zplane(b, a);
    title(sprintf('Bieguny dla r = %.2f', r));

    [H, w] = freqz(b, a, 512);
    subplot(length(r_values), 2, 2*i);
    plot(w/pi, 20*log10(abs(H) + eps));
    title(sprintf('Charakterystyka amplitudowa dla r = %.2f', r));
    xlabel('Znormalizowana czestotliwosc'); ylabel('Amplituda [dB]'); grid on;
end
