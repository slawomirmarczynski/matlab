% Aproksymacja i ekstrapolacja danych za pomocą szeregu Fouriera.
% Obliczenia wykonywane są przez funkcję fsapp, patrz plik fsapp.m.

% Czytanie danych z pliku tekstowego.

file_name = uigetfile("*.txt"); % pozyskanie nazwy pliku
data = load(file_name);  % załadowanie danych jako macierzy
x = data(:, 1);          % x to dane z pierwszej kolumny
y = data(:, 2);          % y to dane z drugiej kolumny

% Zakres wartości odciętych danych wejściowych bierzemy z samych danych.

in_low = min(x);    % dolny zakres danych wejściowych
in_high = max(x);   % górny zakres danych wejściowych
in_delta = in_high - in_low;

% Zakres wartości odciętych danych wyjściowych obliczamy:
% ma być o 20% poszerzony z lewej i o 120% rozszerzony w prawo.

out_low = in_low - 0.20 * in_delta;   % dolny zakres danych wyjściowych
out_high = in_high + 1.20 * in_delta; % górny zakres danych wyjściowych
out_N = 1000;   % liczba punktów w których ma być przeliczona aproksymacja

% Tworzymy wektor z wartościami które w których mają być obliczone
% wartości z aproksymacji.

xi = linspace(out_low, out_high, out_N);

% Jeżeli zamiast tego chcielibyśmy obliczyć wartości dla orginalnych
% odciętych to wystarczy zamiast xi = linspace(...) wstawić linię:
%
%   xi = x;

% Ustalamy rząd wielomianu, mp = 2 oznacza że będzie on liniowy (0 to brak,
% 1 to stała, 2 liniowy, 3 paraboliczny itd.). Wielomian ten będzie
% sumowany z szeregiem Fouriera, dzięki temu pozbędziemy się linowego (ew.
% innego) trendu, który mógłby wygenrować skoki wartości na krańcach
% przedziału dla jakiego liczymy szereg.

mp = 2;

% Zaczynamy obliczanie i rysowanie.
%
% Najpierw narysujemy pewną ilość krzywych dla różnych wartości parametrów,
% potem narysujemy orginalne dane, wreszcie jedną krzywą dla optymalnej (?)
% wartości parametrów. Taka kolejność powinna, poprzez tzw. z-order,
% utworzyć możliwie czytelny rysunek.

figure(1);  % okno do rysowania, wywołanie figure(1) uwidoczni gdy zakryte
clf;        % resetowanie wszystkich ustawień, wymazywanie zawartości
subplot(3, 1, [1, 2]); % Górny wykres
hold all;   % kolejne operacje nie będą niszczyły rzeczy już narysowanych

% Rysowanie lekko widocznych krzywych uzyskanych z różnorodnymi opcjami.

low_mh = 1;
high_mh = fix(length(x) / 4); 
for mh = low_mh : high_mh
    yi = fsapp(x, y, xi, mh, mp);  % obliczanie aproksymacji
    plot(xi, yi, 'cyan');          % rysowanie
end

% Rysowanie orginalnych danych wejściowych.

plot(x,y, 'red-o', 'MarkerSize', 5, 'MarkerFace', 'yellow', 'LineWidth', 2);

% Wybrana aproksymacja (jako pojedyncza linia)

mh = 10;
[yi, p, a, b] = fsapp(x, y, xi, mh, mp);  % obliczanie aproksymacji
plot(xi, yi, 'blue', 'LineWidth', 1.5);   % rysowanie

% Linia trendu nieokresowego

ypi = fsapp(x, y, xi, 0, mp);
plot(xi, ypi, 'k--');

% Dopracowanie szczegółów takich jak opis osi.

grid on;
grid minor;
xlabel 'x';
ylabel 'y';
title 'aproksymacja szeregiem fouriera';

subplot(3, 1, 3);  % dolny wykres
hold all;

y_poly = fsapp(x, y, x, 0, mp);
y_removed_poly = y - y_poly;
yi_removed_poly = fsapp(x, y_removed_poly, xi, mh, 0);

plot(x,y_removed_poly, 'red-o', 'MarkerSize', 5, 'MarkerFace', 'yellow', 'LineWidth', 2);
plot(xi, yi_removed_poly, 'blue', 'LineWidth', 1.5);

% Dopracowanie szczegółów takich jak opis osi.

grid on;
grid minor;
xlabel 'x';
ylabel 'y';
title 'usunięty trend nieokresowy';


% Wypisanie obliczonych parametrów.

fprintf('\n');
if mp > 0 && mh > 0
    disp('y = p1+p2*x+...+a1*sin(x)+b1*cos(x)+a2*sin(2*x)+b2*cos(2*x)+...')
elseif mp == 0 && mh > 0
    disp('y = a1*sin(x)+b1*cos(x)+a2*sin(2*x)+b2*cos(2*x)+...')
elseif mp > 0 && mh == 0
    disp('y = p1+p2*x+...')
else
    % Poważny błąd, ale lepiej jest użyć warning niż error
    % aby dać szansę skryptowi na ewentualne wypisanie parametrów.    
    warning 'nieprawidłowe wartości mp i mh';
end

fprintf('\n');
for m = 1:mp
    fprintf('p%02d = %20.15f\n', m, p(m));
end

fprintf('\n');
for m = 1:mh
    fprintf('a%02d = %20.015f \tb%02d = %20.015f\n', m, a(m), m, b(m));
end

% Dopisywanie wyników jako kolejnej jednej linii do pliku.
% Kolejno: mp, mh, wartości p, wartości a, wartości b.

fid = fopen('fsapp.output.txt','a');
fprintf(fid, '%d\t%d', mp, mh);
for m = 1:mp
    fprintf(fid, '\t%g', m, p(m));
end
for m = 1:mh
    fprintf(fid, '\t%g', a(m));
end
for m = 1:mh
    fprintf(fid, '\t%g', b(m));
end
fprintf(fid,'\n');
