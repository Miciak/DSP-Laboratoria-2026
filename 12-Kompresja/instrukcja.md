# Lab 12: Kompresja sygnałów + DCT

## 1. Cel
Zastosowanie Dyskretnej Transformaty Cosinusowej (DCT) do kompresji sygnałów 1D i obrazów 2D. Zrozumienie zasady kompresji stratnej przez odrzucenie małych współczynników.

## 2. Teoria
Kompresja sygnałów i obrazów polega na zmniejszeniu liczby danych potrzebnych do zapisu lub transmisji. W kompresji stratnej akceptuje się kontrolowaną utratę części informacji, o ile nie powoduje ona istotnego pogorszenia jakości percepcyjnej lub użytkowej.

### Dyskretna transformata cosinusowa
DCT-II, szeroko stosowana w praktyce, opisuje sygnał za pomocą bazy kosinusów:

```
X[k] = sum(x[n] * cos(pi*k*(2*n+1)/(2*N))),  k = 0, ..., N-1
```

Jej kluczową własnością jest koncentracja energii w niewielkiej liczbie pierwszych współczynników dla sygnałów o łagodnych zmianach. Oznacza to, że wiele pozostałych współczynników można pominąć z relatywnie małą utratą jakości.

### Progowanie i kompresja blokowa
W praktyce wykonuje się DCT sygnału lub małych bloków obrazu, a następnie zeruje współczynniki o małej wartości bezwzględnej. Im wyższy próg, tym większy stopień kompresji i tym większy błąd rekonstrukcji. W obrazach często stosuje się bloki 8×8, co stanowi podstawę działania standardu JPEG.

### Miary jakości
Jakość rekonstrukcji ocenia się m.in. za pomocą MSE i PSNR, natomiast skuteczność kompresji — przez liczbę zachowanych współczynników lub współczynnik kompresji `CR`. W laboratorium trzeba zatem analizować jednocześnie dwa aspekty: oszczędność danych i utratę jakości.

