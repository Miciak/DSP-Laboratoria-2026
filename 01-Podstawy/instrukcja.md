# Lab 1: Instalacja + Podstawy sygnałów

## 1. Cel
Zapoznanie się z środowiskiem GNU Octave oraz podstawowymi operacjami na sygnałach ciągłych i dyskretnych. Generowanie i wizualizacja podstawowych sygnałów (sinus, cosinus, sygnał prostokątny, piłokształtny).

## 2. Teoria
Sygnał jest matematycznym opisem zjawiska fizycznego zależnego od czasu, położenia lub innej zmiennej niezależnej. W laboratoriach DSP najczęściej pracujemy z sygnałami czasowymi i interesuje nas zarówno ich postać ciągła `x(t)`, jak i dyskretna `x[n]`, otrzymywana po próbkowaniu.

### Reprezentacja podstawowych sygnałów
Dla sygnałów harmonicznych stosujemy zapis:
- sinus: `x(t) = A \cdot sin(2\pi f t + \varphi)`
- cosinus: `x(t) = A \cdot cos(2\pi f t + \varphi)`

gdzie `A` oznacza amplitudę, `f` częstotliwość, a `\varphi` fazę początkową. Zmiana amplitudy wpływa na wysokość przebiegu, zmiana częstotliwości na liczbę okresów w zadanym czasie, natomiast zmiana fazy przesuwa sygnał w osi czasu.

W praktyce analizuje się również sygnały niesinusoidalne, np. prostokątne, trójkątne i piłokształtne. Są one ważne, ponieważ zawierają ostre przejścia i dobrze pokazują ograniczenia rzeczywistych układów pomiarowych oraz różnice między przebiegami o tej samej amplitudzie i częstotliwości podstawowej.

### Sygnał ciągły i dyskretny
Sygnał ciągły jest określony dla każdej chwili czasu `t \in \mathbb{R}`. W komputerze pracujemy jednak na sekwencjach próbek `x[n]`, gdzie `n \in \mathbb{Z}`. Wektor czasu w Octave buduje się zwykle w postaci `t = 0:1/fs:T-1/fs`, gdzie `fs` jest częstotliwością próbkowania. Już na tym etapie warto zauważyć, że liczba próbek zależy jednocześnie od `fs` i czasu obserwacji `T`.

### Znaczenie praktyczne
Podstawowe przebiegi stanowią elementarne „klocki”, z których buduje się bardziej złożone sygnały. Umiejętność ich generowania i świadomej zmiany parametrów jest niezbędna w kolejnych laboratoriach, ponieważ późniejsze zagadnienia — próbkowanie, analiza widmowa, filtracja i kompresja — zawsze odnoszą się do konkretnych własności sygnału wejściowego.

