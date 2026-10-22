# Lab 8: Charakterystyki filtrów FIR i IIR

## 1. Cel
Analiza i porównanie charakterystyk filtrów FIR (Finite Impulse Response) i IIR (Infinite Impulse Response): amplitudowych, fazowych i grupowych opóźnień.

## 2. Teoria
Charakterystyki filtrów opisują, w jaki sposób układ zmienia amplitudę i fazę poszczególnych składowych częstotliwościowych. W praktyce interesuje nas nie tylko to, które pasma są przepuszczane, ale także jak duże są zniekształcenia fazowe i opóźnienie sygnału.

### Filtry FIR i IIR
Filtry FIR (Finite Impulse Response) mają skończoną odpowiedź impulsową i mogą zapewniać dokładnie liniową fazę. Filtry IIR (Infinite Impulse Response) są zwykle bardziej ekonomiczne obliczeniowo, lecz ich faza jest z reguły nieliniowa, a stabilność zależy od położenia biegunów.

### Charakterystyki amplitudowe i fazowe
Charakterystyka amplitudowa pokazuje, które częstotliwości są wzmacniane lub tłumione. Charakterystyka fazowa oraz opóźnienie grupowe informują, czy różne składowe przechodzą przez układ z tym samym opóźnieniem. Dla sygnałów impulsowych i szerokopasmowych ma to istotne znaczenie jakościowe.

### Kompromisy projektowe
Wybór struktury filtru wiąże się z kompromisem między szerokością pasma przejściowego, tłumieniem w paśmie zaporowym, kosztem obliczeń i liniowością fazy. Porównanie kilku filtrów o podobnym zadaniu pozwala lepiej zrozumieć ten kompromis przed etapem projektowania własnych układów.

