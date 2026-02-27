# Lab 1: Instalacja + Podstawy sygnałów

## 1. Cel
Zapoznanie się z środowiskiem GNU Octave oraz podstawowymi operacjami na sygnałach ciągłych i dyskretnych. Generowanie i wizualizacja podstawowych sygnałów (sinus, cosinus, sygnał prostokątny, piłokształtny).

## 2. Teoria
Sygnał to funkcja opisująca zmianę pewnej wielkości fizycznej w czasie. W DSP rozróżniamy:
- **Sygnały ciągłe** – zdefiniowane dla każdej chwili czasu `t ∈ ℝ`
- **Sygnały dyskretne** – zdefiniowane tylko w wybranych chwilach `n ∈ ℤ`

Podstawowe sygnały:
- Sinus: `x(t) = A·sin(2πft + φ)`
- Cosinus: `x(t) = A·cos(2πft + φ)`
- Sygnał prostokątny: `square(2πft)`
- Sygnał trójkątny/piłokształtny: `sawtooth(2πft)`

## 3. Uruchomienie Octave

| Sposób | Instrukcja |
|--------|-----------|
| **Online** | Wejdź na [octave-online.net](https://octave-online.net), wklej kod i naciśnij Run |
| **Windows** | Zainstaluj z [octave.org](https://octave.org/download), uruchom GUI lub terminal |
| **Ubuntu** | `sudo apt install octave` następnie `octave --gui` |

## 4. PRZYKŁAD 1: Generowanie i wykres sygnału sinusoidalnego

```octave
% Przyklad 1: Sygnal sinusoidalny
% Parametry
fs = 1000;          % czestotliwosc probkowania [Hz]
T  = 1;             % czas trwania sygnalu [s]
f  = 5;             % czestotliwosc sygnalu [Hz]
A  = 1;             % amplituda

t = 0 : 1/fs : T-1/fs;   % wektor czasu
x = A * sin(2*pi*f*t);    % sygnal sinusoidalny

figure;
plot(t, x);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Sygnal sinusoidalny f=5 Hz');
grid on;
```

**Uruchomienie:** Skopiuj kod do Octave Online lub zapisz jako `przyklad1.m` i uruchom.

## 5. PRZYKŁAD 2: Porównanie sygnałów podstawowych

```octave
% Przyklad 2: Porownanie roznych typow sygnalow
fs = 1000;
T  = 1;
f  = 3;
t  = 0 : 1/fs : T-1/fs;

x_sin  = sin(2*pi*f*t);
x_cos  = cos(2*pi*f*t);
x_sq   = square(2*pi*f*t);
x_saw  = sawtooth(2*pi*f*t);

figure;
subplot(2,2,1);
plot(t, x_sin); title('Sinus'); xlabel('t [s]'); grid on;

subplot(2,2,2);
plot(t, x_cos); title('Cosinus'); xlabel('t [s]'); grid on;

subplot(2,2,3);
plot(t, x_sq);  title('Prostokat'); xlabel('t [s]'); grid on;

subplot(2,2,4);
plot(t, x_saw); title('Piloksztaltny'); xlabel('t [s]'); grid on;
```

## 6. ZADANIA

1. **Zadanie 1:** Wygeneruj sygnał sinusoidalny o amplitudzie `A = 2`, częstotliwości `f = 10 Hz` i czasie trwania `T = 2 s`. Narysuj wykres i opisz osie.

2. **Zadanie 2:** Zmodyfikuj Przykład 2 tak, aby wszystkie sygnały miały częstotliwość `f = 5 Hz` i amplitudę `A = 1.5`. Porównaj wykresy.

3. **Zadanie 3:** Utwórz sygnał będący sumą dwóch sinusów: `x(t) = sin(2π·3t) + 0.5·sin(2π·7t)`. Narysuj wykres i opisz, co obserwujesz.

---

## 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab1_ImieNazwisko.pdf`

**ZAWARTOŚĆ:**
- Tytuł + Imię i Nazwisko
- [ZRZUT] Wykresy z Przykładu 1 i 2
- [ZRZUT] Wykresy z Zadań 1–3
- Wnioski (własnymi słowami): Co to jest sygnał? Jakie są różnice między sygnałami?
- Kod źródłowy wszystkich zadań
