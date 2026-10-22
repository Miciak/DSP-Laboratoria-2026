# Lab 3: Parametry sygnałów + Aliasing

## 1. Cel
Obliczanie i analiza podstawowych parametrów sygnałów dyskretnych: wartość średnia, wartość skuteczna (RMS), moc, energia. Demonstracja zjawiska aliasingu.

## 2. Teoria
Parametry sygnału opisują jego własności ilościowe i pozwalają porównywać przebiegi o różnych kształtach. W praktyce laboratoryjnej najczęściej wyznacza się wartość średnią, skuteczną, energię, moc oraz współczynnik szczytu.

### Podstawowe definicje
Dla sygnału dyskretnego `x[n]` o długości `N` stosujemy zależności:
- wartość średnia: `x_sr = (1/N) * sum x[n]`
- wartość skuteczna: `x_RMS = sqrt((1/N) * sum x[n]^2)`
- energia: `E = sum x[n]^2`
- moc średnia: `P = (1/N) * sum x[n]^2`
- współczynnik szczytu: `CF = x_max / x_RMS`

Parametry te mają konkretne znaczenie fizyczne. Wartość średnia mówi o składowej stałej, wartość RMS odpowiada „efektywnej” amplitudzie sygnału, a współczynnik szczytu informuje, czy przebieg ma łagodne, czy gwałtowne zmiany.

### Zależność od kształtu sygnału
Dwa sygnały o tej samej amplitudzie maksymalnej mogą mieć różne RMS, energię i moc. Z tego powodu w systemach pomiarowych i energetycznych nie wystarcza sama amplituda — potrzebne są dodatkowe miary opisujące rozkład wartości w czasie.

### Związek z aliasingiem
W tym laboratorium przypominamy również aliasing, ponieważ błędne próbkowanie wpływa nie tylko na wygląd przebiegu, ale także na interpretację jego parametrów i widma. Jeżeli częstotliwość jest odczytana niepoprawnie, wnioski o energii rozłożonej w pasmach również będą błędne.

