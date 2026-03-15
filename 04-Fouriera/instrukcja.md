# Lab 4: Szeregi Fouriera

## 1. Cel
Zrozumienie reprezentacji sygnałów okresowych w postaci szeregów Fouriera. Aproksymacja sygnałów prostokątnych i piłokształtnych skończoną liczbą harmonicznych.

## 2. Teoria
Szereg Fouriera opisuje okresowy sygnał jako sumę składowej stałej oraz harmonicznych sinusoidalnych i cosinusoidalnych. Jest to jedno z podstawowych narzędzi analizy sygnałów, ponieważ pozwala przejść od opisu czasowego do opisu częstotliwościowego.

### Postać szeregu Fouriera
Dla sygnału okresowego o okresie `T0` zapis ogólny można przedstawić jako:

```
x(t) = a0/2 + sum(an * cos(n*w0*t) + bn * sin(n*w0*t))
```

gdzie `w0 = 2*pi/T0` jest pulsacją podstawową. Współczynniki `an` i `bn` zależą od symetrii sygnału. Jeżeli przebieg jest nieparzysty, część cosinusowa może zanikać, a jeżeli jest parzysty — część sinusowa.

### Znaczenie harmonicznych
Każda harmoniczna opisuje wkład jednej częstotliwości będącej wielokrotnością częstotliwości podstawowej. Im więcej składników zachowujemy, tym dokładniejsza jest aproksymacja sygnału. Dla przebiegów z nieciągłościami występuje zjawisko Gibbsa, czyli lokalne przeregulowanie w pobliżu skoku.

### Interpretacja praktyczna
Sygnały prostokątne, piłokształtne i trójkątne są klasycznymi przykładami, ponieważ ich szeregi Fouriera mają znane wzory współczynników. Dzięki temu można analizować nie tylko sam sygnał, ale również tempo zanikania harmonicznych i związek między gładkością przebiegu a szerokością widma.

