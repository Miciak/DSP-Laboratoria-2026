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

## 7. ZADANIA

W zadaniach można korzystać z fragmentów kodu z bieżącego laboratorium oraz z wcześniejszych zajęć. Jeżeli dana technika była już pokazana wcześniej, odwołaj się do niej zamiast niepotrzebnie powielać cały kod od zera.

1. **Zadanie 1:** Wykonaj splot sygnału `x = [1 2 3 2 1]` z odpowiedzią impulsową `h = [1 0 -1]`. Oblicz wynik ręcznie i zweryfikuj w Octave.

2. **Zadanie 2:** Zaszum sygnał sinusoidalny i zastosuj filtr uśredniający o różnych długościach (M = 5, 15, 30). Porównaj wyniki filtracji.

3. **Zadanie 3:** Zaimplementuj splot liniowy bez funkcji `conv()` – korzystając z pętli i definicji splotu. Porównaj z wynikiem funkcji `conv()`.

4. **Zadanie 4:** Zrealizuj splot tego samego sygnału z dwoma różnymi odpowiedziami impulsowymi i porównaj rezultaty. Wyjaśnij, jak zmiana odpowiedzi impulsowej wpływa na wygładzanie, opóźnienie lub wzmocnienie sygnału.

---

## 8. 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab6_ImieNazwisko.pdf`

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
