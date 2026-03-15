# Lab 9: Projektowanie filtrów FIR i IIR

## 1. Cel
Praktyczne projektowanie filtrów cyfrowych FIR (metodą okien) i IIR (metodą bilinearną). Weryfikacja zaprojektowanych filtrów przez filtrację sygnałów testowych.

## 2. Teoria
Projektowanie filtrów polega na wyznaczeniu współczynników układu tak, aby spełniał zadane wymagania częstotliwościowe. Specyfikacja filtru obejmuje zwykle częstotliwości graniczne, dopuszczalne zafalowanie w paśmie przepustowym oraz wymagane tłumienie w paśmie zaporowym.

### Projektowanie filtrów FIR
W metodzie okien wyjściem jest idealna odpowiedź impulsowa, która następnie jest skracana i ważona odpowiednim oknem. Dobór okna wpływa na szerokość pasma przejściowego i poziom listków bocznych. Filtry FIR są szczególnie atrakcyjne, gdy zależy nam na liniowej fazie.

### Projektowanie filtrów IIR
Filtry IIR, np. Butterwortha, Czebyszewa lub eliptyczne, są wyprowadzane z analogowych prototypów i transformowane do postaci dyskretnej. Zwykle osiągają większą selektywność przy niższym rzędzie niż FIR, ale wprowadzają nieliniowość fazy i wymagają kontroli stabilności.

### Ocena projektu
Samo wyznaczenie współczynników nie kończy zadania. Należy jeszcze zweryfikować charakterystykę amplitudową, fazową oraz skuteczność filtracji sygnału testowego. W praktyce właśnie porównanie specyfikacji z uzyskanym wynikiem stanowi najważniejszy etap projektowania.

