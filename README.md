# matlab

1. **function_crossing.m** - wizualizacja i obliczanie gdzie przecinają się dwie krzywe będące wykresami funkcji jednej zmiennej. Definiowanie funkcji anonimowych, rysowanie wykresów, użycie polecenia fzero, obsługa wyjątków i pętla for.
2. **resistor_mesh.m** - obliczanie oporu zastępczego sieci rezystorów metodą potencjałów węzłowych. Rozwiązywanie układu równań liniowych, macierze rzadkie, tworzenie macierzy element-po-elemencie za pomocą pętli for, użycie NaN, łączenie macierzy, usuwanie elementów powtarzających się, funkcja lokalna.
3. **fsapp.m** i **fsapp_start.m** - aproksymacja szeregiem Fouriera i wielomianem, tj. za pomocą funkcji y = p1 + p2 * x + p3 * x^2 + ... + a1 * sin(x) + a2 * sin(2x) + a3 * sin(3x) + ... + b1 * cos(x) + b2 * cos(2x) + b3 * cos(3x) + ... + bm * cos(mx). **fsapp_start.m** jest przykładowym skryptem jak można uruchamiać **fsapp.h**. Szczegółowy opis jest w pliku **Aproksymacja szeregiem Fouriera.pdf**.
