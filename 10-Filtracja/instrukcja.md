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

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Zmień gęstość zakłóceń impulsowych i sprawdź, kiedy filtr medianowy przestaje być skuteczny.
- Zaproponuj własną miarę jakości (np. maksymalny błąd lokalny) i porównaj ją z SNR/MSE.
- Zastosuj filtr uśredniający i medianowy kaskadowo – czy kolejność ma znaczenie?

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

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Zmień obraz testowy na własny (np. wygenerowany z kształtów) i oceń zachowanie krawędzi po filtracji.
- Zbadaj wpływ rozmiaru maski (3×3, 5×5, 9×9) na rozmycie i szum.
- Dodaj do obrazu szum impulsowy zamiast gaussowskiego i porównaj skuteczność filtrów.

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

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Znajdź długość okna medianowego, która minimalizuje MSE dla Twojego sygnału, i narysuj wykres MSE vs długość okna.
- Sprawdź, jak mediana zachowuje strome zbocza w porównaniu z filtrem uśredniającym tej samej długości.
- Zaproponuj własny sygnał z ostrymi krawędziami i uzasadnij najlepszy wariant filtracji.

## 7. ZADANIA

W zadaniach można korzystać z fragmentów kodu z bieżącego laboratorium oraz z wcześniejszych zajęć. Jeżeli dana technika była już pokazana wcześniej, odwołaj się do niej zamiast niepotrzebnie powielać cały kod od zera.

### 7.1 Zasady oceny i swoboda pracy
- Wszystkie zadania **1–4** odpowiadają ocenie **4.0**. Ocenę **5.0** można uzyskać dodatkowo za **Zadanie 5★**, które jest trudniejsze i wymaga połączenia bieżącego tematu z zagadnieniami z poprzednich ćwiczeń (wskazane w treści zadania).
- Zadania **1–2** są takie same dla wszystkich (podstawy). Zadania **3–4** oraz Zadanie 5★ mają **parametry losowe**, więc każde sprawozdanie będzie inne – nie kopiuj wyników od innych osób.
- W zadaniach „swobodnych” sam wybierasz sygnały, metody, rozmiary i kryteria; **musisz** jednak uzasadnić swoje decyzje liczbami i wykresami.

### 7.2 Losowanie parametrów (wykonaj na początku skryptu)
Wpisz ostatnie 4 cyfry swojego numeru albumu do zmiennej `nr` – dzięki `rand('state', nr)` ten sam numer zawsze daje te same parametry (powtarzalność), a różne numery dają różne sprawozdania. **Wartości wylosowanych parametrów wypisz w sprawozdaniu.**

```octave
nr = 1234;                  % <- ostatnie 4 cyfry numeru albumu
rand('state', nr); randn('state', nr);

fs = 1000; t = 0:1/fs:1-1/fs;
f   = randi([3 12]);                        % czestotliwosc sygnalu uzytecznego [Hz]
sigma = randi([2 8]) / 10;                  % odchylenie szumu gaussowskiego
p   = randi([3 12]) / 100;                  % gestosc szumu impulsowego
win = sort(randperm(6, 3)) * 2 + 1;         % trzy nieparzyste dlugosci okna (3..13)
n_shapes = randi([3 6]);                    % liczba losowych ksztaltow w obrazie
fprintf('f=%d sigma=%.1f p=%.2f okna=%s ksztalty=%d\n', f, sigma, p, mat2str(win), n_shapes);
```

### 7.3 Zadania na ocenę 4.0

1. **Zadanie 1:** Zbadaj, jak rozmiar okna filtru medianowego (3, 7, 11) wpływa na usuwanie szumu impulsowego z sygnału 1D. Oblicz SNR przed i po filtracji.

2. **Zadanie 2:** Zastosuj filtr Laplasjanu do obrazu (ostrzenie). Utwórz obraz wyostrzonego koła: `img_sharp = img + lambda * imfilter(img, h_lap)` gdzie `h_lap = [0 -1 0; -1 4 -1; 0 -1 0]`.

3. **Zadanie 3 (losowe):** Dodaj do sinusa `f` szum Gaussowski o `sigma` i porównaj filtr uśredniający oraz Gaussowski dobierając szerokość okna z `win`. Oblicz MSE i SNR dla każdego wariantu, wskaż najlepszy i wytłumacz, dlaczego mediana nie jest tu naturalnym wyborem.

4. **Zadanie 4 (losowe, swoboda):** Dodaj do sygnału (**własnego lub sinusa `f`**) szum impulsowy o gęstości `p` i oceń filtr medianowy dla okien z `win` oraz co najmniej jeden filtr liniowy. Zbuduj tabelę MSE/SNR, wskaż wariant najlepszy i uzasadnij go także oceną wizualną wykresów (zachowanie krawędzi).

### 7.4 Zadanie na ocenę 5.0

5. **Zadanie 5★ (na 5.0):** Wygeneruj obraz o rozmiarze 128×128 z `n_shapes` losowo rozmieszczonymi kształtami (prostokąty/koła o losowej jasności) i zakłóć go jednocześnie szumem gaussowskim (`sigma`) i impulsowym (`p`). Zaprojektuj dwuetapowy tor: najpierw filtr medianowy (usuwa impulsy), potem filtr liniowy – uśredniający lub Gaussowski, zrealizowany splotem 2D (Laboratorium 6), a ostry wynik zweryfikuj profilem jednej linii (porównanie z oryginałem przez FFT 1D, Laboratorium 5). Dla każdego wariantu kolejności filtrów oblicz PSNR i krawędziowy błąd; porównaj z filtrem FIR 1D zaprojektowanym w Laboratorium 9 zastosowanym wzdłuż wierszy.

*Zadanie 5★ jest dobrowolne i podnosi ocenę z 4.0 do 5.0 pod warunkiem poprawnego wykonania zadań 1–4.*

---

## 8. 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab10_ImieNazwisko.pdf`

**WYMAGANA STRUKTURA SPRAWOZDANIA:**
1. **Strona tytułowa:** imię i nazwisko, temat laboratorium oraz data wykonania laboratorium.
2. **Parametry losowe:** wpisany numer `nr` oraz kod losowania wraz z wylosowanymi wartościami.
3. **Wnioski i spostrzeżenia z przykładów 1–3:** opisz, co realizuje każdy przykład, jakie parametry zostały zmienione (w tym wybrany eksperyment „Twoja kolej”) oraz jak te zmiany wpłynęły na wykresy lub wyniki.
4. **Rozwiązanie każdego zadania** — dla Zadania 1–4 (oraz 5★, jeśli je wykonujesz) przygotuj osobny podrozdział zawierający:
   - koncepcję rozwiązania,
   - kod źródłowy,
   - wyniki (wykresy i/lub tabele),
   - wnioski dotyczące danego zadania.
5. **Podsumowanie całego laboratorium:** najważniejsze obserwacje, odniesienie do teorii i krótkie podsumowanie zdobytych umiejętności.

**UWAGI TECHNICZNE:**
- Stosuj podział na rozdziały i podrozdziały wszędzie tam, gdzie poprawia on czytelność dokumentu.
- Numeruj i podpisuj wszystkie wykresy; w tekście odwołuj się do nich wprost (np. „na rys. 2 pokazano ...”).
- W tekście odwołuj się także do zamieszczonego kodu i wyjaśniaj, które parametry zostały zmienione.
- Każdy wykres powinien mieć opisane osie, jednostki oraz legendę, jeżeli porównujesz kilka przebiegów.
- Zachowaj formalny, rzeczowy styl sprawozdania i formułuj wnioski samodzielnie, na podstawie uzyskanych wyników.
