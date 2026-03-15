# Lab 11: STFT + Transformata Falkowa (Wavelets)

## 1. Cel
Analiza sygnałów niestacjonarnych metodą Short-Time Fourier Transform (STFT) oraz transformaty falkowej. Wizualizacja spektrogramów i skalogreramów.

## 2. Teoria
Wiele rzeczywistych sygnałów jest niestacjonarnych, co oznacza, że ich własności częstotliwościowe zmieniają się w czasie. Klasyczna FFT opisuje jedynie globalny rozkład energii, dlatego do analizy lokalnej stosuje się narzędzia czasowo-częstotliwościowe, takie jak STFT i analiza falkowa.

### STFT
Krótkoczasowa transformata Fouriera polega na wyznaczaniu FFT w przesuwanym oknie czasowym. Rezultat prezentuje się zwykle w postaci spektrogramu. Rozmiar okna decyduje o kompromisie: krótkie okno daje dobrą rozdzielczość czasową, a długie — lepszą rozdzielczość częstotliwościową.

### Analiza falkowa
Fale (falki) realizują analizę wielorozdzielczą. Oznacza to, że sygnał rozkłada się na składowe opisujące trend (aproksymację) i szybkie zmiany (detale) na różnych skalach. W przeciwieństwie do STFT szerokość „okna” zmienia się wraz ze skalą, co jest korzystne dla sygnałów o zróżnicowanej strukturze.

### Interpretacja praktyczna
STFT jest wygodna do śledzenia zmian częstotliwości w czasie, natomiast fale dobrze wykrywają lokalne zdarzenia i skoki. W laboratorium warto porównywać oba podejścia i świadomie wiązać obserwowane efekty z rozmiarem okna lub poziomem dekompozycji.

