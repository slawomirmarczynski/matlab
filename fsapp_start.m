% Aproksymacja i ekstrapolacja danych za pomocą szeregu Fouriera

% Dane przykładowe są generowane z użyciem generatora liczb losowych
% do wytworzenia szumu symulującego niedokładności pomiarowe.

gen = @(x) sin(1.17 * x.^1.3) + 0.1*x.^2 + 0.1 * randn(size(x));

in_low = 0;     % dolny zakres danych wejściowych
in_high = 10;   % górny zakres danych wejściowych
in_N = 150;      % liczba danych wejściowych

out_low = -2;    % dolny zakres danych wyjściowych
out_high = 12; % górny zakres danych wyjściowych
out_N = 1000;   % liczba danych wyjściowych


x = linspace(in_low, in_high, in_N);  % wektor x równomiernie wypełniony
y = gen(x);                           % wektor y przeliczony z wektora x


figure(1);
clf;
hold all;
plot(x,y, 'or');

xi = linspace(out_low, out_high, out_N);

for m = 5:20
    yi = fsapp(x, y, xi, m, 2);
    plot(xi, yi, 'c-');
end

yi = fsapp(x, y, xi, 10, 2);
plot(xi, yi, '-b');

x_value = 2.7;
[y_value, p, a, b] = fsapp(x, y, x_value, 3, 2)
plot(x_value, y_value, '*g');


grid on;
grid minor;
xlabel 'x';
ylabel 'y';
title 'aproksymacja szeregiem fouriera';
