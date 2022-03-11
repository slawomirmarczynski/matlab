% Problem:
%
%   Mamy dwie funkcje, f(x) i g(x). Chcemy znaleźć wszystkie takie wartości
%   x, takie że a < x < b, dla których f(x) == g(x), czyli wszystkie 
%   te miejsca w których wykres funkcji y = f(x) przecina się z wykresem
%   funkcji y = g(x).
%
%   Chcemy mieć ładne rysunki, chcemy też mieć dokładne (z dokładnością do
%   kilkunastu miejsc po przecinku) wyniki. 
% 
%   Zakładamy że funkcje f(x) i g(x) są niemal wszędzie ciągłe i nie są
%   szczególnie trudne do narysowania/obliczeń.
%
% Rozwiązanie:
%
%   Skrypt poniżej to przykładowe rozwiązanie, można oczywiście spróbować
%   zrobić to zupełnie inaczej. Pokazuje jak można zdefiniować funkcje,
%   jak wykreślić krzywe na podstawie obliczonych wartości, jak użyć fzero
%   tak aby znaleźć nie jedno, ale wszystkie rozwiązania. I jak pokazać
%   rozwiązania na wykresie i w postaci liczbowej.

% Funkcje mogą być definiowane w odrębnych plikach lub jako funkcje
% lokalne, ale najłatwiej użyć (tak jak poniżej) funkcji anonimowych
% przypisanych do zmiennych. Oczywiście możemy używać różnych stałych,
% parametrów itp.

beta = 0.4;
f = @(x) exp(-beta * x) .* sin(2 * pi * x.^1.31);
g = @(x) exp(-beta * x) .* cos(2 * pi * x);


% Wykresy i ogólnie obliczenia będziemy prowadzili w przedziale od a do b.
% Zakładamy że N = 1000 punktów wystarczy aby dobrze odwzorować przebieg
% krzywych. W razie potrzeby możemy zwiększyć N.

a = 0;
b = 5;
N = 1000;
x = linspace(a, b, N);

% Tworzymy okno na wykres, wymazujemy ewentualne pozostałości poprzednich
% rysunków i ustawień. Wykreślamy dwie funkcje dwoma instrukcjami plot,
% używamy do tego hold all przez co kolejne wykresy są dorysowywane 
% do już istniejących.

figure(1);
clf;
hold all;

% Rysowanie wykresów jako takich. Dodatkowe parametry określają kolor
% i grubość linii.

plot(x, f(x), 'Color', 'blue', 'LineWidth', 1);
plot(x, g(x), 'Color', 'green', 'LineWidth', 1);

grid on;
grid minor;
title 'Przecinające sie krzywe y = f(x) oraz y = g(x)'
xlabel 'x';
ylabel 'y';

% To że po wykonaniu instrukcji plot powyżej my widzimy miejsca przecięcia
% nie oznacza jeszcze że Matlab wie gdzie linie się przecinają.
%
% Użyjemy fzero, ale nie do całego przedziału od a do b, lecz do każdego
% z N-1 podprzedziałów jakie są utworzone kolejnymi wartościami x(1), x(2)
% itd. aż do x(N-1), x(N). Nawet jeżeli jest kilka (kilkadziesiąt) tysięcy
% to Matlab i tak błyskawicznie przeprowadzi obliczenia. 
% 
% Musimy tylko upewnić się (do tego służy try-except-end) że jeżeli w danym
% podprzedziale fzero nie będzie mogło znaleźć przecięcia, to obliczenia
% nie powinny być przerywane.

delta = @(x) f(x) - g(x);
vec_z = [];  % wektor, do którego będą dopisywane wyniki

for i = 2:length(x)
    try
        z = fzero(delta, [x(i-1), x(i)]);
        vec_z = [vec_z; z];
        plot(z, f(z), 'or');
    catch
    end
end

% Na wszelki wypadek usuwamy zwielokrotnione wpisy w vec_z i wypisujemy
% jego zawartość oraz odpowiednie wartości jakie przyjmują funkcje.

vec_z = unique(vec_z);

% Sposób w jaki wypisane są wyniki poniżej nie jest szczególnie piękny,
% ale działa i to powinno wystarczyć. Format long zagwarantuje że zobaczymy
% dokładne wyniki.

format long
disp('punkty przecięcia:  x  f(x)');
disp([vec_z, f(vec_z)]);
