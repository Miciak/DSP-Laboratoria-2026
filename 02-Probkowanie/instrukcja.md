# Lab 2: Próbkowanie + Twierdzenie Nyquista + Kwantyzacja

## 1. Cel
Zrozumienie procesu próbkowania sygnału ciągłego, twierdzenia Nyquista–Shannona oraz kwantyzacji amplitudy. Analiza efektów niedopróbkowania.

## 2. Teoria
Próbkowanie jest procesem przejścia od sygnału ciągłego `x(t)` do sekwencji próbek `x[n] = x(nT_s)`, gdzie `T_s = 1/fs` jest okresem próbkowania. W praktyce oznacza to, że rzeczywisty sygnał obserwujemy jedynie w dyskretnych chwilach czasu.

### Twierdzenie Nyquista–Shannona
Aby możliwa była poprawna rekonstrukcja sygnału ograniczonego pasmowo o maksymalnej częstotliwości `f_{max}`, należy spełnić warunek:

```
fs >= 2 * fmax
```

Wartość `2 * fmax` nazywamy częstotliwością Nyquista. Jeżeli warunek ten nie jest spełniony, składowe wysokoczęstotliwościowe „nakładają się” na niższe częstotliwości, co prowadzi do aliasingu. W analizie laboratoryjnej aliasing objawia się pozorną zmianą częstotliwości obserwowanego sygnału.

### Kwantyzacja amplitudy
Po próbkowaniu sygnał jest zwykle dodatkowo kwantyzowany, czyli odwzorowywany na skończoną liczbę poziomów amplitudy. Dla `b` bitów liczba poziomów wynosi `L = 2^b`. Im mniejsza liczba bitów, tym większy błąd kwantyzacji i bardziej „schodkowy” przebieg sygnału.

Przybliżony krok kwantyzacji można zapisać jako:

```
Delta = (xmax - xmin) / L
```

### Znaczenie praktyczne
Dobór `fs` i liczby bitów jest kompromisem między jakością reprezentacji sygnału a kosztem przechowywania danych. To zagadnienie będzie powracać w analizie widmowej, filtracji i kompresji, dlatego na tym etapie warto nauczyć się przewidywać skutki niedopróbkowania i zbyt małej rozdzielczości amplitudy.

