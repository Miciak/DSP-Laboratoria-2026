% Lab 7 - Przyklad 2: Odpowiedz impulsowa i charakterystyka czestotliwosciowa
b = [1, 0, -1];
a = [1, -0.9];

N   = 50;
imp = [1, zeros(1, N-1)];
h   = filter(b, a, imp);

[H, w] = freqz(b, a, 512);

figure;
subplot(3,1,1);
stem(0:N-1, h); title('Odpowiedz impulsowa h[n]'); xlabel('n'); grid on;

subplot(3,1,2);
plot(w/pi, abs(H));
xlabel('Czestotliwosc znormalizowana [\pi rad/probke]');
ylabel('|H|'); title('Charakterystyka amplitudowa'); grid on;

subplot(3,1,3);
plot(w/pi, angle(H)*180/pi);
xlabel('Czestotliwosc znormalizowana');
ylabel('Faza [stopnie]'); title('Charakterystyka fazowa'); grid on;
