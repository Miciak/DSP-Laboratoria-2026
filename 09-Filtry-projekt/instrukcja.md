# Lab 9: Projektowanie filtrów FIR i IIR

## 1. Cel
Praktyczne projektowanie filtrów cyfrowych FIR (metodą okien) i IIR (metodą bilinearną). Weryfikacja zaprojektowanych filtrów przez filtrację sygnałów testowych.

## 2. Teoria

### Projektowanie FIR – metoda okien
1. Podaj specyfikację: `fpass`, `fstop`, `fs`
2. Oblicz rząd filtra: `N = ceil(A / (Δf · fs))` (reguła Kaisera)
3. Zastosuj okno: prostokątne, Hanninga, Hamminga, Blackmana, Kaisera
4. Utwórz filtr: `b = fir1(N, Wn, okno)`

| Okno | Tłumienie w pasmie zaporowym |
|------|------------------------------|
| Prostokątne | ~21 dB |
| Hanninga | ~44 dB |
| Hamminga | ~53 dB |
| Blackmana | ~74 dB |
| Kaisera | Konfigurowalne |

### Projektowanie IIR – metoda bilinearna
Transformacja filtrów analogowych (Butterworth, Chebyshev) na cyfrowe.

```
s = 2·fs · (z-1)/(z+1)   % transformacja bilinearna
```

## 3. Uruchomienie Octave

| Sposób | Instrukcja |
|--------|-----------|
| **Online** | [octave-online.net](https://octave-online.net) |
| **Windows** | Octave GUI → New Script |
| **Ubuntu** | `octave --gui` |

## 4. PRZYKŁAD 1: Filtr FIR metodą okien

```octave
% Przyklad 1: Projektowanie filtru FIR metoda okien
fs   = 1000;           % czestotliwosc probkowania
fp   = 150;            % czestotliwosc graniczna pasma przepustowego [Hz]
fst  = 200;            % czestotliwosc poczatku pasma zaporowego [Hz]
Wn   = (fp + fst) / 2 / (fs/2);   % czestotliwosc znormalizowana (srednia)

% Rozne okna
N = 50;
b_rect  = fir1(N, Wn, 'low');
b_hann  = fir1(N, Wn, 'low', hann(N+1));
b_hamm  = fir1(N, Wn, 'low', hamming(N+1));
b_black = fir1(N, Wn, 'low', blackman(N+1));

[H_rect,  w] = freqz(b_rect,  1, 1024, fs);
[H_hann,  ~] = freqz(b_hann,  1, 1024, fs);
[H_hamm,  ~] = freqz(b_hamm,  1, 1024, fs);
[H_black, ~] = freqz(b_black, 1, 1024, fs);

figure;
plot(w, 20*log10(abs(H_rect)),  'k',  'LineWidth', 1.2); hold on;
plot(w, 20*log10(abs(H_hann)),  'b',  'LineWidth', 1.2);
plot(w, 20*log10(abs(H_hamm)),  'r',  'LineWidth', 1.2);
plot(w, 20*log10(abs(H_black)), 'g',  'LineWidth', 1.2);
legend('Prostokatne', 'Hanninga', 'Hamminga', 'Blackmana');
xlabel('Czestotliwosc [Hz]'); ylabel('|H| [dB]');
title('Porownanie okien - filtr FIR (N=50)'); grid on; ylim([-100 5]);
xline(fp, 'b--'); xline(fst, 'r--');
```

## 5. PRZYKŁAD 2: Filtr IIR Butterworth i filtracja

```octave
% Przyklad 2: Filtr IIR Butterworth - projektowanie i filtracja
fs = 1000;
fc = 100;              % czestotliwosc odciecia [Hz]
N  = 4;                % rzad filtru

[b, a] = butter(N, fc/(fs/2), 'low');

% Weryfikacja charakterystyki
[H, w] = freqz(b, a, 1024, fs);
figure;
subplot(2,1,1);
plot(w, 20*log10(abs(H)), 'b', 'LineWidth', 1.5);
title(sprintf('Butterworth LP, N=%d, fc=%d Hz', N, fc));
xlabel('Czestotliwosc [Hz]'); ylabel('|H| [dB]'); grid on; ylim([-80 5]);
xline(fc, 'r--', 'f_c = -3dB');

% Filtracja sygnalu testowego
t  = 0 : 1/fs : 1-1/fs;
x  = sin(2*pi*50*t) + sin(2*pi*300*t);   % 50 Hz przepuszczone, 300 Hz zablokowane
y  = filter(b, a, x);

subplot(2,1,2);
plot(t, x, 'b'); hold on; plot(t, y, 'r', 'LineWidth', 1.5);
legend('Wejscie (50+300 Hz)', 'Wyjscie (po filtracji)');
title('Filtracja sygnalem testowym'); xlabel('t [s]'); grid on;
```

## 6. ZADANIA

1. **Zadanie 1:** Zaprojektuj filtr górnoprzepustowy FIR (okno Hamminga, N=40) o częstotliwości odcięcia 300 Hz i fs = 1000 Hz. Zweryfikuj go sygnałem 100 Hz + 500 Hz.

2. **Zadanie 2:** Zaprojektuj pasmowoprzepustowy filtr IIR Butterworth rzędu 4, pasmo 200–400 Hz, fs = 2000 Hz. Użyj `butter(4, [200 400]/(2000/2), 'bandpass')`.

3. **Zadanie 3:** Porównaj filtry Butterworth, Chebyshev I i Elliptic tego samego rzędu (N=4) dla tych samych specyfikacji. Użyj `cheby1()` i `ellip()`.

---

## 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab9_ImieNazwisko.pdf`

**ZAWARTOŚĆ:**
- Tytuł + Imię i Nazwisko
- [ZRZUT] Wykresy z Przykładu 1 i 2
- [ZRZUT] Wykresy z Zadań 1–3
- Wnioski: Jakie kryteria decydują o wyborze okna? Kiedy Butterworth vs Chebyshev?
- Kod źródłowy wszystkich zadań
