# Lab 2: Próbkowanie + Twierdzenie Nyquista + Kwantyzacja

## 1. Cel
Zrozumienie procesu próbkowania sygnału ciągłego, twierdzenia Nyquista–Shannona oraz kwantyzacji amplitudy. Analiza efektów niedopróbkowania.

## 2. Teoria

### Próbkowanie
Sygnał ciągły `x(t)` jest próbkowany z częstotliwością `fs` (liczba próbek na sekundę). Okres próbkowania: `Ts = 1/fs`.

### Twierdzenie Nyquista–Shannona
Aby wiernie odtworzyć sygnał o maksymalnej częstotliwości `fmax`, częstotliwość próbkowania musi spełniać:

```
fs >= 2 * fmax
```

Minimalna częstotliwość próbkowania `fs = 2·fmax` to **częstotliwość Nyquista**. Niedopróbkowanie (`fs < 2·fmax`) prowadzi do **aliasingu**.

### Kwantyzacja
Zamiana wartości amplitudy na skończoną liczbę poziomów. Dla `b` bitów: `L = 2^b` poziomów.  
Błąd kwantyzacji (szum kwantyzacji): `Δ = (xmax - xmin) / L`.

## 3. Uruchomienie Octave

| Sposób | Instrukcja |
|--------|-----------|
| **Online** | [octave-online.net](https://octave-online.net) |
| **Windows** | Octave GUI → New Script |
| **Ubuntu** | `octave --gui` |

## 4. PRZYKŁAD 1: Próbkowanie sygnału sinusoidalnego

```octave
% Przyklad 1: Probkowanie - efekt Nyquista
f_sygnal = 5;          % czestotliwosc sygnalu [Hz]
T = 1;                 % czas trwania [s]

% Sygnal "ciagly" (duza czestotliwosc probkowania)
fs_cont = 1000;
t_cont  = 0 : 1/fs_cont : T-1/fs_cont;
x_cont  = sin(2*pi*f_sygnal*t_cont);

% Probkowanie zgodne z Nyquistem (fs = 20 Hz > 2*5 Hz)
fs_ok = 20;
t_ok  = 0 : 1/fs_ok : T-1/fs_ok;
x_ok  = sin(2*pi*f_sygnal*t_ok);

% Niedoprobkowanie (fs = 7 Hz < 2*5 Hz) - aliasing!
fs_bad = 7;
t_bad  = 0 : 1/fs_bad : T-1/fs_bad;
x_bad  = sin(2*pi*f_sygnal*t_bad);

figure;
subplot(3,1,1);
plot(t_cont, x_cont);
title('Sygnal ciagly (fs=1000 Hz)'); xlabel('t [s]'); grid on;

subplot(3,1,2);
stem(t_ok, x_ok);
title('Probkowanie OK (fs=20 Hz >= 2*f)'); xlabel('t [s]'); grid on;

subplot(3,1,3);
stem(t_bad, x_bad);
title('Niedoprobkowanie (fs=7 Hz < 2*f) - ALIASING'); xlabel('t [s]'); grid on;
```

## 5. PRZYKŁAD 2: Kwantyzacja sygnału

```octave
% Przyklad 2: Kwantyzacja amplitudy
fs = 1000;
T  = 0.5;
f  = 4;
t  = 0 : 1/fs : T-1/fs;
x  = sin(2*pi*f*t);

% Kwantyzacja 3-bitowa (8 poziomow)
bits = 3;
L    = 2^bits;             % liczba poziomow
x_q3 = round(x * (L/2)) / (L/2);  % kwantyzacja

% Kwantyzacja 8-bitowa (256 poziomow)
bits8 = 8;
L8    = 2^bits8;
x_q8  = round(x * (L8/2)) / (L8/2);

figure;
subplot(3,1,1);
plot(t, x); title('Oryginalny sygnal'); ylabel('Amp'); grid on;

subplot(3,1,2);
stairs(t, x_q3); title('Kwantyzacja 3-bitowa (8 poziomow)'); ylabel('Amp'); grid on;

subplot(3,1,3);
plot(t, x_q8); title('Kwantyzacja 8-bitowa (256 poziomow)'); ylabel('Amp'); grid on;

% Blad kwantyzacji
blad = x - x_q3;
fprintf('Maksymalny blad kwantyzacji 3-bit: %.4f\n', max(abs(blad)));
```

## 6. ZADANIA

1. **Zadanie 1:** Zbadaj próbkowanie sygnału `f = 10 Hz`. Sprawdź, co się dzieje przy `fs = 25 Hz`, `fs = 20 Hz` i `fs = 15 Hz`. Kiedy pojawia się aliasing?

2. **Zadanie 2:** Wykonaj kwantyzację sygnału trójkątnego (`sawtooth`) przy rozdzielczości 2, 4 i 8 bitów. Oblicz i porównaj błędy kwantyzacji.

3. **Zadanie 3:** Wyznacz minimalną częstotliwość próbkowania dla sygnału będącego sumą dwóch sinusów: `sin(2π·8t) + sin(2π·15t)`.

---

## 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab2_ImieNazwisko.pdf`

**ZAWARTOŚĆ:**
- Tytuł + Imię i Nazwisko
- [ZRZUT] Wykresy z Przykładu 1 i 2
- [ZRZUT] Wykresy z Zadań 1–3
- Wnioski: Kiedy konieczne jest spełnienie warunku Nyquista? Jak liczba bitów wpływa na jakość sygnału?
- Kod źródłowy wszystkich zadań
