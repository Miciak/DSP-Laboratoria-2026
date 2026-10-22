# Lab 7: Transformata Z + Stabilność systemów

## 1. Cel
Poznanie transformaty Z jako narzędzia analizy systemów dyskretnych. Wyznaczanie biegunów i zer, analiza stabilności oraz obliczanie odpowiedzi impulsowej.

## 2. Teoria
Transformata Z jest narzędziem służącym do analizy sygnałów i układów dyskretnych. Umożliwia opis układu za pomocą transmitancji, badanie jego stabilności oraz powiązanie położenia biegunów i zer z odpowiedzią częstotliwościową.

### Definicja
Dla sygnału dyskretnego `x[n]` transformata Z ma postać:

```
X(z) = sum(x[n] * z^(-n))
```

z odpowiednim obszarem zbieżności. W analizie układów najczęściej rozpatruje się funkcję przenoszenia `H(z) = Y(z)/X(z)`.

### Bieguny, zera i stabilność
Zera są miejscami, w których transmitancja przyjmuje wartość zero, a bieguny — miejscami, w których dąży do nieskończoności. Położenie biegunów względem okręgu jednostkowego jest szczególnie ważne: dla układów przyczynowych stabilność BIBO zachodzi wtedy, gdy wszystkie bieguny leżą wewnątrz okręgu jednostkowego.

### Związek z odpowiedzią częstotliwościową
Odpowiedź częstotliwościową otrzymuje się przez podstawienie `z = exp(j*omega)`, czyli przez analizę transmitancji na okręgu jednostkowym. Dzięki temu z jednego modelu można wyznaczać zarówno odpowiedź impulsową, jak i charakterystyki amplitudowo-fazowe.

