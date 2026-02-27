# Lab 3: Parametry sygnałów + Aliasing

## 1. Cel
Obliczanie i analiza podstawowych parametrów sygnałów dyskretnych: wartość średnia, wartość skuteczna (RMS), moc, energia. Demonstracja zjawiska aliasingu.

## 2. Teoria

### Parametry sygnałów
Dla sygnału dyskretnego `x[n]`, `n = 0, 1, ..., N-1`:

| Parametr | Wzór |
|----------|------|
| Wartość średnia | `x̄ = (1/N) · Σx[n]` |
| Wartość skuteczna (RMS) | `X_rms = sqrt((1/N) · Σx²[n])` |
| Moc średnia | `P = (1/N) · Σx²[n] = X_rms²` |
| Energia | `E = Σx²[n]` |
| Współczynnik szczytu | `CF = max|x[n]| / X_rms` |

### Aliasing
Aliasing to zjawisko nakładania się widm przy niedostatecznej częstotliwości próbkowania. Sygnał o częstotliwości `f` próbkowany z `fs < 2f` pojawia się jako sygnał o częstotliwości `|f - k·fs|`.

## 3. Uruchomienie Octave

| Sposób | Instrukcja |
|--------|-----------|
| **Online** | [octave-online.net](https://octave-online.net) |
| **Windows** | Octave GUI → New Script |
| **Ubuntu** | `octave --gui` |

## 4. PRZYKŁAD 1: Obliczanie parametrów sygnału

```octave
% Przyklad 1: Parametry sygnalu
fs = 1000;
T  = 1;
f  = 5;
t  = 0 : 1/fs : T-1/fs;
x  = 3 * sin(2*pi*f*t) + 0.5;   % sygnal ze skladowa stala

N = length(x);

% Obliczenia
mean_x  = mean(x);
rms_x   = sqrt(mean(x.^2));
power_x = mean(x.^2);
energy_x = sum(x.^2);
peak_x   = max(abs(x));
cf_x     = peak_x / rms_x;

fprintf('=== Parametry sygnalu ===\n');
fprintf('Wartosc srednia:  %.4f\n', mean_x);
fprintf('RMS:              %.4f\n', rms_x);
fprintf('Moc srednia:      %.4f\n', power_x);
fprintf('Energia:          %.4f\n', energy_x);
fprintf('Wartosc szczytowa: %.4f\n', peak_x);
fprintf('Wspolczynnik szczytu: %.4f\n', cf_x);

figure;
plot(t, x);
xlabel('Czas [s]'); ylabel('Amplituda');
title(sprintf('Sygnal: srednia=%.2f, RMS=%.2f', mean_x, rms_x));
grid on;
```

## 5. PRZYKŁAD 2: Demonstracja aliasingu w widmie

```octave
% Przyklad 2: Aliasing - sygnal 45 Hz probkowany z fs=40 Hz
% pojawia sie jako sygnal 5 Hz (45 - 40 = 5)
fs   = 40;
T    = 1;
t    = 0 : 1/fs : T-1/fs;

f_real  = 45;   % prawdziwa czestotliwosc
f_alias = 5;    % czestotliwosc aliasu (45 - 40 = 5)

x_real  = sin(2*pi*f_real*t);
x_alias = sin(2*pi*f_alias*t);

figure;
subplot(2,1,1);
stem(t, x_real, 'b');
hold on;
stem(t, x_alias, 'r--');
legend('f=45 Hz (oryg.)', 'f=5 Hz (alias)');
title('Aliasing: f=45 Hz próbkowany z fs=40 Hz wygląda jak f=5 Hz');
xlabel('t [s]'); grid on;

% Widmo obu sygnałow (FFT)
N    = length(x_real);
freq = (0:N-1) * fs / N;
X_real  = abs(fft(x_real));
X_alias = abs(fft(x_alias));

subplot(2,1,2);
stem(freq(1:N/2), X_real(1:N/2), 'b'); hold on;
stem(freq(1:N/2), X_alias(1:N/2), 'r--');
legend('f=45 Hz', 'f=5 Hz');
title('Widmo FFT'); xlabel('Czestotliwosc [Hz]'); grid on;
```

## 6. ZADANIA

1. **Zadanie 1:** Oblicz wszystkie parametry (średnia, RMS, moc, energia, CF) dla sygnału `x(t) = 2·cos(2π·10t)`. Porównaj z wartościami teoretycznymi (RMS sinusa = A/√2).

2. **Zadanie 2:** Zbadaj aliasing: sygnał `f = 35 Hz` próbkowany z `fs = 30 Hz`. Jaka będzie częstotliwość aliasu? Zweryfikuj to w Octave.

3. **Zadanie 3:** Wygeneruj sygnał prostokątny, oblicz jego parametry i porównaj z sygnałem sinusoidalnym tej samej amplitudy. Dlaczego różnią się wartości RMS?

---

## 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab3_ImieNazwisko.pdf`

**ZAWARTOŚĆ:**
- Tytuł + Imię i Nazwisko
- [ZRZUT] Wykresy z Przykładu 1 i 2
- [ZRZUT] Wykresy z Zadań 1–3
- Wnioski: Co to jest aliasing i jak go uniknąć? Jaka jest różnica między mocą a energią sygnału?
- Kod źródłowy wszystkich zadań
