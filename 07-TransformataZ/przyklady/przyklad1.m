% Lab 7 - Przyklad 1: Bieguny i zera filtru - analiza stabilnosci
b = [0.2, 0.2, 0.2];
a = [1, -0.5, 0.1];

zeros_H = roots(b);
poles_H = roots(a);

fprintf('Zera H(z):\n'); disp(zeros_H);
fprintf('Bieguny H(z):\n'); disp(poles_H);
fprintf('|bieguny|: '); disp(abs(poles_H)');

if all(abs(poles_H) < 1)
    fprintf('System jest STABILNY\n');
else
    fprintf('System jest NIESTABILNY\n');
end

figure;
zplane(b, a);
title('Plan Z - bieguny i zera H(z)');