## 3. Uruchomienie Octave
| Sposób | Instrukcja |
|--------|-----------|
| **Online** | [octave-online.net](https://octave-online.net) |
| **Windows** | Octave GUI → New Script |
| **Ubuntu** | `octave --gui` |

## 4. PRZYKŁAD 1: Filtr FIR metodą okien

```octave
% Lab 9 - Przyklad 1: Projektowanie filtru FIR metoda okien
fs  = 1000;
fp  = 150;
fst = 200;
Wn  = (fp + fst) / 2 / (fs/2);

N = 50;
b_rect  = fir1(N, Wn, 'low');
b_hann  = fir1(N, Wn, 'low', hann(N+1));
b_hamm  = fir1(N, Wn, 'low', hamming(N+1));
b_black = fir1(N, Wn, 'low', blackman(N+1));

[H_rect,  w] = freqz(b_rect,  1, 1024, fs);
[H_hann,  ~] = freqz(b_hann,  1, 1024, fs);
[H_hamm,  ~] = freqz(b_hamm,  1, 1024, fs);
[H_black, ~] = freqz(b_black, 1, 1024, fs);

figure;
plot(w, 20*log10(abs(H_rect)),  'k',  'LineWidth', 1.2); hold on;
plot(w, 20*log10(abs(H_hann)),  'b',  'LineWidth', 1.2);
plot(w, 20*log10(abs(H_hamm)),  'r',  'LineWidth', 1.2);
plot(w, 20*log10(abs(H_black)), 'g',  'LineWidth', 1.2);
legend('Prostokatne', 'Hanninga', 'Hamminga', 'Blackmana');
xlabel('Czestotliwosc [Hz]'); ylabel('|H| [dB]');
title('Porownanie okien - filtr FIR (N=50)'); grid on; ylim([-100 5]);
```

**Plik do uruchomienia:** `przyklady/przyklad1.m`

**Komentarz do przykładu:**
- Kod porównuje kilka okien używanych w projektowaniu FIR, pokazując ich wpływ na charakterystykę amplitudową otrzymanego filtru.
- Dzięki temu można świadomie wybrać kompromis między stromym zboczem a tłumieniem w paśmie zaporowym.
- Zmień rząd filtru lub częstotliwość odcięcia, aby sprawdzić, kiedy poszczególne okna zaczynają dawać wyraźnie różne rezultaty.
- Przykład przygotowuje do samodzielnego projektowania filtrów według specyfikacji zadanej w postaci wymagań częstotliwościowych.

## 5. PRZYKŁAD 2: Filtr IIR Butterworth i filtracja

```octave
% Lab 9 - Przyklad 2: Filtr IIR Butterworth - projektowanie i filtracja
fs = 1000;
fc = 100;
N  = 4;

[b, a] = butter(N, fc/(fs/2), 'low');

[H, w] = freqz(b, a, 1024, fs);
figure;
subplot(2,1,1);
plot(w, 20*log10(abs(H)), 'b', 'LineWidth', 1.5);
title(sprintf('Butterworth LP, N=%d, fc=%d Hz', N, fc));
xlabel('Czestotliwosc [Hz]'); ylabel('|H| [dB]'); grid on; ylim([-80 5]);

t  = 0 : 1/fs : 1-1/fs;
x  = sin(2*pi*50*t) + sin(2*pi*300*t);
y  = filter(b, a, x);

subplot(2,1,2);
plot(t, x, 'b'); hold on; plot(t, y, 'r', 'LineWidth', 1.5);
legend('Wejscie (50+300 Hz)', 'Wyjscie (po filtracji)');
title('Filtracja sygnalem testowym'); xlabel('t [s]'); grid on;
```

**Plik do uruchomienia:** `przyklady/przyklad2.m`

**Komentarz do przykładu:**
- Przykład prezentuje pełny tok pracy z filtrem IIR Butterwortha: projekt, analiza i filtracja sygnału testowego.
- Wykresy pozwalają ocenić, czy wybrane pasmo przepustowe rzeczywiście pozostawia żądaną składową i tłumi zakłócenie.
- Zmień częstotliwość zakłócenia albo rząd filtru, aby sprawdzić, jak rośnie selektywność i jak zmienia się odpowiedź w czasie.
- To ćwiczenie warto porównać z projektowaniem FIR, aby wyciągnąć wnioski o ekonomii obliczeń i własnościach fazowych.

## 6. PRZYKŁAD 3: Projekt filtru pasmowoprzepustowego FIR

```octave
% Lab 9 - Przyklad 3: Filtr pasmowoprzepustowy FIR
fs = 1000;
t  = 0 : 1/fs : 1-1/fs;
x  = sin(2*pi*100*t) + 0.8*sin(2*pi*300*t) + 0.5*sin(2*pi*450*t);

N = 60;
Wn = [200 400] / (fs/2);
b = fir1(N, Wn, 'bandpass', kaiser(N+1, 5));
y = filter(b, 1, x);

[H, w] = freqz(b, 1, 1024, fs);

figure;
subplot(3,1,1);
plot(t, x);
title('Sygnal wejsciowy'); xlabel('Czas [s]'); ylabel('Amp'); grid on;

subplot(3,1,2);
plot(w, 20*log10(abs(H) + eps));
title('Charakterystyka amplitudowa filtru pasmowoprzepustowego');
xlabel('Czestotliwosc [Hz]'); ylabel('Amplituda [dB]'); grid on;

subplot(3,1,3);
plot(t, y);
title('Sygnal po filtracji'); xlabel('Czas [s]'); ylabel('Amp'); grid on;
```

**Plik do uruchomienia:** `przyklady/przyklad3.m`

**Komentarz do przykładu:**
- Kod rozszerza laboratorium o filtr pasmowoprzepustowy, a więc układ, który selekcjonuje całe pasmo częstotliwości zamiast jedynie częstotliwości niskich lub wysokich.
- Na charakterystyce należy sprawdzić, czy środkowa składowa sygnału wejściowego pozostaje po filtracji, a skrajne są tłumione.
- Zmień zakres `Wn`, aby przesunąć pasmo przepustowe, albo dodaj kolejną składową wejściową i oceń, czy zostanie przepuszczona.
- To przykład bardzo użyteczny praktycznie, ponieważ wiele rzeczywistych problemów wymaga wydzielenia konkretnego przedziału częstotliwości.

## 7. ZADANIA

W zadaniach można korzystać z fragmentów kodu z bieżącego laboratorium oraz z wcześniejszych zajęć. Jeżeli dana technika była już pokazana wcześniej, odwołaj się do niej zamiast niepotrzebnie powielać cały kod od zera.

1. **Zadanie 1:** Zaprojektuj filtr górnoprzepustowy FIR (okno Hamminga, N=40) o częstotliwości odcięcia 300 Hz i fs = 1000 Hz. Zweryfikuj go sygnałem 100 Hz + 500 Hz.

2. **Zadanie 2:** Zaprojektuj pasmowoprzepustowy filtr IIR Butterworth rzędu 4, pasmo 200–400 Hz, fs = 2000 Hz. Użyj `butter(4, [200 400]/(2000/2), 'bandpass')`.

3. **Zadanie 3:** Porównaj filtry Butterworth, Chebyshev I i Elliptic tego samego rzędu (N=4) dla tych samych specyfikacji. Użyj `cheby1()` i `ellip()`.

4. **Zadanie 4:** Zaprojektuj filtr pasmowoprzepustowy lub pasmowozaporowy dla własnej specyfikacji i zweryfikuj go na sygnale zawierającym co najmniej trzy składowe sinusoidalne. Uzasadnij dobór typu filtru i parametrów projektu.

---

## 8. 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab9_ImieNazwisko.pdf`

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
