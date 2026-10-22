# Lab 5: DFT + FFT + Twierdzenie Parsevala

## 1. Cel
Obliczanie widma sygnałów za pomocą Dyskretnej Transformaty Fouriera (DFT) i algorytmu FFT. Weryfikacja twierdzenia Parsevala o zachowaniu energii.

## 2. Teoria
Dyskretna Transformata Fouriera (DFT) pozwala wyznaczyć reprezentację częstotliwościową skończonego ciągu próbek. Szybka implementacja tej operacji to FFT (Fast Fourier Transform), która oblicza te same współczynniki znacznie efektywniej numerycznie.

### Definicja DFT
Dla ciągu `x[n]`, `n = 0, ..., N-1`, transformata ma postać:

```
X[k] = sum(x[n] * exp(-j*2*pi*k*n/N)),   k = 0, ..., N-1
```

Współczynnik `X[k]` opisuje udział częstotliwości odpowiadającej numerowi koszyka `k`. Rozdzielczość widmowa jest równa `Delta f = fs / N`, zatem zależy jednocześnie od częstotliwości próbkowania i długości analizowanego sygnału.

### Przeciek widma i okna
Jeżeli sygnał nie zawiera całkowitej liczby okresów w analizowanym oknie, energia jednej składowej rozlewa się na sąsiednie koszyki. Zjawisko to nazywa się przeciekiem widma. Można je ograniczać przez stosowanie okien czasowych, np. Hann lub Hamming, kosztem pewnego poszerzenia głównego listka widma.

### Twierdzenie Parsevala
DFT zachowuje informację o energii sygnału. W odpowiednio znormalizowanej postaci energia w dziedzinie czasu jest równa energii w dziedzinie częstotliwości. W praktyce jest to ważny test poprawności obliczeń i interpretacji FFT.