## 3. Uruchomienie Octave
| Sposób | Instrukcja |
|--------|-----------|
| **Online** | [octave-online.net](https://octave-online.net) |
| **Windows** | Octave GUI → New Script |
| **Ubuntu** | `octave --gui` + `pkg install -forge signal` |

## 4. PRZYKŁAD 1: Spektrogram STFT sygnału chirp

```octave
% Lab 11 - Przyklad 1: Spektrogram STFT - sygnal chirp
fs  = 1000;
T   = 2;
t   = 0 : 1/fs : T-1/fs;

x = chirp(t, 10, T, 200);

window_len = 128;
overlap    = 120;
nfft       = 256;

figure;
subplot(2,1,1);
plot(t, x); title('Sygnal chirp'); xlabel('t [s]'); grid on;

subplot(2,1,2);
spectrogram(x, hann(window_len), overlap, nfft, fs, 'yaxis');
title('Spektrogram STFT'); colorbar;
```

**Plik do uruchomienia:** `przyklady/przyklad1.m`

**Komentarz do przykładu:**
- Kod wyznacza spektrogram sygnału typu chirp, czyli przebiegu o częstotliwości rosnącej w czasie.
- Na spektrogramie należy obserwować, jak energia przesuwa się ku wyższym częstotliwościom wraz z upływem czasu.
- Zmień zakres częstotliwości chirpu lub długość sygnału, aby ocenić, jak wpływa to na nachylenie ścieżki widmowej na spektrogramie.
- To podstawowy przykład pokazujący przewagę analizy czasowo-częstotliwościowej nad pojedynczą globalną FFT.

## 5. PRZYKŁAD 2: Wpływ rozmiaru okna na spektrogram

```octave
% Lab 11 - Przyklad 2: Wplyw rozmiaru okna na STFT
fs = 1000;
T  = 2;
t  = 0 : 1/fs : T-1/fs;

x = zeros(1, length(t));
x(t < 1)  = sin(2*pi*50*t(t < 1));
x(t >= 1) = sin(2*pi*200*t(t >= 1));

window_sizes = [32, 128, 512];
nfft = 1024;

figure;
for i = 1:3
    Nw = window_sizes(i);
    subplot(1,3,i);
    spectrogram(x, hann(Nw), round(Nw*0.75), nfft, fs, 'yaxis');
    title(sprintf('Okno N=%d', Nw));
    colorbar;
end
sgtitle('Wplyw dlugosci okna na spektrogram');
```

**Plik do uruchomienia:** `przyklady/przyklad2.m`

**Komentarz do przykładu:**
- Przykład bada wpływ rozmiaru okna na jakość spektrogramu, a więc bezpośrednio ilustruje kompromis czas–częstotliwość.
- Krótki sygnał w oknie daje dobrą lokalizację czasową, ale gorszą rozdzielczość częstotliwościową; długie okno działa odwrotnie.
- Zmień długości okien lub nakładanie segmentów, aby sprawdzić, jak zmienia się czytelność zdarzeń w czasie i separacja składowych w częstotliwości.
- W sprawozdaniu warto odwołać się do konkretnych fragmentów spektrogramu, gdzie kompromis jest najlepiej widoczny.

## 6. PRZYKŁAD 3: Trójpoziomowa dekompozycja Haar 1D

```octave
% Lab 11 - Przyklad 3: Dekompozycja Haar 1D
x = [zeros(1, 32), ones(1, 32), sin(2*pi*(0:63)/16)];
x = x(1:128);

a1 = (x(1:2:end) + x(2:2:end)) / sqrt(2);
d1 = (x(1:2:end) - x(2:2:end)) / sqrt(2);

a2 = (a1(1:2:end) + a1(2:2:end)) / sqrt(2);
d2 = (a1(1:2:end) - a1(2:2:end)) / sqrt(2);

a3 = (a2(1:2:end) + a2(2:2:end)) / sqrt(2);
d3 = (a2(1:2:end) - a2(2:2:end)) / sqrt(2);

figure;
subplot(4,1,1);
plot(x, 'k'); title('Sygnal oryginalny'); ylabel('Amp'); grid on;

subplot(4,1,2);
stem(a3, 'filled'); title('Aproksymacja po 3 poziomach'); ylabel('Amp'); grid on;

subplot(4,1,3);
stem(d3, 'filled'); title('Detale poziomu 3'); ylabel('Amp'); grid on;

subplot(4,1,4);
stem(d1, 'filled'); title('Detale poziomu 1'); xlabel('Indeks'); ylabel('Amp'); grid on;
```

**Plik do uruchomienia:** `przyklady/przyklad3.m`

**Komentarz do przykładu:**
- Kod wprowadza prostą dekompozycję falkową Haar i dzięki temu uzupełnia laboratorium o drugi z zapowiedzianych modeli analizy czasowo-skali.
- Aproksymacja opisuje wolne zmiany sygnału, natomiast detale akcentują szybkie przejścia i lokalne nieciągłości.
- Zmień kształt sygnału wejściowego, dodaj skok albo impuls i sprawdź, na którym poziomie detale reagują najsilniej.
- To przykład szczególnie przydatny do zrozumienia, dlaczego fale są wygodne w analizie sygnałów z nagłymi zmianami.

## 7. ZADANIA

W zadaniach można korzystać z fragmentów kodu z bieżącego laboratorium oraz z wcześniejszych zajęć. Jeżeli dana technika była już pokazana wcześniej, odwołaj się do niej zamiast niepotrzebnie powielać cały kod od zera.

1. **Zadanie 1:** Wygeneruj sygnał składający się z trzech fragmentów: 20 Hz (0–0.5 s), 80 Hz (0.5–1 s), 150 Hz (1–1.5 s). Narysuj spektrogram i zidentyfikuj momenty zmian częstotliwości.

2. **Zadanie 2:** Porównaj spektrogramy sygnału chirp z oknami: prostokątnym, Hanninga i Gaussowskim. Jak okno wpływa na rozdzielczość?

3. **Zadanie 3:** Zastosuj transformatę Haara (Haar wavelet) do dekompozycji sygnału na 3 poziomach. W Octave: użyj funkcji `dwt()` z pakietu `signal` lub zaimplementuj filtrację przez filtr dolnoprzepustowy i górnoprzepustowy.

4. **Zadanie 4:** Przygotuj sygnał, w którym częstotliwość lub amplituda zmienia się w czasie, i porównaj opis sygnału za pomocą spektrogramu STFT oraz współczynników falkowych. Wskaż, które narzędzie lepiej uwidacznia wybraną cechę sygnału.

---

## 8. 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab11_ImieNazwisko.pdf`

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