## 3. Uruchomienie Octave
| Sposób | Instrukcja |
|--------|-----------|
| **Online** | [octave-online.net](https://octave-online.net) |
| **Windows** | Octave GUI → New Script |
| **Ubuntu** | `octave --gui` |

## 4. PRZYKŁAD 1: Obliczanie parametrów sygnału

```octave
% Lab 3 - Przyklad 1: Parametry sygnalu
fs = 1000;
T  = 1;
f  = 5;
t  = 0 : 1/fs : T-1/fs;
x  = 3 * sin(2*pi*f*t) + 0.5;   % sygnal ze skladowa stala

% Obliczenia
mean_x   = mean(x);
rms_x    = sqrt(mean(x.^2));
power_x  = mean(x.^2);
energy_x = sum(x.^2);
peak_x   = max(abs(x));
cf_x     = peak_x / rms_x;

fprintf('=== Parametry sygnalu ===\n');
fprintf('Wartosc srednia:      %.4f\n', mean_x);
fprintf('RMS:                  %.4f\n', rms_x);
fprintf('Moc srednia:          %.4f\n', power_x);
fprintf('Energia:              %.4f\n', energy_x);
fprintf('Wartosc szczytowa:    %.4f\n', peak_x);
fprintf('Wspolczynnik szczytu: %.4f\n', cf_x);

figure;
plot(t, x);
xlabel('Czas [s]'); ylabel('Amplituda');
title(sprintf('Sygnal: srednia=%.2f, RMS=%.2f', mean_x, rms_x));
grid on;
```

**Plik do uruchomienia:** `przyklady/przyklad1.m`

**Komentarz do przykładu:**
- Kod oblicza podstawowe parametry sygnału dla przebiegu sinusoidalnego ze składową stałą, co pozwala odróżnić wpływ części zmiennej i przesunięcia DC.
- Na wydruku tekstowym szczególnie ważne jest porównanie wartości średniej oraz RMS, ponieważ te wielkości reagują inaczej na obecność składowej stałej.
- Zmień offset sygnału lub amplitudę, aby sprawdzić, które parametry rosną proporcjonalnie, a które opisują wyłącznie część zmienną.
- To ćwiczenie jest bazą do świadomej interpretacji wyników filtracji i analizy energetycznej w kolejnych laboratoriach.

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Policz parametry (średnia, RMS, moc) **na papierze** dla własnego sygnału i dopiero potem sprawdź w Octave.
- Dodaj stałą składową `DC` do sygnału i zbadaj, które parametry się zmieniają, a które nie (zależność `RMS² = średnia² + wariancja`).
- Zmień `T` tak, by obejmowało niecałkowitą liczbę okresów i sprawdź, jak psuje to estymaty.

## 5. PRZYKŁAD 2: Demonstracja aliasingu w widmie

```octave
% Lab 3 - Przyklad 2: Aliasing - demonstracja
fs   = 40;
T    = 1;
t    = 0 : 1/fs : T-1/fs;

f_real  = 45;   % prawdziwa czestotliwosc
f_alias = 5;    % czestotliwosc aliasu (45 - 40 = 5)

x_real  = sin(2*pi*f_real*t);
x_alias = sin(2*pi*f_alias*t);

figure;
subplot(2,1,1);
stem(t, x_real, 'b');
hold on;
stem(t, x_alias, 'r--');
legend('f=45 Hz (oryg.)', 'f=5 Hz (alias)');
title('Aliasing: f=45 Hz probkowany z fs=40 Hz wyglada jak f=5 Hz');
xlabel('t [s]'); grid on;

N    = length(x_real);
freq = (0:N-1) * fs / N;
X_real  = abs(fft(x_real));
X_alias = abs(fft(x_alias));

subplot(2,1,2);
stem(freq(1:N/2), X_real(1:N/2), 'b'); hold on;
stem(freq(1:N/2), X_alias(1:N/2), 'r--');
legend('f=45 Hz', 'f=5 Hz');
title('Widmo FFT'); xlabel('Czestotliwosc [Hz]'); grid on;
```

**Plik do uruchomienia:** `przyklady/przyklad2.m`

**Komentarz do przykładu:**
- Przykład pokazuje aliasing już w dziedzinie częstotliwości, czyli na widmie FFT sygnału próbkowanego zbyt wolno.
- Dzięki temu można zestawić obserwację z poprzedniego laboratorium z bardziej formalnym narzędziem analizy, jakim jest widmo amplitudowe.
- Zmień częstotliwość próbkowania `fs` lub częstotliwość sygnału wejściowego, aby sprawdzić, jak przesuwa się pozycja maksimum widmowego.
- W sprawozdaniu warto wskazać różnicę między rzeczywistą częstotliwością sygnału a częstotliwością pozorną odczytaną z FFT.

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Dobierz własną częstotliwość sygnału i `fs` tak, aby alias wypadł w ustalonym przez Ciebie miejscu (np. dokładnie na 3 Hz), a następnie to zweryfikuj.
- Sprawdź, co się dzieje dla `f = fs` oraz `f = fs/2` – co widać w widmie?
- Spróbuj odgadnąć alias dla trzech losowo wybranych `f` zanim uruchomisz kod, i zapisz trafność swoich przewidywań.

## 6. PRZYKŁAD 3: Porównanie parametrów dla różnych kształtów sygnału

```octave
% Lab 3 - Przyklad 3: Parametry sygnalow o roznych ksztaltach
fs = 1000;
T  = 1;
f  = 5;
A  = 2;
t  = 0 : 1/fs : T-1/fs;

x_sin = A * sin(2*pi*f*t);
x_sq  = A * square(2*pi*f*t);
x_tri = A * sawtooth(2*pi*f*t, 0.5);

signals = {x_sin, x_sq, x_tri};
names   = {'Sinus', 'Prostokat', 'Trojkat'};

figure;
for i = 1:3
    x = signals{i};
    rms_val   = sqrt(mean(x.^2));
    crest_val = max(abs(x)) / rms_val;

    subplot(3,1,i);
    plot(t, x);
    title(sprintf('%s: RMS = %.3f, CF = %.3f', names{i}, rms_val, crest_val));
    xlabel('Czas [s]'); ylabel('Amp'); grid on;
end
```

**Plik do uruchomienia:** `przyklady/przyklad3.m`

**Komentarz do przykładu:**
- Kod porównuje trzy sygnały o tej samej amplitudzie maksymalnej, ale o różnych kształtach, a więc także różnych parametrach energetycznych.
- To dobry przykład uzupełniający teorię, ponieważ pokazuje, że wartość RMS i współczynnik szczytu zależą nie tylko od amplitudy, lecz także od geometrii przebiegu.
- Zmień amplitudę `A` lub częstotliwość `f`, a następnie sprawdź, które wielkości pozostają charakterystyczne dla danego kształtu sygnału.
- Warto porównać wyniki z wiedzą teoretyczną: sygnał prostokątny ma większą wartość RMS niż sinus o tej samej amplitudzie szczytowej.

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Dodaj czwarty przebieg (np. szum lub piłę) i uzupełnij tabelę parametrów.
- Zmień współczynnik wypełnienia prostokąta (20%, 50%, 80%) i obserwuj RMS oraz współczynnik szczytu.
- Zaproponuj własną miarę „obciążenia układu” i uzasadnij, czemu lepiej niż RMS opisuje wybrany przebieg.

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

A    = randi([2 6]);              % amplituda
DC   = randi([-10 10]) / 10;      % skladowa stala
f    = randi([5 20]);             % czestotliwosc [Hz]
duty = randi([20 80]);            % wypelnienie prostokata [%]
fs_a = randi([floor(f*0.8), f*2-1]);  % niedoprobkowanie do zadania z aliasem
fprintf('A=%g DC=%.1f f=%d duty=%d%% fs_a=%d\n', A, DC, f, duty, fs_a);
% --- do zadania 5* ---
b5 = randi([3 6]);                          % bity kwantyzacji
snr5 = randi([10 25]);                      % SNR szumu [dB]
```

### 7.3 Zadania na ocenę 4.0

1. **Zadanie 1:** Oblicz wszystkie parametry (średnia, RMS, moc, energia, CF) dla sygnału `x(t) = 2·cos(2π·10t)`. Porównaj z wartościami teoretycznymi (RMS sinusa = A/√2).

2. **Zadanie 2:** Zbadaj aliasing: sygnał `f = 35 Hz` próbkowany z `fs = 30 Hz`. Jaka będzie częstotliwość aliasu? Zweryfikuj to w Octave.

3. **Zadanie 3 (losowe):** Wygeneruj sygnał prostokątny o wylosowanych `A`, `f` i wypełnieniu `duty` oraz sinus o tej samej amplitudzie i składowej stałej `DC`. Oblicz średnią, RMS, moc, energię i współczynnik szczytu. Porównaj z wartościami teoretycznymi (dla prostokąta o wypełnieniu `d`: `RMS² = A²`, średnia `= A·(2d−1)`) i wyjaśnij różnice.

4. **Zadanie 4 (losowe, swoboda):** Sygnał `A·sin(2π·f·t)` z wylosowanymi parametrami próbkuj z `fs_a`. Przewidź teoretycznie częstotliwość aliasu, a następnie potwierdź ją w Octave na widmie FFT. Następnie wybierz **samodzielnie** drugi kształt przebiegu (trójkąt, piła lub własny) i porównaj jego parametry z sinusem i prostokątem w jednej tabeli; wskaż przebieg najbardziej obciążający układ pomiarowy.

### 7.4 Zadanie na ocenę 5.0

5. **Zadanie 5★ (na 5.0):** Weź sygnał z Laboratorium 1 (suma dwóch sinusów + składowa stała `DC`), spróbkuj go z `fs` z Laboratorium 2 i skwantyzuj do `b5` bitów. Dodaj szum gaussowski o SNR równym `snr5` dB. Oblicz średnią, RMS, moc i współczynnik szczytu: (a) sygnału czystego, (b) po kwantyzacji, (c) po dodaniu szumu. Zweryfikuj zależność `RMS² = średnia² + wariancja` i oszacuj, ile mocy pochodzi od kwantyzacji, a ile od szumu. Wyniki zestaw w tabeli i skomentuj.

*Zadanie 5★ jest dobrowolne i podnosi ocenę z 4.0 do 5.0 pod warunkiem poprawnego wykonania zadań 1–4.*

---

## 8. 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab3_ImieNazwisko.pdf`

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
