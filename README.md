# DSP-Laboratoria-2026
Ćwiczenia laboratoryjne z Cyfrowego Przetwarzania Sygnałów w środowisku GNU Octave.

> **Octave Online** – brak instalacji: [https://octave-online.net](https://octave-online.net)

---

## Harmonogram laboratoriów

| Lab | Katalog | Temat |
|-----|---------|-------|
| 1 | [01-Podstawy](01-Podstawy/instrukcja.md) | Instalacja + Podstawy sygnałów |
| 2 | [02-Probkowanie](02-Probkowanie/instrukcja.md) | Próbkowanie + Nyquist + kwantyzacja |
| 3 | [03-Parametry](03-Parametry/instrukcja.md) | Parametry sygnałów + aliasing |
| 4 | [04-Fouriera](04-Fouriera/instrukcja.md) | Szeregi Fouriera |
| 5 | [05-DFT-FFT](05-DFT-FFT/instrukcja.md) | DFT + FFT + Parseval |
| 6 | [06-Splot](06-Splot/instrukcja.md) | Splot liniowy + kołowy |
| 7 | [07-TransformataZ](07-TransformataZ/instrukcja.md) | Transformata Z + stabilność |
| 8 | [08-Filtry-char](08-Filtry-char/instrukcja.md) | Charakterystyki filtrów FIR/IIR |
| 9 | [09-Filtry-projekt](09-Filtry-projekt/instrukcja.md) | Projektowanie filtrów FIR/IIR |
| 10 | [10-Filtracja](10-Filtracja/instrukcja.md) | Filtracja 1D/2D + nieliniowe |
| 11 | [11-STFT-fale](11-STFT-fale/instrukcja.md) | STFT + fale |
| 12 | [12-Kompresja](12-Kompresja/instrukcja.md) | Kompresja + DCT |

Każda instrukcja zawiera obecnie **trzy przykłady** z komentarzem interpretacyjnym oraz **co najmniej cztery zadania** do samodzielnego wykonania.

---

## Struktura repozytorium

```
DSP-Laboratoria-2026/
├── README.md
├── 01-Podstawy/
│   ├── instrukcja.md
│   └── przyklady/
│       ├── przyklad1.m
│       ├── przyklad2.m
│       └── przyklad3.m
├── 02-Probkowanie/
│   ├── instrukcja.md
│   └── przyklady/
│       ├── przyklad1.m
│       ├── przyklad2.m
│       └── przyklad3.m
...
└── 12-Kompresja/
    ├── instrukcja.md
    └── przyklady/
        ├── przyklad1.m
        ├── przyklad2.m
        └── przyklad3.m
```

## Sprawozdania

Każde sprawozdanie należy oddać na **Microsoft Teams** jako jeden plik PDF:

```
Sprawozdanie_LabN_ImieNazwisko.pdf
```

Minimalna zawartość sprawozdania:
1. Strona tytułowa: imię i nazwisko, temat laboratorium, data wykonania.
2. Wnioski i spostrzeżenia z przykładów 1–3, w tym wpływ zmian parametrów na wykresy i wyniki.
3. Dla każdego zadania: koncepcja rozwiązania, kod, wyniki oraz wnioski.
4. Podsumowanie całego laboratorium.
5. Numerowane i podpisane wykresy oraz odwołania w tekście do wykresów i kodu.

---

## Uruchomienie Octave

| Sposób | Opis |
|--------|------|
| **Online** | [octave-online.net](https://octave-online.net) – brak instalacji |
| **Windows** | Pobierz instalator ze strony [octave.org](https://octave.org/download) |
| **Ubuntu/Linux** | `sudo apt install octave` |
| **macOS** | `brew install octave` |
