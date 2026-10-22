% Lab 12 - Przyklad 3: Jakosc kompresji DCT w funkcji progu
fs = 1000;
T  = 0.5;
t  = 0 : 1/fs : T-1/fs;
x  = sin(2*pi*20*t) + 0.5*sin(2*pi*60*t) + 0.2*sin(2*pi*150*t);

X_dct = dct(x);
thresholds = linspace(0, 0.3, 20);
mse = zeros(size(thresholds));
cr  = zeros(size(thresholds));

for i = 1:length(thresholds)
    thr = thresholds(i);
    X_thr = X_dct;
    X_thr(abs(X_dct) < thr * max(abs(X_dct))) = 0;

    x_rec = idct(X_thr);
    mse(i) = mean((x - x_rec).^2);
    cr(i)  = length(X_dct) / max(nnz(X_thr), 1);
end

figure;
subplot(2,1,1);
plot(thresholds * 100, mse, 'o-b');
title('MSE w funkcji progu progowania');
xlabel('Prog [% maksymalnego wspolczynnika]'); ylabel('MSE'); grid on;

subplot(2,1,2);
plot(thresholds * 100, cr, 's-r');
title('Stopien kompresji w funkcji progu progowania');
xlabel('Prog [% maksymalnego wspolczynnika]'); ylabel('CR'); grid on;
