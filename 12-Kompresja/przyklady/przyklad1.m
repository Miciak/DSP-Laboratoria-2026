% Lab 12 - Przyklad 1: Kompresja sygnalu 1D przez DCT
fs = 1000;
T  = 0.5;
t  = 0 : 1/fs : T-1/fs;
x  = sin(2*pi*20*t) + 0.5*sin(2*pi*60*t) + 0.2*sin(2*pi*150*t);

N = length(x);
X_dct = dct(x);

thresholds = [0, 0.05, 0.1, 0.3];
figure;
for i = 1:4
    thr  = thresholds(i);
    X_thr = X_dct;
    X_thr(abs(X_dct) < thr * max(abs(X_dct))) = 0;

    n_nonzero = sum(X_thr ~= 0);
    x_rec = idct(X_thr);
    mse   = mean((x - x_rec).^2);

    subplot(2,2,i);
    plot(t, x, 'b'); hold on; plot(t, x_rec, 'r--');
    legend('Oryginal', 'Rekonstrukcja');
    title(sprintf('Prog=%.0f%%, WSP=%d/%d, MSE=%.4f', thr*100, n_nonzero, N, mse));
    xlabel('t [s]'); grid on;
end
sgtitle('Kompresja DCT z roznym progowaniem');
