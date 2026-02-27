# Lab 11: STFT + Transformata Falkowa (Wavelets)

## 1. Cel
Analiza sygnałów niestacjonarnych metodą Short-Time Fourier Transform (STFT) oraz transformaty falkowej. Wizualizacja spektrogramów i skalogreramów.

## 2. Teoria

### Problem FFT dla sygnałów niestacjonarnych
Klasyczna FFT daje informację o częstotliwościach, ale **nie** o czasie ich wystąpienia.

### STFT (Short-Time Fourier Transform)
FFT stosowana na krótkich, nakładających się fragmentach sygnału:
```
STFT(τ, ω) = ∫ x(t) · w(t-τ) · e^(-jωt) dt
```
- `w(t)` – okno czasowe (Hann, Hamming, ...)
- Kompromis: **krótkie okno** = dobra rozdzielczość czasowa, słaba częstotliwościowa  
- **długie okno** = dobra rozdzielczość częstotliwościowa, słaba czasowa

### Transformata falkowa (Wavelet Transform)
Analiza wielorozdzielczościowa – zamiast stałego okna, fala-matka jest skalowana:
```
W(a, b) = (1/√a) · ∫ x(t) · ψ((t-b)/a) dt
```

## 3. Uruchomienie Octave

| Sposób | Instrukcja |
|--------|-----------|
| **Online** | [octave-online.net](https://octave-online.net) |
| **Windows** | Octave GUI → New Script |
| **Ubuntu** | `octave --gui` + `pkg install -forge signal` |

## 4. PRZYKŁAD 1: Spektrogram STFT sygnału chirp

```octave
% Przyklad 1: Spektrogram STFT - sygnal chirp (zmienne czestotliwosci)
fs  = 1000;
T   = 2;
t   = 0 : 1/fs : T-1/fs;

% Sygnal chirp: czestotliwosc wzrasta od 10 do 200 Hz
x = chirp(t, 10, T, 200);

% Spektrogram (STFT)
window_len = 128;     % dlugosc okna
overlap    = 120;     % nakladanie [probki]
nfft       = 256;     % punkty FFT

figure;
subplot(2,1,1);
plot(t, x); title('Sygnal chirp'); xlabel('t [s]'); grid on;

subplot(2,1,2);
spectrogram(x, hann(window_len), overlap, nfft, fs, 'yaxis');
title('Spektrogram STFT'); colorbar;
```

## 5. PRZYKŁAD 2: Wpływ rozmiaru okna na spektrogram

```octave
% Przyklad 2: Wplyw rozmiaru okna na STFT (kompromis czas-czestotliwosc)
fs = 1000;
T  = 2;
t  = 0 : 1/fs : T-1/fs;

% Sygnal: dwie sinusoidy wlaczane w roznych momentach
x = zeros(1, length(t));
x(t < 1)  = sin(2*pi*50*t(t < 1));    % 50 Hz przez pierwsze 1 s
x(t >= 1) = sin(2*pi*200*t(t >= 1));  % 200 Hz przez kolejne 1 s

window_sizes = [32, 128, 512];
nfft = 1024;

figure;
for i = 1:3
    Nw = window_sizes(i);
    subplot(1,3,i);
    spectrogram(x, hann(Nw), round(Nw*0.75), nfft, fs, 'yaxis');
    title(sprintf('Okno N=%d', Nw));
    colorbar;
end
sgtitle('Wplyw dlugosci okna na spektrogram');
```

## 6. ZADANIA

1. **Zadanie 1:** Wygeneruj sygnał składający się z trzech fragmentów: 20 Hz (0–0.5 s), 80 Hz (0.5–1 s), 150 Hz (1–1.5 s). Narysuj spektrogram i zidentyfikuj momenty zmian częstotliwości.

2. **Zadanie 2:** Porównaj spektrogramy sygnału chirp z oknami: prostokątnym, Hanninga i Gaussowskim. Jak okno wpływa na rozdzielczość?

3. **Zadanie 3:** Zastosuj transformatę Haara (Haar wavelet) do dekompozycji sygnału na 3 poziomach. W Octave: użyj funkcji `dwt()` z pakietu `signal` lub zaimplementuj filtrację przez filtr dolnoprzepustowy i górnoprzepustowy.

---

## 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab11_ImieNazwisko.pdf`

**ZAWARTOŚĆ:**
- Tytuł + Imię i Nazwisko
- [ZRZUT] Wykresy z Przykładu 1 i 2
- [ZRZUT] Wykresy z Zadań 1–3
- Wnioski: Na czym polega kompromis czas–częstotliwość w STFT? Kiedy transformata falkowa jest lepsza od STFT?
- Kod źródłowy wszystkich zadań
