% Lab 6 - Przyklad 2: Splot liniowy vs kolowy + twierdzenie o splocie
x = [1, 2, 3, 4, 3, 2, 1];
h = [1, 1, 1] / 3;

y_lin = conv(x, h);

Ly  = length(x) + length(h) - 1;
X_z = fft(x, Ly);
H_z = fft(h, Ly);
y_circ = real(ifft(X_z .* H_z));

fprintf('Splot liniowy:  '); disp(y_lin);
fprintf('Splot kolowy:   '); disp(y_circ);
fprintf('Max roznica:    %.2e\n', max(abs(y_lin - y_circ)));

n_lin = 0 : length(y_lin)-1;
figure;
subplot(2,1,1);
stem(n_lin, y_lin, 'b'); title('Splot liniowy conv()'); xlabel('n'); grid on;

subplot(2,1,2);
stem(n_lin, y_circ, 'r'); title('Splot kolowy (FFT)'); xlabel('n'); grid on;
