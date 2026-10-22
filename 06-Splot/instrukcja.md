# Lab 6: Splot liniowy + splot kołowy

## 1. Cel
Zrozumienie operacji splotu liniowego i kołowego jako podstawowych operacji w systemach liniowych stacjonarnych (LTI). Związek splotu z filtracją cyfrową.

## 2. Teoria
Splot jest podstawową operacją w analizie i przetwarzaniu sygnałów liniowych niezmiennych w czasie (LTI). Pozwala wyznaczyć odpowiedź układu na dowolne pobudzenie, jeśli znana jest odpowiedź impulsowa układu.

### Definicja splotu liniowego
Dla sygnałów dyskretnych `x[n]` i `h[n]` splot liniowy ma postać:

```
y[n] = sum(x[k] * h[n-k])
```

Interpretacyjnie oznacza to przesuwanie jednej sekwencji względem drugiej, mnożenie nakładających się próbek i sumowanie wyników. Jeżeli `h[n]` jest odpowiedzią impulsową filtru, to `y[n]` jest sygnałem po filtracji.

### Splot kołowy i FFT
W obliczeniach widmowych pojawia się splot kołowy, który zakłada periodyczne przedłużenie sygnałów. Jest on bezpośrednio związany z mnożeniem widm w dziedzinie częstotliwości. Aby przez FFT otrzymać wynik równy splotowi liniowemu, trzeba zastosować odpowiednie dopełnienie zerami.

### Znaczenie praktyczne
Operacja splotu wyjaśnia działanie filtrów wygładzających, układów korekcyjnych i wielu algorytmów rekonstrukcji sygnału. Dobre zrozumienie różnicy między splotem liniowym i kołowym jest niezbędne przed projektowaniem filtrów oraz pracą z FFT.

