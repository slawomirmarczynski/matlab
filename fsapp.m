function [yi, p, a, b] = fsapp(x, y, xi, mh, mp)
% fsapp
%
% Aproksymacja danych przy pomocy szeregu Fouriera.
%
%       yi = fsapp(x, y, xi, mh, mp)
%
% Dane:
%
%       x  -- wektor odciętych
%       y  -- wektor rzędnych
%       xi -- wektor odciętych dla których mają być obliczone wartości yi
%       mh -- ilość harmonicznych (5 oznacza że liczone będą sin(5*x) itd.)
%       mp -- składniki wielomianowe (0 nie, 1 tylko stała, 2 liniowy itd.)
%
% Wyniki:
%
%       yi -- wektor z wartościami obliczonymi z szeregu Fouriera
%       p  -- współczynniki wielomianu p(0) + p(1) * x**2 + ...
%       a  -- współczyniki przy sinusach
%       b  -- współczynniki przy cosinusach
%
% 2022, dr Sławomir Marczyński

    x = x(:);
    y = y(:);
    s = size(xi);
    xi = xi(:);

    if length(x) ~= length(y)
        error 'wektory x i y mają mają różne długości'
    end

    n = length(x);
    ni = length(xi);

  
    if nargin < 5
        mp = 1;
    end

    if nargin < 4
        mh = fix(n / 4);
    end


    minx = min(x);
    maxx = max(x);

    % Przeskalowanie odciętych do standardowego zakresu

    x  = 2*pi * (x  - minx) / (maxx - minx);
    xi = 2*pi * (xi - minx) / (maxx - minx);

    % Utworzenie macierzy W
    
    W = create_W(x, mh, mp);

    % Rozwiązanie równania

    q = W \ y;

    % Utworzenie macierzy Wi

    Wi = create_W(xi, mh, mp);

    % Obliczenie wartości aproksymowanych

    yi = Wi * q;
    if s(1) == 1
        yi = yi.';
    end

    if nargout > 1
        p = q(1:mp);
        a = q((mp+1):(mp+mh));
        b = q((mp+mh+1):end);
    end

end


function W = create_W(x, mh, mp)
    n = length(x);
    W = zeros(n, mp + 2 * mh);
    for k = 1 : mp
        W(:, k) = x(:) .^ k;
    end
    for k = 1:mh
        W(:, k + mp) = sin(k * x(:));
        W(:, k + mp + mh) = cos(k * x(:));
    end
end