## 3. Uruchomienie Octave
| Sposób | Instrukcja |
|--------|-----------|
| **Online** | Wejdź na [octave-online.net](https://octave-online.net), wklej kod i naciśnij Run |
| **Windows** | Zainstaluj z [octave.org](https://octave.org/download), uruchom GUI lub terminal |
| **Ubuntu** | `sudo apt install octave` następnie `octave --gui` |

## 4. PRZYKŁAD 1: Generowanie i wykres sygnału sinusoidalnego

```octave
% Lab 1 - Przyklad 1: Sygnal sinusoidalny
% Parametry
fs = 1000;          % czestotliwosc probkowania [Hz]
T  = 1;             % czas trwania sygnalu [s]
f  = 5;             % czestotliwosc sygnalu [Hz]
A  = 1;             % amplituda

t = 0 : 1/fs : T-1/fs;   % wektor czasu
x = A * sin(2*pi*f*t);    % sygnal sinusoidalny

figure;
plot(t, x);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Sygnal sinusoidalny f=5 Hz');
grid on;
```

**Plik do uruchomienia:** `przyklady/przyklad1.m`

**Komentarz do przykładu:**
- Kod definiuje podstawowe parametry modelu sygnału: częstotliwość próbkowania `fs`, czas obserwacji `T`, częstotliwość `f` oraz amplitudę `A`.
- Wynik ilustruje zależność między częstotliwością a liczbą okresów widocznych na wykresie w ustalonym przedziale czasu.
- Zmień `f` z `5 Hz` na `10 Hz`, aby zobaczyć gęstsze oscylacje, oraz `A` z `1` na `2`, aby porównać wpływ amplitudy na wysokość przebiegu.
- Zwiększenie `fs` nie zmienia samego sygnału, ale poprawia gęstość próbkowania i czytelność reprezentacji dyskretnej.

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Zmień `f` i `A` na własne wartości i dopisz trzeci wykres z sygnałem o przesunięciu fazowym `pi/3` – opisz, co zmienia faza, a czego nie zmienia.
- Wyświetl ten sam sygnał z różnymi liczbami próbek (np. `fs = 20`, `100`, `1000`) i oceń, od jakiej gęstości wykres przestaje być „łamany”.
- Dodaj `fprintf` z liczbą okresów widocznych na wykresie i sprawdź ją na rysunku.

## 5. PRZYKŁAD 2: Porównanie sygnałów podstawowych

```octave
% Lab 1 - Przyklad 2: Porownanie roznych typow sygnalow
fs = 1000;
T  = 1;
f  = 3;
t  = 0 : 1/fs : T-1/fs;

x_sin  = sin(2*pi*f*t);
x_cos  = cos(2*pi*f*t);
x_sq   = square(2*pi*f*t);
x_saw  = sawtooth(2*pi*f*t);

figure;
subplot(2,2,1);
plot(t, x_sin); title('Sinus'); xlabel('t [s]'); grid on;

subplot(2,2,2);
plot(t, x_cos); title('Cosinus'); xlabel('t [s]'); grid on;

subplot(2,2,3);
plot(t, x_sq);  title('Prostokat'); xlabel('t [s]'); grid on;

subplot(2,2,4);
plot(t, x_saw); title('Piloksztaltny'); xlabel('t [s]'); grid on;
```

**Plik do uruchomienia:** `przyklady/przyklad2.m`

**Komentarz do przykładu:**
- Przykład zestawia sygnały o tej samej częstotliwości podstawowej i tym samym wektorze czasu, dzięki czemu można porównać wyłącznie ich kształt.
- Sinus i cosinus różnią się fazą, natomiast sygnały prostokątny i piłokształtny mają nieciągłości, które później okażą się istotne w analizie widmowej.
- Zmień `f` na `5 Hz` albo wydłuż `T`, aby ocenić, jak rośnie liczba okresów i jak zmienia się czytelność porównania.
- Jeżeli wprowadzisz wspólną amplitudę `A` i przemnożysz przez nią wszystkie przebiegi, łatwo porównasz jednocześnie wpływ kształtu i skali sygnału.

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Wymyśl własną parę przebiegów (np. sinus i prostokąt o innych częstotliwościach) i porównaj je na wspólnym wykresie z legendą.
- Sprawdź, co się stanie, gdy do sygnału dodasz stałą składową (offset) – jak zmieni się wykres, a jak jego kształt?
- Zaproponuj własne kryterium: który z przebiegów jest „najbardziej gładki” i uzasadnij je liczbowo (np. maksymalna różnica sąsiednich próbek).

## 6. PRZYKŁAD 3: Suma dwóch sinusoid o różnych parametrach

```octave
% Lab 1 - Przyklad 3: Suma dwoch sinusoid
fs = 1000;                 % czestotliwosc probkowania [Hz]
T  = 2;                    % czas obserwacji [s]
t  = 0 : 1/fs : T-1/fs;

A1 = 1.0;  f1 = 3;  phi1 = 0;
A2 = 0.6;  f2 = 7;  phi2 = pi/4;

x1 = A1 * sin(2*pi*f1*t + phi1);
x2 = A2 * sin(2*pi*f2*t + phi2);
x  = x1 + x2;

figure;
subplot(3,1,1);
plot(t, x1);
title('Skladnik 1: 3 Hz'); xlabel('Czas [s]'); ylabel('Amp'); grid on;

subplot(3,1,2);
plot(t, x2);
title('Skladnik 2: 7 Hz, faza pi/4'); xlabel('Czas [s]'); ylabel('Amp'); grid on;

subplot(3,1,3);
plot(t, x, 'k');
title('Suma dwoch sinusoid'); xlabel('Czas [s]'); ylabel('Amp'); grid on;
```

**Plik do uruchomienia:** `przyklady/przyklad3.m`

**Komentarz do przykładu:**
- Kod realizuje superpozycję dwóch przebiegów harmonicznych o różnych częstotliwościach, amplitudach i fazach początkowych.
- Przykład uzupełnia teorię o fakt, że bardziej złożone sygnały można budować jako sumę prostszych składników.
- Zmień `f1` i `f2` na wartości bliższe sobie, aby obserwować wolniejsze obwiednie, albo ustaw `phi2 = 0`, aby porównać wpływ przesunięcia fazowego.
- Dodanie kolejnego składnika sinusoidalnego jest prostym krokiem do budowy sygnałów testowych wykorzystywanych w kolejnych laboratoriach.

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Zmień stosunek amplitud składowych (np. 1:1, 1:0.2, 1:0.05) i zaobserwuj, kiedy słabsza składowa przestaje być widoczna.
- Dobierz częstotliwości tak, by składowe tworzyły dudnienia (różnica 1–2 Hz) i zmierz okres obwiedni z wykresu.
- Dodaj trzecią składową i opisz własnymi słowami, którą cechę wykresu zmienia każda z trzech.

## 7. ZADANIA

W zadaniach można korzystać z fragmentów kodu z bieżącego laboratorium oraz z wcześniejszych zajęć. Jeżeli dana technika była już pokazana wcześniej, odwołaj się do niej zamiast niepotrzebnie powielać cały kod od zera.

### 7.1 Zasady oceny i swoboda pracy
- Za poprawne wykonanie wszystkich zadań **1–4** proponowana jest ocena **4.0**. W tym laboratorium nie ma jeszcze Zadania 5★ – ocenę 5.0 będzie można zdobywać od Laboratorium 2, gdzie zadanie dodatkowe łączy nowy temat z wcześniejszymi.
- Zadania **1–2** są takie same dla wszystkich (podstawy). Zadania **3–4** mają **parametry losowe**, więc każde sprawozdanie będzie inne – nie kopiuj wyników od innych osób.
- W zadaniach „swobodnych” sam wybierasz sygnały, metody, rozmiary i kryteria; **musisz** jednak uzasadnić swoje decyzje liczbami i wykresami.

### 7.2 Losowanie parametrów (wykonaj na początku skryptu)
Wpisz ostatnie 4 cyfry swojego numeru albumu do zmiennej `nr` – dzięki `rand('state', nr)` ten sam numer zawsze daje te same parametry (powtarzalność), a różne numery dają różne sprawozdania. **Wartości wylosowanych parametrów wypisz w sprawozdaniu.**

```octave
nr = 1234;                  % <- wpisz ostatnie 4 cyfry swojego numeru albumu
rand('state', nr); randn('state', nr);

A1 = randi([2 5]);          % amplituda skladowej 1
A2 = randi([1 3]) / 2;      % amplituda skladowej 2 (0.5, 1, 1.5)
f1 = randi([3 9]);          % czestotliwosc 1 [Hz]
f2 = f1 + randi([2 6]);     % czestotliwosc 2 [Hz]
phi = randi([0 7]) * pi/4;  % przesuniecie fazowe skladowej 2
fprintf('A1=%g A2=%g f1=%d f2=%d phi=%.2f rad\n', A1, A2, f1, f2, phi);
```

### 7.3 Zadania na ocenę 4.0

1. **Zadanie 1:** Wygeneruj sygnał sinusoidalny o amplitudzie `A = 2`, częstotliwości `f = 10 Hz` i czasie trwania `T = 2 s`. Narysuj wykres i opisz osie.

2. **Zadanie 2:** Zmodyfikuj Przykład 2 tak, aby wszystkie sygnały miały częstotliwość `f = 5 Hz` i amplitudę `A = 1.5`. Porównaj wykresy.

3. **Zadanie 3 (losowe):** Wygeneruj sygnał `x(t) = A1·sin(2π·f1·t) + A2·sin(2π·f2·t + φ)` z wylosowanymi parametrami (`T = 2 s`). Narysuj go razem z obiema składowymi (legenda!) i opisz, jak wylosowana faza `φ` oraz stosunek `A2/A1` zmieniają kształt sumy.

4. **Zadanie 4 (losowe, swoboda):** Zaprojektuj sygnał będący sumą co najmniej trzech składowych sinusoidalnych. Częstotliwości losuj poleceniem `f = sort(randperm(20, 3))`, amplitudy i fazy dobierz samodzielnie (ale tak, by każda składowa była widoczna). Wskaż, z którego przykładu korzystasz, i opisz wpływ każdej składowej na wynik.

---

## 8. 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab1_ImieNazwisko.pdf`

**WYMAGANA STRUKTURA SPRAWOZDANIA:**
1. **Strona tytułowa:** imię i nazwisko, temat laboratorium oraz data wykonania laboratorium.
2. **Parametry losowe:** wpisany numer `nr` oraz kod losowania wraz z wylosowanymi wartościami.
3. **Wnioski i spostrzeżenia z przykładów 1–3:** opisz, co realizuje każdy przykład, jakie parametry zostały zmienione (w tym wybrany eksperyment „Twoja kolej”) oraz jak te zmiany wpłynęły na wykresy lub wyniki.
4. **Rozwiązanie każdego zadania** — dla Zadania 1–4 przygotuj osobny podrozdział zawierający:
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
