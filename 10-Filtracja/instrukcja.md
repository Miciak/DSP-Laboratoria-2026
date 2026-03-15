# Lab 10: Filtracja 1D, 2D i filtry nieliniowe

## 1. Cel
Zastosowanie filtracji cyfrowej do sygnałów 1D i obrazów 2D. Poznanie filtrów nieliniowych (medianowego) i porównanie z filtrami liniowymi.

## 2. Teoria
Filtracja polega na przekształcaniu sygnału w celu osłabienia niepożądanych składowych i zachowania informacji użytecznej. W praktyce stosuje się zarówno filtry liniowe, jak i nieliniowe, a wybór metody zależy od typu zakłóceń i rodzaju danych.

### Filtracja liniowa i nieliniowa
Filtry liniowe wykonują ważoną sumę próbek lub pikseli w sąsiedztwie. Są skuteczne wobec szumu gaussowskiego i dobrze opisane teorią częstotliwościową. Filtry nieliniowe, takie jak filtr medianowy, nie są opisywane przez prostą transmitancję, ale bardzo dobrze radzą sobie z zakłóceniami impulsowymi.

### Filtracja 1D i 2D
W sygnałach jednowymiarowych analizujemy zwykle relację między wygładzaniem a zachowaniem ostrych zmian. W obrazach 2D rozpatruje się dodatkowo rozmycie krawędzi, utratę detali i usuwanie ziarnistych zakłóceń. Ten sam algorytm może działać inaczej dla danych czasowych i przestrzennych.

### Kryteria oceny
Podczas oceny filtracji należy porównywać nie tylko estetykę wykresu lub obrazu, ale również utratę szczegółów, zachowanie krawędzi i ewentualną poprawę miar jakości, takich jak SNR lub MSE. Z tego powodu w laboratorium warto analizować kilka wariantów parametrów filtru, a nie tylko pojedynczy wynik.

