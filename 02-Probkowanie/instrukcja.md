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

## 7. ZADANIA

W zadaniach można korzystać z fragmentów kodu z bieżącego laboratorium oraz z wcześniejszych zajęć. Jeżeli dana technika była już pokazana wcześniej, odwołaj się do niej zamiast niepotrzebnie powielać cały kod od zera.

1. **Zadanie 1:** Zbadaj próbkowanie sygnału `f = 10 Hz`. Sprawdź, co się dzieje przy `fs = 25 Hz`, `fs = 20 Hz` i `fs = 15 Hz`. Kiedy pojawia się aliasing?

2. **Zadanie 2:** Wykonaj kwantyzację sygnału trójkątnego (`sawtooth`) przy rozdzielczości 2, 4 i 8 bitów. Oblicz i porównaj błędy kwantyzacji.

3. **Zadanie 3:** Wyznacz minimalną częstotliwość próbkowania dla sygnału będącego sumą dwóch sinusów: `sin(2π·8t) + sin(2π·15t)`.

4. **Zadanie 4:** Dla własnego sygnału złożonego z co najmniej dwóch sinusoid wyznacz minimalną częstotliwość próbkowania zapewniającą brak aliasingu. Następnie wykonaj próbki przy wartości poprawnej i zbyt małej oraz porównaj wyniki na wykresach.

---

## 8. 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab2_ImieNazwisko.pdf`

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
