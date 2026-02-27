# Lab 6: Splot liniowy + splot kołowy

## 1. Cel
Zrozumienie operacji splotu liniowego i kołowego jako podstawowych operacji w systemach liniowych stacjonarnych (LTI). Związek splotu z filtracją cyfrową.

## 2. Teoria

### Splot liniowy
Odpowiedź systemu LTI na sygnał wejściowy `x[n]` przy odpowiedzi impulsowej `h[n]`:

```
y[n] = x[n] * h[n] = Σ x[k] · h[n-k]
```

Długość wyniku: `Ly = Lx + Lh - 1`

### Splot kołowy (cykliczny)
Splot modulo N – operacja używana w FFT:

```
y[n] = x[n] ⊛ h[n] = Σ x[k] · h[(n-k) mod N]
```

### Twierdzenie o splocie
Splot w dziedzinie czasu odpowiada mnożeniu w dziedzinie częstotliwości:
```
y[n] = x[n] * h[n]  ⟺  Y[k] = X[k] · H[k]
```

## 3. Uruchomienie Octave

| Sposób | Instrukcja |
|--------|-----------|
| **Online** | [octave-online.net](https://octave-online.net) |
| **Windows** | Octave GUI → New Script |
| **Ubuntu** | `octave --gui` |

## 4. PRZYKŁAD 1: Splot liniowy – filtracja sygnału

```octave
% Przyklad 1: Splot liniowy - filtracja przez filtr usredniajacy
% Sygnal wejsciowy (zaszumiony sinus)
fs = 200;
T  = 1;
t  = 0 : 1/fs : T-1/fs;
x  = sin(2*pi*5*t) + 0.5*randn(size(t));   % sinus + szum

% Odpowiedz impulsowa filtra usredniajacego (filtr MA)
M  = 10;               % dlugosc filtru
h  = ones(1, M) / M;  % odpowiedz impulsowa (okno prostokatne)

% Splot liniowy
y = conv(x, h);
t_y = (0 : length(y)-1) / fs;

figure;
subplot(2,1,1);
plot(t, x); title('Sygnal wejsciowy (zaszumiony)'); xlabel('t [s]'); grid on;

subplot(2,1,2);
plot(t_y, y); title('Po filtracji (splot z filtrem MA)'); xlabel('t [s]'); grid on;
```

## 5. PRZYKŁAD 2: Splot liniowy vs. kołowy oraz twierdzenie o splocie

```octave
% Przyklad 2: Splot liniowy vs kolowy + twierdzenie o splocie
x = [1, 2, 3, 4, 3, 2, 1];
h = [1, 1, 1] / 3;         % filtr usredniajacy

% Splot liniowy
y_lin = conv(x, h);

% Splot kolowy (przez FFT) - wymaga uzupelnienia zerami do dlugosci Ly
Ly  = length(x) + length(h) - 1;
X_z = fft(x, Ly);
H_z = fft(h, Ly);
y_circ = real(ifft(X_z .* H_z));   % splot kolowy = splot liniowy po uzupelnieniu zerami

fprintf('Splot liniowy:  '); disp(y_lin);
fprintf('Splot kolowy:   '); disp(y_circ);
fprintf('Max roznica:    %.2e\n', max(abs(y_lin - y_circ)));

figure;
n_lin = 0 : length(y_lin)-1;
subplot(2,1,1);
stem(n_lin, y_lin, 'b'); title('Splot liniowy conv()'); xlabel('n'); grid on;

subplot(2,1,2);
stem(n_lin, y_circ, 'r'); title('Splot kolowy (FFT)'); xlabel('n'); grid on;
```

## 6. ZADANIA

1. **Zadanie 1:** Wykonaj splot sygnału `x = [1 2 3 2 1]` z odpowiedzią impulsową `h = [1 0 -1]`. Oblicz wynik ręcznie i zweryfikuj w Octave.

2. **Zadanie 2:** Zaszum sygnał sinusoidalny i zastosuj filtr uśredniający o różnych długościach (M = 5, 15, 30). Porównaj wyniki filtracji.

3. **Zadanie 3:** Zaimplementuj splot liniowy bez funkcji `conv()` – korzystając z pętli i definicji splotu. Porównaj z wynikiem funkcji `conv()`.

---

## 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab6_ImieNazwisko.pdf`

**ZAWARTOŚĆ:**
- Tytuł + Imię i Nazwisko
- [ZRZUT] Wykresy z Przykładu 1 i 2
- [ZRZUT] Wykresy z Zadań 1–3
- Wnioski: Jaka jest różnica między splotem liniowym a kołowym? Dlaczego splot odpowiada filtrowaniu?
- Kod źródłowy wszystkich zadań