## 3. Uruchomienie Octave
| Sposób | Instrukcja |
|--------|-----------|
| **Online** | [octave-online.net](https://octave-online.net) |
| **Windows** | Octave GUI → New Script |
| **Ubuntu** | `octave --gui` |

## 4. PRZYKŁAD 1: FFT sygnału i analiza widma

```octave
% Lab 5 - Przyklad 1: FFT - analiza widma sygnalu
fs = 1000;
T  = 1;
N  = fs * T;
t  = (0:N-1) / fs;

f1 = 50; f2 = 120; f3 = 200;
x  = sin(2*pi*f1*t) + 0.5*sin(2*pi*f2*t) + 0.3*sin(2*pi*f3*t);

X     = fft(x);
X_amp = abs(X) / N * 2;
freq  = (0 : N/2-1) * fs / N;

figure;
subplot(2,1,1);
plot(t, x);
xlabel('Czas [s]'); ylabel('Amplituda');
title('Sygnal w dziedzinie czasu'); grid on;

subplot(2,1,2);
plot(freq, X_amp(1:N/2));
xlabel('Czestotliwosc [Hz]'); ylabel('Amplituda');
title('Widmo amplitudowe (FFT)'); grid on;
```

**Plik do uruchomienia:** `przyklady/przyklad1.m`

**Komentarz do przykładu:**
- Kod wyznacza FFT dla sygnału wielotonowego, dzięki czemu można odczytać pozycje i względne amplitudy składowych sinusoidalnych.
- To podstawowy przykład łączący teorię DFT z praktyczną analizą widma sygnału dyskretnego.
- Zmień długość sygnału lub `fs`, aby sprawdzić wpływ rozdzielczości `Delta f = fs/N` na możliwość rozróżniania bliskich częstotliwości.
- Warto również zmienić amplitudy poszczególnych tonów i sprawdzić, jak odzwierciedla to wysokość pików widmowych.

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Zmień częstotliwość składowej na wartość niecałkowitą (np. `50.5 Hz`) i zaobserwuj przeciek widma; następnie dobierz `T` tak, by przeciek zniknął.
- Dopisz zero-padding (`fft(x, 4*N)`) i sprawdź, czy zwiększa rozdzielczość, czy tylko „interpoluje” widmo.
- Zmień `fs` i sprawdź, jak przesuwa się oś częstotliwości.

## 5. PRZYKŁAD 2: Twierdzenie Parsevala

```octave
% Lab 5 - Przyklad 2: Twierdzenie Parsevala
fs = 500;
T  = 0.5;
N  = fs * T;
t  = (0:N-1) / fs;
x  = 2*sin(2*pi*30*t) + cos(2*pi*70*t);

E_time = sum(x.^2);
X = fft(x);
E_freq = sum(abs(X).^2) / N;

fprintf('Energia w dziedzinie czasu:        %.4f\n', E_time);
fprintf('Energia w dziedzinie czest. (FFT): %.4f\n', E_freq);
fprintf('Roznica (powinna byc ~0):          %.2e\n', abs(E_time - E_freq));

freq2 = (-N/2 : N/2-1) * fs / N;
X_shifted = fftshift(X);

figure;
subplot(2,1,1);
plot(t, x); title('Sygnal'); xlabel('t [s]'); grid on;

subplot(2,1,2);
plot(freq2, abs(X_shifted));
title('Dwustronne widmo amplitudowe');
xlabel('Czestotliwosc [Hz]'); ylabel('|X[k]|'); grid on;
```

**Plik do uruchomienia:** `przyklady/przyklad2.m`

**Komentarz do przykładu:**
- Przykład realizuje numeryczną weryfikację twierdzenia Parsevala, czyli porównanie energii obliczonej w czasie i w częstotliwości.
- To ćwiczenie uczy poprawnej normalizacji FFT i pozwala kontrolować, czy wyniki widmowe są interpretowane bez błędów skali.
- Zmień sygnał wejściowy na sumę kilku sinusów albo na przebieg z szumem i sprawdź, czy równość energii nadal jest spełniona.
- Jeżeli wyniki przestają się zgadzać, zwykle oznacza to błąd w normalizacji lub nieuwzględnienie symetrii widma.

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Sprawdź Parseval dla własnego sygnału z szumem – ile wynosi różnica energii w obu dziedzinach?
- Zbadaj, czy twierdzenie Parsevala zachodzi po zastosowaniu okna (i jak wtedy należy skorygować energię).
- Policz energię tylko w wybranym paśmie widma i porównaj ją z energią całkowitą.

## 6. PRZYKŁAD 3: Wpływ okna czasowego na przeciek widma

```octave
% Lab 5 - Przyklad 3: Okna i przeciek widma
fs = 256;
N  = 256;
t  = (0:N-1) / fs;
f0 = 50.5;
x  = sin(2*pi*f0*t);

windows = {ones(1, N), hanning(N)', hamming(N)'};
names   = {'Prostokatne', 'Hann', 'Hamming'};
f       = (0:N-1) * fs / N;

figure;
for i = 1:3
    xw = x .* windows{i};
    X  = abs(fft(xw)) / N;

    subplot(3,1,i);
    plot(f(1:N/2), 20*log10(X(1:N/2) + eps));
    title(sprintf('Widmo po zastosowaniu okna: %s', names{i}));
    xlabel('Czestotliwosc [Hz]'); ylabel('Amplituda [dB]'); grid on;
end
```

**Plik do uruchomienia:** `przyklady/przyklad3.m`

**Komentarz do przykładu:**
- Kod demonstruje przeciek widma dla częstotliwości niebędącej całkowitą wielokrotnością rozdzielczości `fs/N`.
- Porównanie trzech okien pozwala zobaczyć kompromis między obniżeniem poziomu listków bocznych a poszerzeniem głównego piku.
- Zmień `f0` z `50.5 Hz` na `50 Hz`, aby sprawdzić przypadek zgodny z siatką częstotliwości, albo wydłuż `N`, aby poprawić rozdzielczość.
- To przykład bardzo praktyczny, ponieważ w rzeczywistych danych sygnał rzadko zawiera dokładnie całkowitą liczbę okresów w oknie analizy.

**🎲 Twoja kolej – swobodny eksperyment** (wybierz co najmniej jeden punkt, opisz w sprawozdaniu swój wybór i wynik):
- Dodaj do porównania okno Blackmana i oceń, jak zmienia się szerokość listka głównego oraz poziom listków bocznych.
- Dobierz dwie składowe o bardzo różnych amplitudach (1 i 0.001) i sprawdź, które okno pozwala zobaczyć słabszą.
- Zaproponuj własną regułę wyboru okna do zadania pomiarowego i uzasadnij ją wykresem.

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

fs  = 1000;
f1  = randi([40 120]) + 0.5 * randi([0 1]);   % czasem niecalkowita (przeciek)
f2  = f1 + randi([8 30]);                     % druga skladowa
ratio = 10^(-randi([2 4]));                   % amplituda slabszej skladowej: 1e-2..1e-4
fa  = randi([600 900]);                       % skladowa do zadania z aliasem (>fs/2)
Nfft = 2^randi([9 12]);                       % dlugosc FFT (512..4096)
fprintf('f1=%.1f f2=%.1f ratio=%g fa=%d Nfft=%d\n', f1, f2, ratio, fa, Nfft);
```

### 7.3 Zadania na ocenę 4.0

1. **Zadanie 1:** Wyznacz widmo FFT sygnału prostokątnego o częstotliwości 10 Hz i czasie trwania 1 s (fs = 1000 Hz). Porównaj z teoretycznym szeregiem Fouriera.

2. **Zadanie 2:** Sprawdź twierdzenie Parsevala dla sygnału `x(t) = 3·cos(2π·25t) + sin(2π·75t)`. Czy energie są równe?

3. **Zadanie 3 (losowe):** Dla sygnału `sin(2π·f1·t)` z wylosowanym `f1` (czasem niecałkowitym) porównaj widma dla okien: prostokątnego, Hanninga i Hamminga (`hann(N)`, `hamming(N)`). Zmierz szerokość listka głównego i poziom największego listka bocznego, a wyniki zestaw w tabeli.

4. **Zadanie 4 (losowe, swoboda):** Utwórz sygnał z dwóch składowych `f1`, `f2` o amplitudach `1` i `ratio`. Dobierz **samodzielnie** okno (spośród prostokątnego, Hanninga, Hamminga, Blackmana) i długość FFT `Nfft` tak, aby słabszą składową dało się odczytać z widma. Uzasadnij wybór pomiarami i sprawdź twierdzenie Parsevala po zastosowaniu okna.

### 7.4 Zadanie na ocenę 5.0

5. **Zadanie 5★ (na 5.0):** Zbuduj sygnał z trzech sinusoid (Laboratorium 1), z których jedna ma częstotliwość `fa` większą od `fs/2` (Laboratorium 2–3). Spróbkuj go z `fs = 1000 Hz`, **przewidź** teoretycznie położenie aliasu, a następnie wyznacz widmo FFT z oknem Hanninga i zero-paddingiem do `Nfft`. Odczytaj częstotliwości i amplitudy prążków (korzystając z funkcji `max`/`findpeaks` lub własnej detekcji maksimów), oblicz moc sygnału w dziedzinie czasu (Laboratorium 3) i widma (Parseval) oraz oszacuj, o ile okno zmieniło estymatę amplitudy. Zestaw przewidywania i wyniki w tabeli.

*Zadanie 5★ jest dobrowolne i podnosi ocenę z 4.0 do 5.0 pod warunkiem poprawnego wykonania zadań 1–4.*

---

## 8. 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab5_ImieNazwisko.pdf`

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
