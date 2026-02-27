# Lab 4: Szeregi Fouriera

## 1. Cel
Zrozumienie reprezentacji sygnałów okresowych w postaci szeregów Fouriera. Aproksymacja sygnałów prostokątnych i piłokształtnych skończoną liczbą harmonicznych.

## 2. Teoria

### Szereg Fouriera
Każdy sygnał okresowy `x(t)` o okresie `T₀` można przedstawić jako sumę sinusów i cosinusów:

```
x(t) = a₀/2 + Σ[aₙ·cos(nω₀t) + bₙ·sin(nω₀t)]
```

gdzie `ω₀ = 2π/T₀` – pulsacja podstawowa.

### Współczynniki Fouriera
```
a₀ = (2/T₀) · ∫ x(t) dt
aₙ = (2/T₀) · ∫ x(t)·cos(nω₀t) dt
bₙ = (2/T₀) · ∫ x(t)·sin(nω₀t) dt
```

### Sygnał prostokątny
Szereg Fouriera sygnału prostokątnego (tylko nieparzyste harmoniczne):
```
x(t) = (4/π) · Σ [sin((2k-1)ω₀t) / (2k-1)],  k = 1, 2, 3, ...
```

## 3. Uruchomienie Octave

| Sposób | Instrukcja |
|--------|-----------|
| **Online** | [octave-online.net](https://octave-online.net) |
| **Windows** | Octave GUI → New Script |
| **Ubuntu** | `octave --gui` |

## 4. PRZYKŁAD 1: Aproksymacja sygnału prostokątnego

```octave
% Przyklad 1: Szereg Fouriera - sygnal prostokatny
T0 = 1;                  % okres [s]
omega0 = 2*pi / T0;
t = 0 : 0.001 : 2*T0;   % wektor czasu

% Aproksymacja rozna liczba harmonicznych
N_list = [1, 3, 7, 21];
colors = {'b', 'r', 'g', 'm'};

figure;
for idx = 1:length(N_list)
    N = N_list(idx);
    x_approx = zeros(size(t));
    for k = 1 : N
        n = 2*k - 1;   % tylko nieparzyste harmoniczne
        x_approx = x_approx + (4/pi) * sin(n*omega0*t) / n;
    end
    subplot(2,2,idx);
    plot(t, x_approx, colors{idx});
    title(sprintf('N = %d harmonicznych', N));
    xlabel('t [s]'); ylabel('Amplituda'); grid on; ylim([-1.5 1.5]);
end
sgtitle('Aproksymacja sygnalu prostokatnego szeregiem Fouriera');
```

## 5. PRZYKŁAD 2: Widmo amplitudowe szeregu Fouriera

```octave
% Przyklad 2: Widmo szeregu Fouriera sygnalu piloksztaltnego
% x(t) = (2/pi) * sum( (-1)^(k+1) * sin(k*omega0*t) / k )
T0     = 1;
omega0 = 2*pi / T0;
t      = 0 : 0.001 : 3*T0;
N      = 15;            % liczba harmonicznych

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

## 6. ZADANIA

1. **Zadanie 1:** Zbadaj, jak liczba harmonicznych (N = 1, 5, 10, 50) wpływa na aproksymację sygnału prostokątnego. Oblicz błąd aproksymacji (norma różnicy) dla każdego N.

2. **Zadanie 2:** Zbuduj sygnał z pierwszych 10 harmonicznych sygnału trójkątnego. Szereg Fouriera sygnału trójkątnego: `x(t) = (8/π²)·Σ[(-1)^(k+1)·sin((2k-1)ω₀t)/(2k-1)²]`.

3. **Zadanie 3:** Narysuj widmo amplitudowe i fazowe dla sygnału będącego sumą: `x(t) = 2·sin(2πt) + sin(4πt) + 0.5·sin(6πt)`.

---

## 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab4_ImieNazwisko.pdf`

**ZAWARTOŚĆ:**
- Tytuł + Imię i Nazwisko
- [ZRZUT] Wykresy z Przykładu 1 i 2
- [ZRZUT] Wykresy z Zadań 1–3
- Wnioski: Co to jest zjawisko Gibbsa? Dlaczego sygnał prostokątny wymaga więcej harmonicznych niż trójkątny?
- Kod źródłowy wszystkich zadań