## 3. Uruchomienie Octave
| Sposób | Instrukcja |
|--------|-----------|
| **Online** | [octave-online.net](https://octave-online.net) |
| **Windows** | Octave GUI → New Script |
| **Ubuntu** | `octave --gui` |

## 4. PRZYKŁAD 1: Próbkowanie sygnału sinusoidalnego

```octave
% Lab 2 - Przyklad 1: Probkowanie i twierdzenie Nyquista
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

**Plik do uruchomienia:** `przyklady/przyklad1.m`

**Komentarz do przykładu:**
- Kod porównuje reprezentację gęsto próbkowaną z dwiema sekwencjami próbek: zgodną z warunkiem Nyquista i naruszającą ten warunek.
- Najważniejszą obserwacją jest to, że przy `fs = 7 Hz` sygnał o rzeczywistej częstotliwości `5 Hz` zaczyna wyglądać jak sygnał o innej, pozornej częstotliwości.
- Zmień `f_sygnal` na `10 Hz` i sprawdź, jak muszą zmienić się wartości `fs_ok` i `fs_bad`, aby utrzymać lub złamać warunek Nyquista.
- Warto także wydłużyć czas `T`, ponieważ dłuższa obserwacja ułatwia zauważenie błędnej częstotliwości wynikającej z aliasingu.

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Zamiast `fs_bad = 7` wybierz własną wartość i **przewidź** pozorną częstotliwość ze wzoru `|f - k·fs|` zanim uruchomisz kod – potem sprawdź, czy miałeś rację.
- Zbadaj, co się dzieje dokładnie przy `fs = 2·f` (granica Nyquista) dla różnych faz sygnału – dlaczego wynik bywa mylący?
- Sprawdź wpływ `T` (0.5, 1, 3 s) na to, jak łatwo „zobaczyć” alias.

## 5. PRZYKŁAD 2: Kwantyzacja sygnału

```octave
% Lab 2 - Przyklad 2: Kwantyzacja sygnalu
fs = 1000;
T  = 0.5;
f  = 4;
t  = 0 : 1/fs : T-1/fs;
x  = sin(2*pi*f*t);

% Kwantyzacja 3-bitowa (8 poziomow)
bits = 3;
L    = 2^bits;
x_q3 = round(x * (L/2)) / (L/2);

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

**Plik do uruchomienia:** `przyklady/przyklad2.m`

**Komentarz do przykładu:**
- Przykład pokazuje, jak ten sam sygnał wygląda po kwantyzacji przy małej i dużej liczbie poziomów amplitudy.
- Kwantyzacja 3-bitowa daje wyraźnie schodkowy przebieg, natomiast 8 bitów znacznie lepiej odwzorowuje sygnał ciągły.
- Zmień `bits` na `2`, `4` i `6`, aby sprawdzić, jak maleje maksymalny błąd kwantyzacji wraz ze wzrostem rozdzielczości.
- Jeżeli zwiększysz amplitudę sygnału lub zmienisz zakres wartości, zwróć uwagę, że ten sam liczbowy krok kwantyzacji może generować inną względną jakość odwzorowania.

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Zdefiniuj własny sygnał (np. sumę dwóch sinusów albo piłę) i zmierz błąd kwantyzacji dla `bits = 2..8`; narysuj wykres `bits` vs. maksymalny błąd.
- Porównaj wynik z przybliżeniem teoretycznym `Delta/2` i skomentuj różnice.
- Zbadaj, co się dzieje, gdy sygnał ma amplitudę `0.1` zamiast `1` przy tych samych bitach – dlaczego jakość spada?

## 6. PRZYKŁAD 3: Próbkowanie sumy dwóch składowych i obserwacja aliasingu

```octave
% Lab 2 - Przyklad 3: Aliasowanie w sygnale wieloskladowym
f1 = 4;
f2 = 11;
T  = 1;

fs_ref = 1000;
t_ref  = 0 : 1/fs_ref : T-1/fs_ref;
x_ref  = sin(2*pi*f1*t_ref) + 0.7*sin(2*pi*f2*t_ref);

fs_list = [40, 24, 14];

figure;
subplot(4,1,1);
plot(t_ref, x_ref, 'k');
title('Sygnal referencyjny'); xlabel('Czas [s]'); ylabel('Amp'); grid on;

for i = 1:length(fs_list)
    fs = fs_list(i);
    t  = 0 : 1/fs : T-1/fs;
    x  = sin(2*pi*f1*t) + 0.7*sin(2*pi*f2*t);

    subplot(4,1,i+1);
    stem(t, x, 'filled');
    title(sprintf('Probkowanie sygnalu zlozonego, fs = %d Hz', fs));
    xlabel('Czas [s]'); ylabel('Amp'); grid on;
end
```

**Plik do uruchomienia:** `przyklady/przyklad3.m`

**Komentarz do przykładu:**
- Kod rozszerza analizę na sygnał wieloskładowy, w którym tylko jedna ze składowych może naruszać warunek Nyquista.
- Dzięki temu widać, że aliasing nie musi zniekształcać całego sygnału jednakowo — problem dotyczy tych składowych, których częstotliwość jest zbyt wysoka względem `fs`.
- Zmień `f2` na `8 Hz` albo zwiększ `fs_list` do wartości powyżej `22 Hz`, aby sprawdzić, kiedy wszystkie składowe są reprezentowane poprawnie.
- Przykład przygotowuje grunt pod dalszą analizę widmową, w której aliasing będzie obserwowany również w dziedzinie częstotliwości.

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Dobierz własne `f1`, `f2` i `fs_list` tak, aby jedna składowa była poprawnie próbkowana, a druga nie; udokumentuj to wykresem.
- Zamiast oceniać „na oko”, oblicz dla każdego `fs` częstotliwość pozorną obu składowych i zapisz ją w tabeli.
- Zaproponuj, jak zmienić `fs`, by minimalnym kosztem uniknąć aliasingu, i uzasadnij wybór.

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

f1  = randi([6 14]);                % skladowa 1 [Hz]
f2  = f1 + randi([3 9]);            % skladowa 2 [Hz]
fs_bad = randi([f2+2, 2*f2-1]);     % niedoprobkowanie: fs < 2*f2
bits = sort(randperm(7, 3) + 1);    % trzy rozne rozdzielczosci z zakresu 2..8 bitow
fprintf('f1=%d f2=%d fs_bad=%d bits=%s\n', f1, f2, fs_bad, mat2str(bits));
% --- do zadania 5* ---
b5 = randi([3 8]);                          % bity kwantyzacji
fs5 = round((1.1 + 1.9*rand()) * f2);       % fs z przedzialu [1.1, 3]*f_max (czesto < 2*f_max!)
```

### 7.3 Zadania na ocenę 4.0

1. **Zadanie 1:** Zbadaj próbkowanie sygnału `f = 10 Hz`. Sprawdź, co się dzieje przy `fs = 25 Hz`, `fs = 20 Hz` i `fs = 15 Hz`. Kiedy pojawia się aliasing?

2. **Zadanie 2:** Wykonaj kwantyzację sygnału trójkątnego (`sawtooth`) przy rozdzielczości 2, 4 i 8 bitów. Oblicz i porównaj błędy kwantyzacji.

3. **Zadanie 3 (losowe):** Dla sygnału `sin(2π·f1·t) + sin(2π·f2·t)` z wylosowanymi `f1`, `f2` wyznacz minimalną częstotliwość próbkowania spełniającą warunek Nyquista. Próbkuj sygnał z `fs` równym minimum, z `fs_bad` oraz z `1.5·fs_min` i porównaj wykresy. Dla `fs_bad` oblicz teoretycznie częstotliwości pozorne obu składowych i potwierdź je w Octave.

4. **Zadanie 4 (losowe, swoboda):** Wygeneruj własny sygnał z trzech składowych (częstotliwości z `sort(randperm(30, 3))`, amplitudy dobierz sam). Skwantyzuj go przy wylosowanych rozdzielczościach `bits` i dla każdej wylosowanej wartości oblicz błąd maksymalny oraz SNR kwantyzacji. Porównaj wyniki z regułą `SNR ≈ 6.02·b + 1.76 dB` (dla sinusa) i wyjaśnij odchylenia.

### 7.4 Zadanie na ocenę 5.0

5. **Zadanie 5★ (na 5.0):** Wykorzystaj sygnał złożony z Laboratorium 1 (suma sinusów z wylosowanymi amplitudami i fazami). Próbkuj go z wylosowaną częstotliwością `fs5` (przedział `[1.1·f_max, 3·f_max]`, `f_max = f2`) i kwantyzuj do `b5` bitów (oraz do innych wartości z 3–8 do porównania). Dla każdej pary (`fs`, `b`) z siatki wokół `fs5` i `b5` oblicz SNR i przepływność `fs·b` [bit/s]. Wyznacz **minimalną przepływność**, przy której SNR ≥ 30 dB, i sprawdź, czy któraś składowa uległa aliasingowi. Wynik przedstaw w tabeli i na wykresie, porównaj z przewidywaniem teoretycznym.

*Zadanie 5★ jest dobrowolne i podnosi ocenę z 4.0 do 5.0 pod warunkiem poprawnego wykonania zadań 1–4.*

---

## 8. 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab2_ImieNazwisko.pdf`

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
