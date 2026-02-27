# Lab 8: Charakterystyki filtrów FIR i IIR

## 1. Cel
Analiza i porównanie charakterystyk filtrów FIR (Finite Impulse Response) i IIR (Infinite Impulse Response): amplitudowych, fazowych i grupowych opóźnień.

## 2. Teoria

### Filtr FIR
- Skończona odpowiedź impulsowa
- Zawsze stabilny (brak biegunów poza zerem)
- Może mieć **liniową fazę** → stałe opóźnienie grupowe
- Wymaga więcej współczynników niż IIR

### Filtr IIR
- Nieskończona odpowiedź impulsowa (sprzężenie zwrotne)
- Może być niestabilny (bieguny muszą być wewnątrz okręgu)
- Nieliniowa faza
- Efektywniejszy (mniej współczynników)

### Parametry charakterystyki
| Parametr | Opis |
|----------|------|
| Pasmo przepustowe | Zakres freq, które filtr przepuszcza |
| Pasmo zaporowe | Zakres freq, które filtr tłumi |
| Częstotliwość odcięcia | Granica -3 dB |
| Tłumienie w pasmie zaporowym | Decybele |
| Opóźnienie grupowe | `-d(∠H)/dω` |

## 3. Uruchomienie Octave

| Sposób | Instrukcja |
|--------|-----------|
| **Online** | [octave-online.net](https://octave-online.net) |
| **Windows** | Octave GUI → New Script |
| **Ubuntu** | `octave --gui` |

## 4. PRZYKŁAD 1: Porównanie FIR i IIR – charakterystyki amplitudowe

```octave
% Przyklad 1: Porownanie FIR vs IIR
fs = 1000;
fc = 100;               % czestotliwosc odciecia [Hz]
Wn = fc / (fs/2);       % czestotliwosc znormalizowana

% Filtr FIR (okno Hamminga, rzad 40)
N_fir = 40;
b_fir = fir1(N_fir, Wn, 'low', hamming(N_fir+1));
a_fir = 1;

% Filtr IIR Butterworth (rzad 4)
[b_iir, a_iir] = butter(4, Wn, 'low');

% Charakterystyki czestotliwosciowe
[H_fir, w] = freqz(b_fir, a_fir, 1024, fs);
[H_iir, ~] = freqz(b_iir, a_iir, 1024, fs);

figure;
subplot(2,1,1);
plot(w, 20*log10(abs(H_fir)), 'b', 'LineWidth', 1.5); hold on;
plot(w, 20*log10(abs(H_iir)), 'r--', 'LineWidth', 1.5);
legend('FIR (N=40, Hamming)', 'IIR Butterworth (N=4)');
xlabel('Czestotliwosc [Hz]'); ylabel('|H| [dB]');
title('Charakterystyka amplitudowa'); grid on; ylim([-80 5]);
xline(fc, 'k--', 'f_c');

subplot(2,1,2);
plot(w, unwrap(angle(H_fir))*180/pi, 'b'); hold on;
plot(w, unwrap(angle(H_iir))*180/pi, 'r--');
legend('FIR', 'IIR');
xlabel('Czestotliwosc [Hz]'); ylabel('Faza [stopnie]');
title('Charakterystyka fazowa'); grid on;
```

## 5. PRZYKŁAD 2: Opóźnienie grupowe

```octave
% Przyklad 2: Opoznienie grupowe FIR vs IIR
fs = 1000;
Wn = 0.2;

b_fir = fir1(30, Wn);
[b_iir, a_iir] = butter(5, Wn);

% Opoznienie grupowe (grpdelay)
[gd_fir, w_fir] = grpdelay(b_fir, 1, 512, fs);
[gd_iir, w_iir] = grpdelay(b_iir, a_iir, 512, fs);

figure;
plot(w_fir, gd_fir, 'b', 'LineWidth', 1.5); hold on;
plot(w_iir, gd_iir, 'r--', 'LineWidth', 1.5);
legend('FIR (liniowa faza)', 'IIR Butterworth (nieliniowa faza)');
xlabel('Czestotliwosc [Hz]'); ylabel('Opoznienie grupowe [probki]');
title('Opoznienie grupowe FIR vs IIR'); grid on;
```

## 6. ZADANIA

1. **Zadanie 1:** Zaprojektuj filtr FIR dolnoprzepustowy (rzędu 20, 40, 80) z częstotliwością odcięcia 200 Hz i fs = 1000 Hz. Porównaj strome zbocze charakterystyk.

2. **Zadanie 2:** Porównaj filtry IIR: Butterworth, Chebyshev I i Chebyshev II rzędu 4 i tej samej częstotliwości odcięcia. Użyj `cheby1()` i `cheby2()`.

3. **Zadanie 3:** Zbadaj opóźnienie grupowe filtra FIR z oknem prostokątnym i oknem Blackmana. Jak okno wpływa na liniowość fazy?

---

## 🔔 SPRAWOZDANIE NA TEAMS

**PLIK:** `Sprawozdanie_Lab8_ImieNazwisko.pdf`

**ZAWARTOŚĆ:**
- Tytuł + Imię i Nazwisko
- [ZRZUT] Wykresy z Przykładu 1 i 2
- [ZRZUT] Wykresy z Zadań 1–3
- Wnioski: Kiedy wybrać FIR, kiedy IIR? Jakie są kompromisy między liniowością fazy a efektywnością obliczeniową?
- Kod źródłowy wszystkich zadań