## 3. Uruchomienie Octave
| Sposób | Instrukcja |
|--------|-----------|
| **Online** | [octave-online.net](https://octave-online.net) |
| **Windows** | Octave GUI → New Script |
| **Ubuntu** | `octave --gui` oraz `pkg load image` |

## 4. PRZYKŁAD 1: Filtracja 1D – liniowy vs. medianowy

```octave
% Lab 10 - Przyklad 1: Filtracja 1D - liniowa vs medianowa
fs = 500;
T  = 1;
t  = 0 : 1/fs : T-1/fs;
x_clean = sin(2*pi*10*t);

x_noisy = x_clean;
idx = randperm(length(x_clean), 50);
x_noisy(idx) = sign(randn(1,50));

M     = 5;
h     = ones(1, M) / M;
y_lin = conv(x_noisy, h, 'same');
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

fprintf('SNR filtr liniowy:    %.2f dB\n', ...
    20*log10(norm(x_clean)/norm(x_clean-y_lin)));
fprintf('SNR filtr medianowy:  %.2f dB\n', ...
    20*log10(norm(x_clean)/norm(x_clean-y_med)));
```

**Plik do uruchomienia:** `przyklady/przyklad1.m`

**Komentarz do przykładu:**
- Przykład porównuje filtr liniowy i medianowy dla sygnału 1D z zakłóceniami impulsowymi.
- Na wynikach należy ocenić nie tylko redukcję szumu, ale także to, w jakim stopniu filtr zachowuje kształt przebiegu użytecznego.
- Zmień liczbę i amplitudę impulsów zakłócających, aby sprawdzić, kiedy filtr medianowy daje przewagę nad filtrem liniowym.
- To klasyczny przykład pokazujący, że wybór filtru musi być dopasowany do rodzaju zakłócenia, a nie wyłącznie do oczekiwanego stopnia wygładzenia.

## 5. PRZYKŁAD 2: Filtracja 2D obrazu

```octave
% Lab 10 - Przyklad 2: Filtracja 2D obrazu
pkg load image;

[X, Y] = meshgrid(1:100, 1:100);
img = double(((X-50).^2 + (Y-50).^2) < 900);

% Szum Gaussa + filtr Gaussowski
img_gauss = img + 0.2 * randn(size(img));
h_gauss   = fspecial('gaussian', [5 5], 1);
img_fg    = imfilter(img_gauss, h_gauss);

% Szum impulsowy + filtr medianowy
img_salt = img;
idx_s = randperm(numel(img), round(0.05*numel(img)));
img_salt(idx_s) = 1;
idx_p = randperm(numel(img), round(0.05*numel(img)));
img_salt(idx_p) = 0;
img_fm = medfilt2(img_salt, [3 3]);

figure;
subplot(2,3,1); imagesc(img);      title('Oryginal');         colormap gray; axis off;
subplot(2,3,2); imagesc(img_gauss); title('Szum Gaussa');     colormap gray; axis off;
subplot(2,3,3); imagesc(img_fg);   title('Filtr Gaussa');     colormap gray; axis off;
subplot(2,3,4); imagesc(img);      title('Oryginal');         colormap gray; axis off;
subplot(2,3,5); imagesc(img_salt); title('Szum impulsowy');   colormap gray; axis off;
subplot(2,3,6); imagesc(img_fm);   title('Filtr medianowy 2D'); colormap gray; axis off;
```

**Plik do uruchomienia:** `przyklady/przyklad2.m`

**Komentarz do przykładu:**
- Kod przenosi problem filtracji do obrazu 2D i zestawia rozmycie gaussowskie z filtrem medianowym.
- Dzięki temu można ocenić, które rozwiązanie lepiej usuwa zakłócenia impulsowe i jak silnie degradowane są krawędzie obrazu.
- Zmień rozmiar maski lub poziom zakłóceń, aby porównać kompromis między usuwaniem szumu a utratą detali.
- W sprawozdaniu warto odwołać się do konkretnych fragmentów obrazu, gdzie różnice między metodami są najlepiej widoczne.

## 6. PRZYKŁAD 3: Wpływ długości filtru medianowego na sygnał 1D

```octave
% Lab 10 - Przyklad 3: Rozna dlugosc filtru medianowego
n = 0:399;
x = sin(2*pi*0.03*n);
x_noise = x;
x_noise([50, 120, 121, 250, 320]) = [2, -2, 2, -1.5, 1.8];

y3 = medfilt1(x_noise, 3);
y5 = medfilt1(x_noise, 5);
y9 = medfilt1(x_noise, 9);

figure;
subplot(4,1,1);
plot(n, x_noise, 'k');
title('Sygnal z zakloceniami impulsowymi'); ylabel('Amp'); grid on;

subplot(4,1,2);
plot(n, y3, 'b');
title('Filtr medianowy, okno = 3'); ylabel('Amp'); grid on;

subplot(4,1,3);
plot(n, y5, 'r');
title('Filtr medianowy, okno = 5'); ylabel('Amp'); grid on;

subplot(4,1,4);
plot(n, y9, 'g');
title('Filtr medianowy, okno = 9'); xlabel('n'); ylabel('Amp'); grid on;
```

**Plik do uruchomienia:** `przyklady/przyklad3.m`

**Komentarz do przykładu:**
- Kod bada wpływ długości okna filtru medianowego na sygnał z impulsami zakłócającymi.
- Krótki filtr może nie usuwać wszystkich impulsów, natomiast zbyt długie okno zaczyna nadmiernie wygładzać przebieg użyteczny.
- Zmień długości okna lub położenie impulsów, aby sprawdzić, jak filtr reaguje na skupione i rozproszone zakłócenia.
- To przykład prowadzący „krok dalej” od przykładu 1: pokazuje, że sama zmiana parametru filtru istotnie wpływa na końcowy wynik.

## 7. ZADANIA

W zadaniach można korzystać z fragmentów kodu z bieżącego laboratorium oraz z wcześniejszych zajęć. Jeżeli dana technika była już pokazana wcześniej, odwołaj się do niej zamiast niepotrzebnie powielać cały kod od zera.

1. **Zadanie 1:** Zbadaj, jak rozmiar okna filtru medianowego (3, 7, 11) wpływa na usuwanie szumu impulsowego z sygnału 1D. Oblicz SNR przed i po filtracji.

2. **Zadanie 2:** Zastosuj filtr Laplasjanu do obrazu (ostrzenie). Utwórz obraz wyostrzonego koła: `img_sharp = img + lambda * imfilter(img, h_lap)` gdzie `h_lap = [0 -1 0; -1 4 -1; 0 -1 0]`.

3. **Zadanie 3:** Porównaj filtr uśredniający i Gaussowski do usuwania szumu Gaussowskiego z sygnału 1D. Który daje lepsze wyniki (niższy błąd MSE)?

4. **Zadanie 4:** Porównaj działanie filtru medianowego dla co najmniej trzech różnych długości okna i wskaż wariant najlepszy dla wybranego sygnału z zakłóceniami impulsowymi. Uzasadnij wybór na podstawie wykresów i krótkiej analizy jakości.

---

## 8. 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab10_ImieNazwisko.pdf`

**WYMAGANA STRUKTURA SPRAWOZDANIA:**
1. **Strona tytułowa:** imię i nazwisko, temat laboratorium oraz data wykonania laboratorium.
2. **Wnioski i spostrzeżenia z przykładów 1–3:** opisz, co realizuje każdy przykład, jakie parametry zostały zmienione oraz jak te zmiany wpłynęły na wykresy lub wyniki.
3. **Rozwiązanie każdego zadania** — dla Zadania 1–4 przygotuj osobny podrozdział zawierający:
   - koncepcję rozwiązania,
   - kod źródłowy,
   - wyniki (wykresy i/lub tabele),
   - wnioski dotyczące danego zadania.
4. **Podsumowanie całego laboratorium:** najważniejsze obserwacje, odniesienie do teorii i krótkie podsumowanie zdobytych umiejętności.

**UWAGI TECHNICZNE:**
- Stosuj podział na rozdziały i podrozdziały wszędzie tam, gdzie poprawia on czytelność dokumentu.
- Numeruj i podpisuj wszystkie wykresy; w tekście odwołuj się do nich wprost (np. „na rys. 2 pokazano ...”).
- W tekście odwołuj się także do zamieszczonego kodu i wyjaśniaj, które parametry zostały zmienione.
- Każdy wykres powinien mieć opisane osie, jednostki oraz legendę, jeżeli porównujesz kilka przebiegów.
- Zachowaj formalny, rzeczowy styl sprawozdania i formułuj wnioski samodzielnie, na podstawie uzyskanych wyników.
