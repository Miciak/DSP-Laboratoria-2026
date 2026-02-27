# Lab 10: Filtracja 1D, 2D i filtry nieliniowe

## 1. Cel
Zastosowanie filtracji cyfrowej do sygnałów 1D i obrazów 2D. Poznanie filtrów nieliniowych (medianowego) i porównanie z filtrami liniowymi.

## 2. Teoria

### Filtracja 1D
Filtr liniowy: `y[n] = Σ h[k] · x[n-k]` (splot)  
Filtr medianowy: `y[n] = median(x[n-M:n+M])` – odporny na szum impulsowy

### Filtracja 2D (obrazy)
Filtr 2D: `g(i,j) = Σ Σ h(m,n) · f(i-m, j-n)`

Typowe maski filtrów 2D:
- **Uśredniający:** `h = ones(3,3)/9`
- **Gaussowski:** `fspecial('gaussian', [5 5], 1)`
- **Laplasjan (wyostrzanie):** `[0 -1 0; -1 4 -1; 0 -1 0]`

### Szum impulsowy (sól i pieprz)
Losowe piksele ustawiane na wartość min lub max – najlepiej usuwany filtrem medianowym.

## 3. Uruchomienie Octave

| Sposób | Instrukcja |
|--------|-----------|
| **Online** | [octave-online.net](https://octave-online.net) |
| **Windows** | Octave GUI → New Script |
| **Ubuntu** | `octave --gui` oraz `pkg load image` |

## 4. PRZYKŁAD 1: Filtracja 1D – liniowy vs. medianowy

```octave
% Przyklad 1: Filtracja 1D - porownanie filtrow
fs = 500;
T  = 1;
t  = 0 : 1/fs : T-1/fs;
x_clean = sin(2*pi*10*t);

% Szum impulsowy (sol i pieprz)
x_noisy = x_clean;
idx = randperm(length(x_clean), 50);
x_noisy(idx) = sign(randn(1,50));   % losowe skoki ±1

% Filtracja liniowa (filtr usredniajacy)
M   = 5;
h   = ones(1, M) / M;
y_lin = conv(x_noisy, h, 'same');

% Filtracja medianowa
y_med = medfilt1(x_noisy, M);

figure;
subplot(4,1,1);
plot(t, x_clean); title('Sygnal czysty'); grid on;

subplot(4,1,2);
plot(t, x_noisy); title('Sygnal z szumem impulsowym'); grid on;

subplot(4,1,3);
plot(t, y_lin); title('Po filtracji liniowej (usrednianie)'); grid on;

subplot(4,1,4);
plot(t, y_med); title('Po filtracji medianowej'); grid on;

% Bledy
fprintf('SNR po filtrowaniu liniowym:    %.2f dB\n', ...
    20*log10(norm(x_clean)/norm(x_clean-y_lin)));
fprintf('SNR po filtrowaniu medianowym:  %.2f dB\n', ...
    20*log10(norm(x_clean)/norm(x_clean-y_med)));
```

## 5. PRZYKŁAD 2: Filtracja 2D obrazu

```octave
% Przyklad 2: Filtracja 2D - szum Gaussa i impulsowy
pkg load image;   % zaladuj pakiet image (w Octave Online juz zaladowany)

% Generowanie obrazu testowego
[X, Y] = meshgrid(1:100, 1:100);
img = double(((X-50).^2 + (Y-50).^2) < 900);   % kolo

% Dodanie szumu Gaussa
img_gauss = img + 0.2 * randn(size(img));

% Filtracja Gaussowska
h_gauss = fspecial('gaussian', [5 5], 1);
img_filtered_g = imfilter(img_gauss, h_gauss);

% Dodanie szumu impulsowego
img_salt = img;
idx_s = randperm(numel(img), round(0.05*numel(img)));
img_salt(idx_s) = 1;
idx_p = randperm(numel(img), round(0.05*numel(img)));
img_salt(idx_p) = 0;

% Filtracja medianowa 2D
img_filtered_m = medfilt2(img_salt, [3 3]);

figure;
subplot(2,3,1); imagesc(img);      title('Oryginal'); colormap gray; axis off;
subplot(2,3,2); imagesc(img_gauss); title('Szum Gaussa'); colormap gray; axis off;
subplot(2,3,3); imagesc(img_filtered_g); title('Filtr Gaussa'); colormap gray; axis off;
subplot(2,3,4); imagesc(img);      title('Oryginal'); colormap gray; axis off;
subplot(2,3,5); imagesc(img_salt); title('Szum impulsowy'); colormap gray; axis off;
subplot(2,3,6); imagesc(img_filtered_m); title('Filtr medianowy 2D'); colormap gray; axis off;
```

## 6. ZADANIA

1. **Zadanie 1:** Zbadaj, jak rozmiar okna filtru medianowego (3, 7, 11) wpływa na usuwanie szumu impulsowego z sygnału 1D. Oblicz SNR przed i po filtracji.

2. **Zadanie 2:** Zastosuj filtr Laplasjanu do obrazu (ostrzenie). Utwórz obraz wyostrzonego koła: `img_sharp = img + lambda * imfilter(img, h_lap)` gdzie `h_lap = [0 -1 0; -1 4 -1; 0 -1 0]`.

3. **Zadanie 3:** Porównaj filtr uśredniający i Gaussowski do usuwania szumu Gaussowskiego z sygnału 1D. Który daje lepsze wyniki (niższy błąd MSE)?

---

## 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab10_ImieNazwisko.pdf`

**ZAWARTOŚĆ:**
- Tytuł + Imię i Nazwisko
- [ZRZUT] Wykresy z Przykładu 1 i 2
- [ZRZUT] Wykresy z Zadań 1–3
- Wnioski: Kiedy filtr medianowy jest lepszy od uśredniającego? Jakie są ograniczenia filtracji 2D?
- Kod źródłowy wszystkich zadań
