# Lab 12: Kompresja sygnałów + DCT

## 1. Cel
Zastosowanie Dyskretnej Transformaty Cosinusowej (DCT) do kompresji sygnałów 1D i obrazów 2D. Zrozumienie zasady kompresji stratnej przez odrzucenie małych współczynników.

## 2. Teoria

### DCT (Discrete Cosine Transform)
DCT-II (najczęściej używana, np. w JPEG):
```
X[k] = Σ x[n] · cos(π·k·(2n+1) / (2N)),  k = 0, ..., N-1
```

Właściwości DCT:
- Koncentruje energię w pierwszych współczynnikach (niskie częstotliwości)
- Odwracalna (IDCT)
- Baza używana w kompresji JPEG, MP3, MPEG

### Zasada kompresji stratnej
1. Oblicz DCT sygnału/bloku
2. Odrzuć współczynniki o małej wartości (progowanie: `|X[k]| < próg → 0`)
3. Oblicz IDCT
4. Im wyższy próg → większa kompresja, większy błąd

### Stopień kompresji
```
CR = N_oryginal / N_zachowanych
```

## 3. Uruchomienie Octave

| Sposób | Instrukcja |
|--------|-----------|
| **Online** | [octave-online.net](https://octave-online.net) |
| **Windows** | Octave GUI → New Script |
| **Ubuntu** | `octave --gui` |

## 4. PRZYKŁAD 1: Kompresja sygnału 1D przez DCT

```octave
% Przyklad 1: Kompresja sygn. 1D metodą DCT z progowaniem
fs = 1000;
T  = 0.5;
t  = 0 : 1/fs : T-1/fs;
x  = sin(2*pi*20*t) + 0.5*sin(2*pi*60*t) + 0.2*sin(2*pi*150*t);

N = length(x);

% DCT sygnalu
X_dct = dct(x);

% Progowanie - zachowaj tylko najwazniejsze wspolczynniki
thresholds = [0, 0.05, 0.1, 0.3];
figure;
for i = 1:4
    thr = thresholds(i);
    X_thr = X_dct;
    X_thr(abs(X_dct) < thr * max(abs(X_dct))) = 0;

    n_nonzero = sum(X_thr ~= 0);
    x_rec = idct(X_thr);
    mse   = mean((x - x_rec).^2);

    subplot(2,2,i);
    plot(t, x, 'b'); hold on; plot(t, x_rec, 'r--');
    legend('Oryginal', 'Rekonstrukcja');
    title(sprintf('Prog=%.0f%%, WSP=%d/%d, MSE=%.4f', thr*100, n_nonzero, N, mse));
    xlabel('t [s]'); grid on;
end
sgtitle('Kompresja DCT z roznym progowaniem');
```

## 5. PRZYKŁAD 2: Kompresja obrazu blokami 8×8 (zasada JPEG)

```octave
% Przyklad 2: Kompresja obrazu metoda DCT blokami 8x8 (JPEG-like)
[X, Y]  = meshgrid(1:64, 1:64);
img_orig = double(sin(X/5) .* cos(Y/5));  % obraz testowy 64x64

img_comp = zeros(size(img_orig));
block_size = 8;
quality = 0.1;   % zachowaj 10% wspolczynnikow DCT w kazdym bloku

rows = size(img_orig, 1);
cols = size(img_orig, 2);

for r = 1 : block_size : rows
    for c = 1 : block_size : cols
        block = img_orig(r:r+block_size-1, c:c+block_size-1);
        D     = dct2(block);              % DCT 2D bloku
        thresh = quality * max(abs(D(:)));
        D(abs(D) < thresh) = 0;           % progowanie
        img_comp(r:r+block_size-1, c:c+block_size-1) = idct2(D);
    end
end

mse_img = mean(mean((img_orig - img_comp).^2));
psnr_val = 10*log10(max(img_orig(:))^2 / mse_img);

figure;
subplot(1,3,1);
imagesc(img_orig); colormap gray; title('Oryginal'); axis off; colorbar;

subplot(1,3,2);
imagesc(img_comp); colormap gray;
title(sprintf('Skompresowany\nJakosc=%.0f%%', quality*100));
axis off; colorbar;

subplot(1,3,3);
imagesc(abs(img_orig - img_comp)); colormap hot;
title(sprintf('Roznica\nPSNR=%.1f dB', psnr_val));
axis off; colorbar;
```

## 6. ZADANIA

1. **Zadanie 1:** Zbadaj kompresję sygnału sinusoidalnego z szumem. Zastosuj progi 0%, 10%, 30%, 60% maksymalnego współczynnika DCT. Narysuj wykresy zrekonstruowanych sygnałów i oblicz MSE/SNR.

2. **Zadanie 2:** Wyznacz stopień kompresji (CR) i błąd MSE w funkcji liczby zachowanych współczynników DCT (od 1% do 100%). Narysuj wykres MSE vs CR.

3. **Zadanie 3:** Wykonaj kompresję obrazu blokami 8×8 dla różnych poziomów jakości (5%, 20%, 50%). Oblicz PSNR dla każdego poziomu i opisz zależność jakość–stopień kompresji.

---

## 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab12_ImieNazwisko.pdf`

**ZAWARTOŚĆ:**
- Tytuł + Imię i Nazwisko
- [ZRZUT] Wykresy z Przykładu 1 i 2
- [ZRZUT] Wykresy z Zadań 1–3
- Wnioski: Dlaczego DCT jest lepsza od DFT do kompresji? Jaki jest kompromis między stopniem kompresji a jakością? Jak działa JPEG?
- Kod źródłowy wszystkich zadań