## 3. Uruchomienie Octave
| Sposób | Instrukcja |
|--------|-----------|
| **Online** | [octave-online.net](https://octave-online.net) |
| **Windows** | Octave GUI → New Script |
| **Ubuntu** | `octave --gui` |

## 4. PRZYKŁAD 1: Bieguny, zera i stabilność

```octave
% Lab 7 - Przyklad 1: Bieguny i zera filtru - analiza stabilnosci
b = [0.2, 0.2, 0.2];
a = [1, -0.5, 0.1];

zeros_H = roots(b);
poles_H = roots(a);

fprintf('Zera H(z):\n'); disp(zeros_H);
fprintf('Bieguny H(z):\n'); disp(poles_H);
fprintf('|bieguny|: '); disp(abs(poles_H)');

if all(abs(poles_H) < 1)
    fprintf('System jest STABILNY\n');
else
    fprintf('System jest NIESTABILNY\n');
end

figure;
zplane(b, a);
title('Plan Z - bieguny i zera H(z)');
```

**Plik do uruchomienia:** `przyklady/przyklad1.m`

**Komentarz do przykładu:**
- Kod wyznacza bieguny i zera transmitancji oraz wykorzystuje ich położenie do oceny stabilności układu.
- Najważniejsza zasada, którą należy zapamiętać, dotyczy położenia biegunów względem okręgu jednostkowego.
- Zmień współczynniki wielomianów licznika i mianownika, aby sprawdzić, jak przesunięcie biegunu poza okrąg jednostkowy prowadzi do utraty stabilności.
- To ćwiczenie buduje intuicję potrzebną przy projektowaniu filtrów IIR w kolejnych laboratoriach.

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Zmień bieguny na własne (także zespolone sprzężone) i sprawdź stabilność, zanim narysujesz plan Z – zapisz swoją prognozę.
- Zbadaj, co się dzieje dla bieguna dokładnie na okręgu jednostkowym (`|p| = 1`).
- Dodaj zero na okręgu jednostkowym i zobacz, jak wpływa na charakterystykę amplitudową.

## 5. PRZYKŁAD 2: Odpowiedź impulsowa i charakterystyka częstotliwościowa

```octave
% Lab 7 - Przyklad 2: Odpowiedz impulsowa i charakterystyka czestotliwosciowa
b = [1, 0, -1];
a = [1, -0.9];

N   = 50;
imp = [1, zeros(1, N-1)];
h   = filter(b, a, imp);

[H, w] = freqz(b, a, 512);

figure;
subplot(3,1,1);
stem(0:N-1, h); title('Odpowiedz impulsowa h[n]'); xlabel('n'); grid on;

subplot(3,1,2);
plot(w/pi, abs(H));
xlabel('Czestotliwosc znormalizowana [\pi rad/probke]');
ylabel('|H|'); title('Charakterystyka amplitudowa'); grid on;

subplot(3,1,3);
plot(w/pi, angle(H)*180/pi);
xlabel('Czestotliwosc znormalizowana');
ylabel('Faza [stopnie]'); title('Charakterystyka fazowa'); grid on;
```

**Plik do uruchomienia:** `przyklady/przyklad2.m`

**Komentarz do przykładu:**
- Przykład łączy opis w dziedzinie `z` z odpowiedzią impulsową i odpowiedzią częstotliwościową tego samego układu.
- Dzięki temu można prześledzić, jak transmitancja wpływa zarówno na kształt odpowiedzi czasowej, jak i na selektywność częstotliwościową.
- Zmień współczynniki filtru lub długość odpowiedzi impulsowej, aby sprawdzić, jak szybko wygasa odpowiedź układu.
- W sprawozdaniu dobrze jest powiązać obserwowane cechy wykresów z położeniem biegunów i zer.

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Zmień współczynnik `a` w mianowniku i zmierz, po ilu próbkach odpowiedź impulsowa spada poniżej 1% (czas „ustalania”).
- Porównaj odpowiedź z `filter` i z wzorem analitycznym `h[n] = a^n`.
- Sprawdź, jak znak współczynnika wpływa na to, czy filtr jest dolno-, czy górnoprzepustowy.

## 6. PRZYKŁAD 3: Wpływ położenia biegunów na odpowiedź układu

```octave
% Lab 7 - Przyklad 3: Porownanie polozenia biegunow
r_values = [0.5, 0.8, 0.98];
theta    = pi/4;

figure;
for i = 1:length(r_values)
    r = r_values(i);
    b = 1;
    a = [1, -2*r*cos(theta), r^2];

    subplot(length(r_values), 2, 2*i-1);
    zplane(b, a);
    title(sprintf('Bieguny dla r = %.2f', r));

    [H, w] = freqz(b, a, 512);
    subplot(length(r_values), 2, 2*i);
    plot(w/pi, 20*log10(abs(H) + eps));
    title(sprintf('Charakterystyka amplitudowa dla r = %.2f', r));
    xlabel('Znormalizowana czestotliwosc'); ylabel('Amplituda [dB]'); grid on;
end
```

**Plik do uruchomienia:** `przyklady/przyklad3.m`

**Komentarz do przykładu:**
- Kod porównuje kilka układów o tych samych kątach biegunów, ale o różnych promieniach `r`, czyli różnej odległości od okręgu jednostkowego.
- Wraz ze wzrostem `r` charakterystyka staje się bardziej selektywna, ale układ jest jednocześnie bliższy granicy stabilności.
- Zmień `theta`, aby przesuwać częstotliwość rezonansową, albo ustaw `r` bardzo blisko `1`, aby zobaczyć silne podbicie widma.
- To przykład szczególnie ważny przed laboratoriów z filtrami IIR, gdzie dobór biegunów decyduje o własnościach filtru.

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Dobierz promień `r` tak, by szerokość rezonansu była dwa razy węższa niż w przykładzie.
- Zaprojektuj biegun odpowiadający dokładnie wybranej przez Ciebie częstotliwości `f_0` przy `fs = 1000 Hz` (`theta = 2π·f_0/fs`).
- Oceń, co się stanie z odpowiedzią impulsową, gdy `r` rośnie do `0.999`.

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

a1 = 0.5 + 0.45 * rand();           % wspolczynnik filtra 1. rzedu (0.5..0.95)
r  = 0.6 + 0.35 * rand();           % promien pary biegunow
theta = pi * (0.1 + 0.8*rand());    % kat biegunow [rad]
r2 = 0.4 + 0.5 * rand();            % promien drugiej pary
theta2 = pi * (0.1 + 0.8*rand());
z0 = exp(1j*pi*randi([1 7])/8);     % zero na okregu jednostkowym
fs = randi([8 16]) * 100;           % czestotliwosc probkowania [Hz]
fprintf('a1=%.3f r=%.3f theta=%.3f r2=%.3f theta2=%.3f fs=%d\n', a1, r, theta, r2, theta2, fs);
% --- do zadania 5* ---
f0_5 = (0.1 + 0.3*rand()) * fs;             % czestotliwosc rezonansu [Hz]
r5 = 0.9 + 0.09*rand();                     % promien biegunow
```

### 7.3 Zadania na ocenę 4.0

1. **Zadanie 1:** Zbadaj stabilność systemu z biegunami `p₁ = 0.8`, `p₂ = -0.6`. Narysuj plan Z. Teraz zmień `p₁ = 1.2` – co się dzieje z odpowiedzią impulsową?

2. **Zadanie 2:** Oblicz odpowiedź impulsową filtra o funkcji przenoszenia `H(z) = 1 / (1 - 0.7z⁻¹)`. Czy jest skończona czy nieskończona?

3. **Zadanie 3 (losowe):** Porównaj charakterystyki filtrów `b = [1 1]/2, a = 1` oraz `b = 1, a = [1 -a1]` z wylosowanym `a1`. Zbadaj biegun, stabilność i `h[n]`; oblicz czas, po którym odpowiedź impulsowa spada poniżej 1% i zweryfikuj go wzorem `n = ln(0.01)/ln(a1)`. Który filtr jest dolnoprzepustowy?

4. **Zadanie 4 (losowe, swoboda):** Zbuduj układ z zerem `z0` (i jego sprzężeniem) oraz dwiema parami biegunów (`r, theta` i `r2, theta2`). Wyznacz współczynniki `b`, `a` funkcją `poly`, narysuj plan Z (`zplane`) i charakterystykę amplitudową dla `fs`, odczytaj częstotliwości rezonansów w Hz i porównaj z `theta·fs/(2π)`. Następnie **samodzielnie** zmodyfikuj jeden promień tak, by układ był na granicy stabilności, i opisz skutek.

### 7.4 Zadanie na ocenę 5.0

5. **Zadanie 5★ (na 5.0):** Zaprojektuj rezonator IIR drugiego rzędu dla częstotliwości `f_0` = `f0_5` i promienia `r5`. Sprawdź jego stabilność (Laboratorium 7), wyznacz splot sygnału testowego (suma dwóch sinusów z Laboratorium 1, jedna na `f_0`) z odpowiedzią impulsową obciętą do 99% energii (Laboratorium 6) i porównaj z `filter`. Widmo wejścia i wyjścia pokaż FFT z oknem (Laboratorium 5) i oblicz wzmocnienie na `f_0` oraz szerokość pasma −3 dB; porównaj ją z oszacowaniem `≈ (1−r)·fs/π`. Zweryfikuj, że przy `fs` przekraczającym wartość graniczną wystąpiłby aliasing wejścia (Laboratorium 2).

*Zadanie 5★ jest dobrowolne i podnosi ocenę z 4.0 do 5.0 pod warunkiem poprawnego wykonania zadań 1–4.*

---

## 8. 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab7_ImieNazwisko.pdf`

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
