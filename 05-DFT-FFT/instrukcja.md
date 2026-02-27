# Lab 5: DFT + FFT + Twierdzenie Parsevala

## 1. Cel
Obliczanie widma sygnałów za pomocą Dyskretnej Transformaty Fouriera (DFT) i algorytmu FFT. Weryfikacja twierdzenia Parsevala o zachowaniu energii.

## 2. Teoria

### DFT (Dyskretna Transformata Fouriera)
Dla sygnału `x[n]`, `n = 0, ..., N-1`:

```
X[k] = Σ x[n] · e^(-j2πkn/N),  k = 0, 1, ..., N-1
```

- `|X[k]|` – widmo amplitudowe
- `∠X[k]` – widmo fazowe
- Oś częstotliwości: `f_k = k · fs / N`

### FFT (Fast Fourier Transform)
Szybki algorytm obliczania DFT o złożoności `O(N log N)` zamiast `O(N²)`.

### Twierdzenie Parsevala
Energia sygnału jest taka sama w dziedzinie czasu i częstotliwości:

```
Σ |x[n]|² = (1/N) · Σ |X[k]|²
```

## 3. Uruchomienie Octave

| Sposób | Instrukcja |
|--------|-----------|
| **Online** | [octave-online.net](https://octave-online.net) |
| **Windows** | Octave GUI → New Script |
| **Ubuntu** | `octave --gui` |

## 4. PRZYKŁAD 1: FFT sygnału i analiza widma

```octave
% Przyklad 1: FFT - analiza widma sygnalu
fs = 1000;          % czestotliwosc probkowania [Hz]
T  = 1;             % czas trwania [s]
N  = fs * T;        % liczba probek
t  = (0:N-1) / fs;

% Sygnal: suma sinusow o roznych czestotliwosciach
f1 = 50; f2 = 120; f3 = 200;
x  = sin(2*pi*f1*t) + 0.5*sin(2*pi*f2*t) + 0.3*sin(2*pi*f3*t);

% FFT
X     = fft(x);
X_amp = abs(X) / N * 2;           % jednostronne widmo amplitudowe
freq  = (0 : N/2-1) * fs / N;    % os czestotliwosci [Hz]

figure;
subplot(2,1,1);
plot(t, x);
xlabel('Czas [s]'); ylabel('Amplituda');
title('Sygnal w dziedzinie czasu'); grid on;

subplot(2,1,2);
plot(freq, X_amp(1:N/2));
xlabel('Czestotliwosc [Hz]'); ylabel('Amplituda');
title('Widmo amplitudowe (FFT)'); grid on;
```

## 5. PRZYKŁAD 2: Twierdzenie Parsevala

```octave
% Przyklad 2: Twierdzenie Parsevala
fs = 500;
T  = 0.5;
N  = fs * T;
t  = (0:N-1) / fs;
x  = 2*sin(2*pi*30*t) + cos(2*pi*70*t);

% Energia w dziedzinie czasu
E_time = sum(x.^2);

% Energia w dziedzinie czestotliwosci (Parseval)
X = fft(x);
E_freq = sum(abs(X).^2) / N;

fprintf('Energia w dziedzinie czasu:          %.4f\n', E_time);
fprintf('Energia w dziedzinie czest. (FFT):   %.4f\n', E_freq);
fprintf('Roznica (powinna byc ~0):            %.2e\n', abs(E_time - E_freq));

% Widmo dwustronne
freq2 = (-N/2 : N/2-1) * fs / N;
X_shifted = fftshift(X);

figure;
subplot(2,1,1);
plot(t, x); title('Sygnal'); xlabel('t [s]'); grid on;

subplot(2,1,2);
plot(freq2, abs(X_shifted));
title('Dwustronne widmo amplitudowe');
xlabel('Czestotliwosc [Hz]'); ylabel('|X[k]|'); grid on;
```

## 6. ZADANIA

1. **Zadanie 1:** Wyznacz widmo FFT sygnału prostokątnego o częstotliwości 10 Hz i czasie trwania 1 s (fs = 1000 Hz). Porównaj z teoretycznym szeregiem Fouriera.

2. **Zadanie 2:** Sprawdź twierdzenie Parsevala dla sygnału `x(t) = 3·cos(2π·25t) + sin(2π·75t)`. Czy energie są równe?

3. **Zadanie 3:** Zbadaj wpływ okna (prostokątne, Hanninga, Hamminga) na widmo FFT sygnału sinusoidalnego. Użyj funkcji `hann(N)` i `hamming(N)`.

---

## 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab5_ImieNazwisko.pdf`

**ZAWARTOŚĆ:**
- Tytuł + Imię i Nazwisko
- [ZRZUT] Wykresy z Przykładu 1 i 2
- [ZRZUT] Wykresy z Zadań 1–3
- Wnioski: Co oznaczają wartości widma amplitudowego? Dlaczego stosuje się okna czasowe przed FFT?
- Kod źródłowy wszystkich zadań