## 3. Uruchomienie Octave
| Sposób | Instrukcja |
|--------|-----------|
| **Online** | [octave-online.net](https://octave-online.net) |
| **Windows** | Octave GUI → New Script |
| **Ubuntu** | `octave --gui` |

## 4. PRZYKŁAD 1: Kompresja sygnału 1D przez DCT

```octave
% Lab 12 - Przyklad 1: Kompresja sygnalu 1D przez DCT
fs = 1000;
T  = 0.5;
t  = 0 : 1/fs : T-1/fs;
x  = sin(2*pi*20*t) + 0.5*sin(2*pi*60*t) + 0.2*sin(2*pi*150*t);

N = length(x);
X_dct = dct(x);

thresholds = [0, 0.05, 0.1, 0.3];
figure;
for i = 1:4
    thr  = thresholds(i);
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

**Plik do uruchomienia:** `przyklady/przyklad1.m`

**Komentarz do przykładu:**
- Kod wykonuje DCT sygnału 1D, a następnie usuwa współczynniki poniżej zadanego progu i rekonstruuje sygnał przez IDCT.
- Na wykresach należy obserwować jednocześnie podobieństwo rekonstrukcji do oryginału oraz liczbę zachowanych współczynników i błąd MSE.
- Zmień listę progów lub skład sygnału wejściowego, aby sprawdzić, które sygnały są bardziej podatne na kompresję stratną.
- To podstawowy mechanizm kompresji: zachować informację najistotniejszą energetycznie i odrzucić współczynniki o małym znaczeniu.

## 5. PRZYKŁAD 2: Kompresja obrazu blokami 8×8 (zasada JPEG)

```octave
% Lab 12 - Przyklad 2: Kompresja obrazu blokami 8x8 (zasada JPEG)
[X, Y]   = meshgrid(1:64, 1:64);
img_orig = double(sin(X/5) .* cos(Y/5));

img_comp   = zeros(size(img_orig));
block_size = 8;
quality    = 0.1;

rows = size(img_orig, 1);
cols = size(img_orig, 2);

for r = 1 : block_size : rows
    for c = 1 : block_size : cols
        block = img_orig(r:r+block_size-1, c:c+block_size-1);
        D     = dct2(block);
        thresh = quality * max(abs(D(:)));
        D(abs(D) < thresh) = 0;
        img_comp(r:r+block_size-1, c:c+block_size-1) = idct2(D);
    end
end

mse_img  = mean(mean((img_orig - img_comp).^2));
psnr_val = 10*log10(max(img_orig(:))^2 / mse_img);

figure;
subplot(1,3,1);
imagesc(img_orig);  colormap gray; title('Oryginal'); axis off; colorbar;

subplot(1,3,2);
imagesc(img_comp);  colormap gray;
title(sprintf('Skompresowany\nJakosc=%.0f%%', quality*100));
axis off; colorbar;

subplot(1,3,3);
imagesc(abs(img_orig - img_comp)); colormap hot;
title(sprintf('Roznica\nPSNR=%.1f dB', psnr_val));
axis off; colorbar;
```

**Plik do uruchomienia:** `przyklady/przyklad2.m`

**Komentarz do przykładu:**
- Przykład przenosi ideę DCT do obrazu 2D i ilustruje blokową kompresję w stylu JPEG.
- Poza obrazem zrekonstruowanym ważny jest również obraz różnicowy oraz wartość PSNR, która ilościowo opisuje utratę jakości.
- Zmień parametr `quality` albo rozmiar bloku, aby ocenić, jak rośnie kompresja i jakie artefakty stają się widoczne.
- W sprawozdaniu warto opisać kompromis między oszczędnością danych a utratą drobnych szczegółów obrazu.

## 6. PRZYKŁAD 3: Krzywa jakości kompresji DCT

```octave
% Lab 12 - Przyklad 3: Jakosc kompresji DCT w funkcji progu
fs = 1000;
T  = 0.5;
t  = 0 : 1/fs : T-1/fs;
x  = sin(2*pi*20*t) + 0.5*sin(2*pi*60*t) + 0.2*sin(2*pi*150*t);

X_dct = dct(x);
thresholds = linspace(0, 0.3, 20);
mse = zeros(size(thresholds));
cr  = zeros(size(thresholds));

for i = 1:length(thresholds)
    thr = thresholds(i);
    X_thr = X_dct;
    X_thr(abs(X_dct) < thr * max(abs(X_dct))) = 0;

    x_rec = idct(X_thr);
    mse(i) = mean((x - x_rec).^2);
    cr(i)  = length(X_dct) / max(nnz(X_thr), 1);
end

figure;
subplot(2,1,1);
plot(thresholds * 100, mse, 'o-b');
title('MSE w funkcji progu progowania');
xlabel('Prog [% maksymalnego wspolczynnika]'); ylabel('MSE'); grid on;

subplot(2,1,2);
plot(thresholds * 100, cr, 's-r');
title('Stopien kompresji w funkcji progu progowania');
xlabel('Prog [% maksymalnego wspolczynnika]'); ylabel('CR'); grid on;
```

**Plik do uruchomienia:** `przyklady/przyklad3.m`

**Komentarz do przykładu:**
- Kod wyznacza krzywe `MSE(thr)` i `CR(thr)`, a więc pokazuje zależność jakości rekonstrukcji od stopnia kompresji w sposób bardziej systematyczny niż pojedynczy eksperyment.
- Taki wykres ułatwia znalezienie punktu pracy, w którym dalsze zwiększanie progu daje małą oszczędność, ale duży wzrost błędu.
- Zmień zakres progów lub sygnał wejściowy i sprawdź, jak przesuwa się „kolano” charakterystyki jakości.
- To przykład szczególnie przydatny przy formułowaniu wniosków inżynierskich, ponieważ pozwala podejmować decyzję na podstawie krzywej kompromisu.

## 7. ZADANIA

W zadaniach można korzystać z fragmentów kodu z bieżącego laboratorium oraz z wcześniejszych zajęć. Jeżeli dana technika była już pokazana wcześniej, odwołaj się do niej zamiast niepotrzebnie powielać cały kod od zera.

1. **Zadanie 1:** Zbadaj kompresję sygnału sinusoidalnego z szumem. Zastosuj progi 0%, 10%, 30%, 60% maksymalnego współczynnika DCT. Narysuj wykresy zrekonstruowanych sygnałów i oblicz MSE/SNR.

2. **Zadanie 2:** Wyznacz stopień kompresji (CR) i błąd MSE w funkcji liczby zachowanych współczynników DCT (od 1% do 100%). Narysuj wykres MSE vs CR.

3. **Zadanie 3:** Wykonaj kompresję obrazu blokami 8×8 dla różnych poziomów jakości (5%, 20%, 50%). Oblicz PSNR dla każdego poziomu i opisz zależność jakość–stopień kompresji.

4. **Zadanie 4:** Dla wybranego sygnału lub obrazu wyznacz zależność między progiem progowania, liczbą zachowanych współczynników i błędem rekonstrukcji. Na tej podstawie wskaż zakres parametrów dający rozsądny kompromis między jakością a kompresją.

---

## 8. 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab12_ImieNazwisko.pdf`

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