## 3. Uruchomienie Octave
| Sposób | Instrukcja |
|--------|-----------|
| **Online** | [octave-online.net](https://octave-online.net) |
| **Windows** | Octave GUI → New Script |
| **Ubuntu** | `octave --gui` |

## 4. PRZYKŁAD 1: Splot liniowy – filtracja sygnału

```octave
% Lab 6 - Przyklad 1: Splot liniowy - filtracja przez filtr usredniajacy
fs = 200;
T  = 1;
t  = 0 : 1/fs : T-1/fs;
x  = sin(2*pi*5*t) + 0.5*randn(size(t));

M  = 10;
h  = ones(1, M) / M;

y   = conv(x, h);
t_y = (0 : length(y)-1) / fs;

figure;
subplot(2,1,1);
plot(t, x); title('Sygnal wejsciowy (zaszumiony)'); xlabel('t [s]'); grid on;

subplot(2,1,2);
plot(t_y, y); title('Po filtracji (splot z filtrem MA)'); xlabel('t [s]'); grid on;
```

**Plik do uruchomienia:** `przyklady/przyklad1.m`

**Komentarz do przykładu:**
- Kod interpretuje splot jako filtrację sygnału przez odpowiedź impulsową filtru średniej ruchomej.
- Na wykresach należy zwrócić uwagę na wygładzenie przebiegu i osłabienie szybkich zmian po zastosowaniu filtru.
- Zmień długość okna filtru albo poziom zakłóceń, aby zobaczyć kompromis między wygładzaniem a zniekształceniem sygnału użytecznego.
- To bezpośrednie zastosowanie definicji układu LTI: sygnał wyjściowy powstaje przez splot wejścia z odpowiedzią impulsową.

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Zmień odpowiedź impulsową `h` na własną (np. różniczkującą `[1 -1]`) i opisz, co robi z sygnałem.
- Zmień długość filtra uśredniającego i zmierz opóźnienie wyjścia względem wejścia.
- Sprawdź długość wyniku splotu (`N + M - 1`) dla kilku wymyślonych par długości.

## 5. PRZYKŁAD 2: Splot liniowy vs. kołowy oraz twierdzenie o splocie

```octave
% Lab 6 - Przyklad 2: Splot liniowy vs kolowy + twierdzenie o splocie
x = [1, 2, 3, 4, 3, 2, 1];
h = [1, 1, 1] / 3;

y_lin = conv(x, h);

Ly  = length(x) + length(h) - 1;
X_z = fft(x, Ly);
H_z = fft(h, Ly);
y_circ = real(ifft(X_z .* H_z));

fprintf('Splot liniowy:  '); disp(y_lin);
fprintf('Splot kolowy:   '); disp(y_circ);
fprintf('Max roznica:    %.2e\n', max(abs(y_lin - y_circ)));

n_lin = 0 : length(y_lin)-1;
figure;
subplot(2,1,1);
stem(n_lin, y_lin, 'b'); title('Splot liniowy conv()'); xlabel('n'); grid on;

subplot(2,1,2);
stem(n_lin, y_circ, 'r'); title('Splot kolowy (FFT)'); xlabel('n'); grid on;
```

**Plik do uruchomienia:** `przyklady/przyklad2.m`

**Komentarz do przykładu:**
- Przykład porównuje splot liniowy i kołowy oraz pokazuje, jak użyć FFT do uzyskania poprawnego wyniku po dopełnieniu zerami.
- Jest to kluczowe rozróżnienie praktyczne, ponieważ niepoprawne użycie FFT może prowadzić do efektu zawijania sygnału.
- Zmień długości analizowanych sygnałów lub usuń dopełnienie zerami, aby zaobserwować, kiedy wynik przestaje odpowiadać splotowi liniowemu.
- W sprawozdaniu warto podkreślić, że mnożenie widm nie daje automatycznie poprawnego splotu liniowego bez kontroli długości sekwencji.

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Dobierz długość zero-paddingu tak, aby splot kołowy był identyczny z liniowym – ile minimum próbek potrzeba?
- Zmierz czas obliczeń splotu `conv` i metody przez FFT dla coraz dłuższych sygnałów (`tic`/`toc`).
- Sprawdź efekt „owinięcia” (aliasing czasowy) przy zbyt krótkim FFT.

## 6. PRZYKŁAD 3: Ręczna realizacja splotu liniowego

```octave
% Lab 6 - Przyklad 3: Reczna realizacja splotu liniowego
x = [1, 2, 1, 0];
h = [1, -1, 2];

y_builtin = conv(x, h);
y_manual  = zeros(1, length(x) + length(h) - 1);

for n = 1:length(y_manual)
    for k = 1:length(x)
        m = n - k + 1;
        if m >= 1 && m <= length(h)
            y_manual(n) = y_manual(n) + x(k) * h(m);
        end
    end
end

figure;
subplot(2,1,1);
stem(y_builtin, 'filled');
title('Splot z funkcji conv'); xlabel('n'); ylabel('Amp'); grid on;

subplot(2,1,2);
stem(y_manual, 'filled');
title('Splot liczony recznie'); xlabel('n'); ylabel('Amp'); grid on;

fprintf('Maksymalna roznica miedzy wynikami: %.6f\n', max(abs(y_builtin - y_manual)));
```

**Plik do uruchomienia:** `przyklady/przyklad3.m`

**Komentarz do przykładu:**
- Kod odtwarza definicję splotu krok po kroku i porównuje wynik z funkcją wbudowaną `conv`.
- To dobry przykład uzupełniający teorię, ponieważ pokazuje, skąd bierze się każdy element sygnału wyjściowego.
- Zmień wektory `x` i `h`, aby sprawdzić, jak rośnie długość wyniku i które próbki w największym stopniu wpływają na kolejne wartości `y[n]`.
- Jeżeli maksymalna różnica jest równa zero, oznacza to zgodność implementacji ręcznej z definicją matematyczną.

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Napisz własną implementację splotu inaczej niż w przykładzie (np. metodą „odwrócenia i przesuwania”) i porównaj wyniki.
- Przetestuj funkcję na sygnałach losowych i zmierz maksymalny błąd względem `conv`.
- Zaproponuj własną odpowiedź impulsową z echem i posłuchaj/przeanalizuj jej wpływ na sygnał.

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

N  = randi([8 14]);                 % dlugosc sygnalu x
M  = randi([3 6]);                  % dlugosc odpowiedzi h
x  = randi([-5 5], 1, N);           % losowy sygnal calkowitoliczbowy
h1 = randi([-3 3], 1, M);           % pierwsza odpowiedz impulsowa
h2 = ones(1, randi([4 9])) / 6;     % druga - filtr usredniajacy o losowej dlugosci
fn = randi([5 15]);                 % czestotliwosc sinusa do zadan z szumem [Hz]
sigma = randi([2 6]) / 10;          % odchylenie standardowe szumu
disp(x); disp(h1);
```

### 7.3 Zadania na ocenę 4.0

1. **Zadanie 1:** Wykonaj splot sygnału `x = [1 2 3 2 1]` z odpowiedzią impulsową `h = [1 0 -1]`. Oblicz wynik ręcznie i zweryfikuj w Octave.

2. **Zadanie 2:** Zaszum sygnał sinusoidalny i zastosuj filtr uśredniający o różnych długościach (M = 5, 15, 30). Porównaj wyniki filtracji.

3. **Zadanie 3 (losowe):** Zaimplementuj splot liniowy **bez** `conv()` (pętle) dla wylosowanych `x` i `h1`. Porównaj z `conv()` (maksymalny błąd musi być równy 0), narysuj wynik funkcją `stem` i oblicz ręcznie trzy wybrane próbki wyjścia.

4. **Zadanie 4 (losowe, swoboda):** Zaszum sinus `fn` (szum o `sigma`) i przefiltruj go odpowiedziami `h2` oraz **własną** odpowiedzią impulsową (np. różniczkującą, wygładzającą z wagami, z echem). Porównaj wygładzanie, opóźnienie i wzmocnienie wyniku (MSE względem sygnału czystego) i zaproponuj, która odpowiedź jest najlepsza dla tego sygnału.

### 7.4 Zadanie na ocenę 5.0

5. **Zadanie 5★ (na 5.0):** Zrealizuj *szybki splot* sygnału o długości `L ≥ 5000` z odpowiedzią `h2` metodą FFT (Laboratorium 5): dobierz minimalną długość FFT do uzyskania splotu liniowego i udowodnij zgodność z `conv()`. Następnie porównaj odpowiedź częstotliwościową filtra `h2` obliczoną z `fft(h2, Nfft)` z wartościami teoretycznymi, sprawdź w widmie, które składowe zaszumionego sinusa (Laboratorium 1–2) zostały stłumione, i zmierz czasy `conv` i metody FFT dla trzech długości sygnału. Wyniki przedstaw w tabeli i krótko wyjaśnij, od jakiej długości FFT jest szybsza.

*Zadanie 5★ jest dobrowolne i podnosi ocenę z 4.0 do 5.0 pod warunkiem poprawnego wykonania zadań 1–4.*

---

## 8. 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab6_ImieNazwisko.pdf`

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
