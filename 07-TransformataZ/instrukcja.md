# Lab 7: Transformata Z + Stabilność systemów

## 1. Cel
Poznanie transformaty Z jako narzędzia analizy systemów dyskretnych. Wyznaczanie biegunów i zer, analiza stabilności oraz obliczanie odpowiedzi impulsowej.

## 2. Teoria

### Transformata Z
Transformata Z sygnału `x[n]`:
```
X(z) = Σ x[n] · z^(-n)
```

### Funkcja przenoszenia H(z)
Dla systemu LTI opisanego równaniem różnicowym:
```
H(z) = B(z) / A(z) = (b₀ + b₁z⁻¹ + ... + bMz⁻M) / (1 + a₁z⁻¹ + ... + aNz⁻N)
```

### Stabilność
System jest **stabilny**, gdy wszystkie bieguny `H(z)` leżą **wewnątrz** okręgu jednostkowego `|z| < 1`.

### Zera i bieguny
- **Zera** – wartości z, dla których `H(z) = 0`
- **Bieguny** – wartości z, dla których `H(z) → ∞`

## 3. Uruchomienie Octave

| Sposób | Instrukcja |
|--------|-----------|
| **Online** | [octave-online.net](https://octave-online.net) |
| **Windows** | Octave GUI → New Script |
| **Ubuntu** | `octave --gui` |

## 4. PRZYKŁAD 1: Bieguny, zera i stabilność

```octave
% Przyklad 1: Bieguny i zera filtru - analiza stabilnosci
% Filtr dolnoprzepustowy IIR
b = [0.2, 0.2, 0.2];   % licznik
a = [1, -0.5, 0.1];    % mianownik

% Bieguny i zera
zeros_H = roots(b);   % zera (pierwiastki licznika)
poles_H = roots(a);   % bieguny (pierwiastki mianownika)

fprintf('Zera H(z):\n'); disp(zeros_H);
fprintf('Bieguny H(z):\n'); disp(poles_H);
fprintf('|bieguny|: '); disp(abs(poles_H)');

% Sprawdzenie stabilnosci
if all(abs(poles_H) < 1)
    fprintf('System jest STABILNY (wszystkie bieguny w okregu jednostkowym)\n');
else
    fprintf('System jest NIESTABILNY\n');
end

% Wykres biegunow i zer (plane Z)
figure;
zplane(b, a);
title('Plan Z - bieguny i zera H(z)');
```

## 5. PRZYKŁAD 2: Odpowiedź impulsowa i charakterystyka częstotliwościowa

```octave
% Przyklad 2: Odpowiedz impulsowa i charakterystyka czestotliwosciowa
b = [1, 0, -1];         % rozniczkujacy filtr
a = [1, -0.9];

% Odpowiedz impulsowa (impuls Diraca jako wejscie)
N   = 50;
imp = [1, zeros(1, N-1)];
h   = filter(b, a, imp);

% Charakterystyka czestotliwosciowa
[H, w] = freqz(b, a, 512);

figure;
subplot(3,1,1);
stem(0:N-1, h); title('Odpowiedz impulsowa h[n]'); xlabel('n'); grid on;

subplot(3,1,2);
plot(w/pi, abs(H));
xlabel('Czestotliwosc znormalizowana [\pi rad/probke]');
ylabel('|H(e^{jw})|'); title('Charakterystyka amplitudowa'); grid on;

subplot(3,1,3);
plot(w/pi, angle(H)*180/pi);
xlabel('Czestotliwosc znormalizowana');
ylabel('Faza [stopnie]'); title('Charakterystyka fazowa'); grid on;
```

## 6. ZADANIA

1. **Zadanie 1:** Zbadaj stabilność systemu z biegunami `p₁ = 0.8`, `p₂ = -0.6`. Narysuj plan Z. Teraz zmień `p₁ = 1.2` – co się dzieje z odpowiedzią impulsową?

2. **Zadanie 2:** Oblicz odpowiedź impulsową filtra o funkcji przenoszenia `H(z) = 1 / (1 - 0.7z⁻¹)`. Czy jest skończona czy nieskończona?

3. **Zadanie 3:** Porównaj charakterystyki częstotliwościowe filtrów: `b=[1,1]/2, a=1` oraz `b=1, a=[1,-0.9]`. Który jest dolnoprzepustowy?

---

## 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab7_ImieNazwisko.pdf`

**ZAWARTOŚĆ:**
- Tytuł + Imię i Nazwisko
- [ZRZUT] Wykresy z Przykładu 1 i 2
- [ZRZUT] Wykresy z Zadań 1–3
- Wnioski: Co decyduje o stabilności systemu? Czym różni się filtr FIR od IIR z perspektywy transformaty Z?
- Kod źródłowy wszystkich zadań