## 3. Uruchomienie Octave
| Sposób | Instrukcja |
|--------|-----------|
| **Online** | [octave-online.net](https://octave-online.net) |
| **Windows** | Octave GUI → New Script |
| **Ubuntu** | `octave --gui` |

## 4. PRZYKŁAD 1: Porównanie FIR i IIR – charakterystyki amplitudowe

```octave
% Lab 8 - Przyklad 1: Porownanie FIR vs IIR - charakterystyki amplitudowe
fs = 1000;
fc = 100;
Wn = fc / (fs/2);

N_fir = 40;
b_fir = fir1(N_fir, Wn, 'low', hamming(N_fir+1));
a_fir = 1;

[b_iir, a_iir] = butter(4, Wn, 'low');

[H_fir, w] = freqz(b_fir, a_fir, 1024, fs);
[H_iir, ~] = freqz(b_iir, a_iir, 1024, fs);

figure;
subplot(2,1,1);
plot(w, 20*log10(abs(H_fir)), 'b', 'LineWidth', 1.5); hold on;
plot(w, 20*log10(abs(H_iir)), 'r--', 'LineWidth', 1.5);
legend('FIR (N=40, Hamming)', 'IIR Butterworth (N=4)');
xlabel('Czestotliwosc [Hz]'); ylabel('|H| [dB]');
title('Charakterystyka amplitudowa'); grid on; ylim([-80 5]);

subplot(2,1,2);
plot(w, unwrap(angle(H_fir))*180/pi, 'b'); hold on;
plot(w, unwrap(angle(H_iir))*180/pi, 'r--');
legend('FIR', 'IIR');
xlabel('Czestotliwosc [Hz]'); ylabel('Faza [stopnie]');
title('Charakterystyka fazowa'); grid on;
```

**Plik do uruchomienia:** `przyklady/przyklad1.m`

**Komentarz do przykładu:**
- Przykład porównuje filtry FIR i IIR zaprojektowane do podobnego zadania tłumienia wysokich częstotliwości.
- Na charakterystyce amplitudowej należy zwrócić uwagę na stromość zbocza i głębokość tłumienia, ale nie wolno pomijać późniejszych konsekwencji fazowych.
- Zmień rząd filtrów, aby porównać, jak rośnie selektywność i koszt obliczeniowy obu rozwiązań.
- To ćwiczenie pokazuje, że podobna odpowiedź amplitudowa nie oznacza identycznego zachowania filtru w dziedzinie czasu.

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Zmień częstotliwość odcięcia i rząd filtra na własne wartości i zmierz szerokość pasma przejściowego (od −3 dB do −40 dB).
- Dorzuć filtr eliptyczny (`ellip`) i porównaj jego strome zbocze z Butterworthem kosztem zafalowań.
- Sprawdź, jak zmienia się charakterystyka fazowa przy zmianie rzędu filtra IIR.

## 5. PRZYKŁAD 2: Opóźnienie grupowe

```octave
% Lab 8 - Przyklad 2: Opoznienie grupowe FIR vs IIR
fs = 1000;
Wn = 0.2;

b_fir = fir1(30, Wn);
[b_iir, a_iir] = butter(5, Wn);

[gd_fir, w_fir] = grpdelay(b_fir, 1, 512, fs);
[gd_iir, w_iir] = grpdelay(b_iir, a_iir, 512, fs);

figure;
plot(w_fir, gd_fir, 'b', 'LineWidth', 1.5); hold on;
plot(w_iir, gd_iir, 'r--', 'LineWidth', 1.5);
legend('FIR (liniowa faza)', 'IIR Butterworth (nieliniowa faza)');
xlabel('Czestotliwosc [Hz]'); ylabel('Opoznienie grupowe [probki]');
title('Opoznienie grupowe FIR vs IIR'); grid on;
```

**Plik do uruchomienia:** `przyklady/przyklad2.m`

**Komentarz do przykładu:**
- Kod analizuje opóźnienie grupowe, czyli zależność opóźnienia od częstotliwości.
- Filtr FIR o liniowej fazie daje niemal stałe opóźnienie grupowe, podczas gdy filtr IIR wprowadza wyraźnie częstotliwościowo zależne przesunięcia.
- Zmień rząd filtru FIR lub IIR i sprawdź, jak wpływa to na płaskość opóźnienia oraz zniekształcenie przebiegów złożonych.
- Ta obserwacja jest ważna przy przetwarzaniu sygnałów, w których istotny jest kształt impulsów lub relacje fazowe między składowymi.

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Zmierz opóźnienie grupowe w paśmie przepustowym i sprawdź, czy jest zgodne z `(N−1)/2` dla FIR.
- Zbadaj opóźnienie grupowe filtra IIR – dla jakich częstotliwości jest największe? Dlaczego?
- Wypróbuj `filtfilt` i oceń, co dzieje się z opóźnieniem.

## 6. PRZYKŁAD 3: Wpływ doboru okna na charakterystykę filtru FIR

```octave
% Lab 8 - Przyklad 3: Rozne okna filtru FIR
fs = 1000;
fc = 120;
N  = 40;
wn = fc / (fs/2);

b_hamm = fir1(N, wn, 'low', hamming(N+1));
b_black = fir1(N, wn, 'low', blackman(N+1));
b_kais = fir1(N, wn, 'low', kaiser(N+1, 5));

[H1, w] = freqz(b_hamm, 1, 1024, fs);
H2 = freqz(b_black, 1, 1024, fs);
H3 = freqz(b_kais, 1, 1024, fs);

figure;
plot(w, 20*log10(abs(H1) + eps), 'b', 'LineWidth', 1); hold on;
plot(w, 20*log10(abs(H2) + eps), 'r', 'LineWidth', 1);
plot(w, 20*log10(abs(H3) + eps), 'k', 'LineWidth', 1);
title('Porownanie charakterystyk FIR dla roznych okien');
xlabel('Czestotliwosc [Hz]'); ylabel('Amplituda [dB]');
legend('Hamming', 'Blackman', 'Kaiser'); grid on;
```

**Plik do uruchomienia:** `przyklady/przyklad3.m`

**Komentarz do przykładu:**
- Kod projektuje trzy filtry FIR o tym samym rzędzie i tej samej częstotliwości odcięcia, ale z użyciem różnych okien.
- Dzięki temu można ocenić, jak dobór okna wpływa na szerokość pasma przejściowego i poziom listków bocznych w paśmie zaporowym.
- Zmień rząd `N` albo parametr okna Kaisera, aby sprawdzić, jak poprawia się tłumienie kosztem wydłużenia odpowiedzi impulsowej.
- Przykład dobrze przygotowuje do laboratorium projektowego, w którym dobór metody projektowania staje się świadomą decyzją inżynierską.

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Dodaj do porównania okno Blackmana lub Kaisera (`kaiser(N, beta)`) i sprawdź, jak `beta` zmienia kompromis między szerokością a tłumieniem.
- Zmień rząd filtra przy ustalonym oknie i zmierz zmianę tłumienia w paśmie zaporowym.
- Zaproponuj własną regułę doboru okna (jakie tłumienie, jaka szerokość) dla wybranego zadania.

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

fs = 1000;
fc = randi([8 30]) * 10;                      % czestotliwosc odciecia [Hz]
ord = 2 * randi([10 40]);                     % rzad FIR (parzysty)
ordIIR = randi([3 8]);                        % rzad IIR
okna = {'rectwin', 'hann', 'hamming', 'blackman'};
idx = randperm(4, 2);                         % dwa losowe okna
fprintf('fc=%d ord=%d ordIIR=%d okna: %s, %s\n', fc, ord, ordIIR, okna{idx(1)}, okna{idx(2)});
```

### 7.3 Zadania na ocenę 4.0

1. **Zadanie 1:** Zaprojektuj filtr FIR dolnoprzepustowy (rzędu 20, 40, 80) z częstotliwością odcięcia 200 Hz i fs = 1000 Hz. Porównaj strome zbocze charakterystyk.

2. **Zadanie 2:** Porównaj filtry IIR: Butterworth, Chebyshev I i Chebyshev II rzędu 4 i tej samej częstotliwości odcięcia. Użyj `cheby1()` i `cheby2()`.

3. **Zadanie 3 (losowe):** Zaprojektuj filtr IIR dolnoprzepustowy Butterworth rzędu `ordIIR` i FIR rzędu `ord` (okno Hamminga), oba z `fc`. Porównaj charakterystykę amplitudową i opóźnienie grupowe. Wyznacz tłumienie w odległości `fs/10` od `fc` i skomentuj, kiedy liniowa faza FIR uzasadnia jego większy rząd.

4. **Zadanie 4 (losowe, swoboda):** Dla `fc` zaprojektuj filtry FIR z dwoma wylosowanymi oknami (`okna{idx}`) przy rzędzie `ord`. Zmierz szerokość pasma przejściowego i tłumienie w paśmie zaporowym. Następnie wybierz **własne zastosowanie** (np. audio, ECG, pomiar) i sformułuj uzasadnione kryterium doboru okna.

### 7.4 Zadanie na ocenę 5.0

5. **Zadanie 5★ (na 5.0):** Zaprojektuj filtr dolnoprzepustowy FIR i IIR o tej samej częstotliwości odcięcia `fc` oraz tłumieniu ≥ 40 dB w odległości `0.2·fc`. Dla obu wyznacz najmniejszy rząd (wskazówka: `buttord`, `kaiserord`). Pokaż bieguny i zera obu (Laboratorium 7), przefiltruj sygnał złożony z dwóch sinusów (Laboratorium 1: jedna poniżej, jedna powyżej `fc`) metodą splotu (Laboratorium 6) i `filter`, a widma przed i po (FFT, Laboratorium 5) zestaw na jednym wykresie. Zmierz faktyczne tłumienie składowej zaporowej i porównaj koszty: rząd, opóźnienie, liczba mnożeń na próbkę.

*Zadanie 5★ jest dobrowolne i podnosi ocenę z 4.0 do 5.0 pod warunkiem poprawnego wykonania zadań 1–4.*

---

## 8. 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab8_ImieNazwisko.pdf`

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