## 3. Uruchomienie Octave
| Sposób | Instrukcja |
|--------|-----------|
| **Online** | [octave-online.net](https://octave-online.net) |
| **Windows** | Octave GUI → New Script |
| **Ubuntu** | `octave --gui` |

## 4. PRZYKŁAD 1: Aproksymacja sygnału prostokątnego

```octave
% Lab 4 - Przyklad 1: Szereg Fouriera - aproksymacja sygnalu prostokatnego
T0 = 1;                  % okres [s]
omega0 = 2*pi / T0;
t = 0 : 0.001 : 2*T0;

N_list = [1, 3, 7, 21];
colors = {'b', 'r', 'g', 'm'};

figure;
for idx = 1:length(N_list)
    N = N_list(idx);
    x_approx = zeros(size(t));
    for k = 1 : N
        n = 2*k - 1;
        x_approx = x_approx + (4/pi) * sin(n*omega0*t) / n;
    end
    subplot(2,2,idx);
    plot(t, x_approx, colors{idx});
    title(sprintf('N = %d harmonicznych', N));
    xlabel('t [s]'); ylabel('Amplituda'); grid on; ylim([-1.5 1.5]);
end
sgtitle('Aproksymacja sygnalu prostokatnego szeregiem Fouriera');
```

**Plik do uruchomienia:** `przyklady/przyklad1.m`

**Komentarz do przykładu:**
- Kod buduje przybliżenie sygnału prostokątnego przez sumowanie kolejnych harmonicznych nieparzystych.
- Najważniejsza obserwacja dotyczy poprawy jakości aproksymacji wraz ze wzrostem liczby harmonicznych oraz utrzymywania się przeregulowania przy skokach.
- Zmień liczbę harmonicznych `N`, aby sprawdzić, jak szybko poprawia się kształt sygnału i gdzie pozostaje zjawisko Gibbsa.
- Przykład pokazuje, że sygnał o ostrych krawędziach wymaga szerokiego widma, czyli wielu składowych częstotliwościowych.

## 5. PRZYKŁAD 2: Widmo amplitudowe szeregu Fouriera

```octave
% Lab 4 - Przyklad 2: Widmo szeregu Fouriera sygnalu piloksztaltnego
T0     = 1;
omega0 = 2*pi / T0;
t      = 0 : 0.001 : 3*T0;
N      = 15;

x_approx = zeros(size(t));
amps = zeros(1, N);

for k = 1:N
    ck = (-1)^(k+1) * (2/pi) / k;
    amps(k) = abs(ck);
    x_approx = x_approx + ck * sin(k*omega0*t);
end

figure;
subplot(2,1,1);
plot(t, x_approx); hold on;
plot(t, sawtooth(omega0*t), 'r--');
legend('Aproksymacja (N=15)', 'Oryginalny');
title('Sygnal piloksztaltny - aproksymacja Fouriera');
xlabel('t [s]'); grid on;

subplot(2,1,2);
stem(1:N, amps);
title('Widmo amplitudowe (wspolczynniki Fouriera)');
xlabel('Numer harmonicznej'); ylabel('|C_k|'); grid on;
```

**Plik do uruchomienia:** `przyklady/przyklad2.m`

**Komentarz do przykładu:**
- Przykład łączy syntezę sygnału piłokształtnego z analizą współczynników widmowych, co pozwala patrzeć jednocześnie na czas i częstotliwość.
- Tempo zaniku amplitud harmonicznych wyjaśnia, dlaczego jedne przebiegi są gładsze od innych i jak to wpływa na dokładność aproksymacji.
- Zmień liczbę harmonicznych albo zakres osi częstotliwości, aby lepiej zauważyć relację między współczynnikami a jakością rekonstrukcji.
- To ćwiczenie jest dobrym przygotowaniem do laboratoriów z FFT, gdzie podobne widma będą wyznaczane numerycznie z danych próbkowanych.

## 6. PRZYKŁAD 3: Aproksymacja sygnału trójkątnego szeregiem Fouriera

```octave
% Lab 4 - Przyklad 3: Aproksymacja sygnalu trojkatnego
fs = 2000;
T  = 1;
f0 = 2;
t  = 0 : 1/fs : T-1/fs;

x_ref = sawtooth(2*pi*f0*t, 0.5);
N_values = [1, 3, 9];

figure;
for idx = 1:length(N_values)
    N = N_values(idx);
    x = zeros(size(t));

    for k = 1:2:(2*N-1)
        coeff = (8/pi^2) * ((-1)^((k-1)/2)) / (k^2);
        x = x + coeff * sin(2*pi*k*f0*t);
    end

    subplot(length(N_values),1,idx);
    plot(t, x_ref, 'k', 'LineWidth', 1); hold on;
    plot(t, x, 'r--', 'LineWidth', 1);
    title(sprintf('Aproksymacja trojkata, N = %d harmonicznych nieparzystych', N));
    xlabel('Czas [s]'); ylabel('Amp'); grid on;
    legend('Oryginal', 'Aproksymacja');
end
```

**Plik do uruchomienia:** `przyklady/przyklad3.m`

**Komentarz do przykładu:**
- Kod pokazuje rozwinięcie sygnału trójkątnego, którego harmoniczne maleją szybciej niż dla prostokąta, bo proporcjonalnie do `1/k^2`.
- Dzięki temu można bezpośrednio porównać, jak gładkość sygnału wpływa na tempo zanikania widma i jakość przybliżenia przy małej liczbie składników.
- Zmień `N_values` albo częstotliwość podstawową `f0`, aby sprawdzić, jak zmienia się dokładność aproksymacji i zagęszczenie okresów na wykresie.
- W sprawozdaniu warto zestawić ten przykład z przebiegiem prostokątnym i wyjaśnić, dlaczego trojkąt wymaga mniejszej energii w wysokich harmonicznych.

## 7. ZADANIA

W zadaniach można korzystać z fragmentów kodu z bieżącego laboratorium oraz z wcześniejszych zajęć. Jeżeli dana technika była już pokazana wcześniej, odwołaj się do niej zamiast niepotrzebnie powielać cały kod od zera.

1. **Zadanie 1:** Zbadaj, jak liczba harmonicznych (N = 1, 5, 10, 50) wpływa na aproksymację sygnału prostokątnego. Oblicz błąd aproksymacji (norma różnicy) dla każdego N.

2. **Zadanie 2:** Zbuduj sygnał z pierwszych 10 harmonicznych sygnału trójkątnego. Szereg Fouriera sygnału trójkątnego: `x(t) = (8/π²)·Σ[(-1)^(k+1)·sin((2k-1)ω₀t)/(2k-1)²]`.

3. **Zadanie 3:** Narysuj widmo amplitudowe i fazowe dla sygnału będącego sumą: `x(t) = 2·sin(2πt) + sin(4πt) + 0.5·sin(6πt)`.

4. **Zadanie 4:** Porównaj aproksymację sygnału prostokątnego i trójkątnego dla tej samej liczby harmonicznych. Opisz, który przebieg jest rekonstruowany dokładniej i powiąż obserwację z tempem zaniku współczynników Fouriera.

---

## 8. 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab4_ImieNazwisko.pdf`

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
