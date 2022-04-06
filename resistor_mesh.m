function [r0, drmin_relative ] = ResistorMesh(n,m,R)
% Obliczanie rezystancji inteligentnej tkaniny, funkcja dla programu MATLAB.
%
% Dane: 
%
%   n - liczba węzłów poziomo
%   m - liczba węzłów pionowo
%   R - opór pojedynczej gałęzi (w omach)
%
% Wyniki:
%
%   r0             - opór zastępczy układu (w omach)
%   drmin_relative - najmniejsza możliwa względna zmiana oporu wywołana
%                    zniszczeniem (przerwaniem) jednego z oporów;
%                    np. wartość drmin_relative = 0.05 oznacza iż możliwe jest
%                    uszkodzenie które da wzrost oporu o jedynie 5%.

    % Jeżeli nie podano n, m, R to przyjmowane są wartości domyślne.
    %
    if nargin < 1, n = 10; end
    if nargin < 2, m = 10; end
    if nargin < 3, R =  1; end

    % Sieć oporników jest zapamiętana jako dwa wektory przewodności:
    % p poziomo,q to te ułożone pionowo. Czyli z węzła o współrzędnych (i,j), 
    % który ma numer n*(j-1) + i, wychodzić mogą gałęzie p(i,j-1), p(i,j),
    % q(i-1,j), q(i,j) jeżeli nie jest on położony na brzegu. 
    %
    % Wektory p0, q0 przechowują pełną siatkę połączeń.
    %
    p0 = ones(n,m-1) / R;
    q0 = ones(n-1,m) / R;
    
    % Obliczanie oporu zastępczego dla pełnej sieci oporników.
    %
    r0 = resistance(n,m,p0,q0);
    
    % Obliczanie oporu zastępczego dla usuniętych pojedynczych oporników 
    % - wybierane są tylko poziome. Wyniki są wpisywane do tablicy rp.
    %
    rp = zeros(size(p0));       
    for k = 1:length(p0);
        p = p0;
        p(k) = 0;
        rp(k) = resistance(n,m,p,q0);
    end

    % Obliczanie oporu zastępczego dla usuniętych pojedynczych oporników 
    % - wybierane są tylko pionowe. Wyniki są wpisywane do tablicy rq.
    %
    rq = zeros(size(q0));
    for k = 1:length(q0);
        q = q0;
        q(k) = 0;
        rq(k) = resistance(n,m,p0,q);
    end
    
    % Scalanie danych, z powstającego wektora usuwane są wszystkie powtarzające
    % się wyniki.
    %
    r = unique( [ rp(:) ; rq(:) ] );
    
    % Wypisywanie, w bardzo uproszczony sposób, wyników na konsoli:
    % drmax jest maksymalną wartością bezwzględnej różnicy pomiędzy oporem
    % sieci oporników po uszkodzeniu (jednego oporu) i przed uszkodzeniem;
    % drmin jest minimalną wartością bezwzględnej różnicy pomiędzy oporem
    % sieci po i przed uszkodzeniem.
    %
    r0    
    drmax = max( abs( r - r0 ) )    
    drmin = min( abs( r - r0 ) )
    drmax_relative = drmax / r0
    drmin_relative = drmin / r0
    
end


function equivalent_resistance = resistance(n,m,p,q)
% Obliczanie oporu zastępczego dla liczby węzłów n, m oraz wektorów przewodności
% p,q. Ponieważ jest to funkcja lokalna, to nie będzie (bo nie może) wywoływana
% inaczej niż z funkcji ResistorMesh. Nie musimy więc zastanawiać się nad tym
% gdzie i jak mogłaby być użyta, czy podano wszystkie dane wejściowe itd. itp.
%
% Jest w tym samym pliku co funkcja ResistorMesh - czyli trudniej o pomyłkowe
% użycie nie tej co trzeba funkcji resistance w ResistorMesh.
%
% UWAGA: obliczenia mogłyby przebiegać szybciej, gdyby nie tworzyć za każdym
% razem całej macierzy G. Jednak zysk na czasie nie jest aż tak wielki jakby
% mogło się wydawać - tworzenie jest szybkie w porównaniu z odwracaniem.

    % Utworzenie macierzy przewodności G.
    %
    nm = n*m;
    G = sparse(nm,nm); % utworzenie zerowej macierzy rzadkiej
    for i = 1:n
        for j = 1:m
            k = n * (j - 1) + i;  % numer węzła
            if j > 1 % nie jest to lewy brzeg, więc jest sąsiad z lewej
                k1 = n * (j - 1 - 1) + i;
                G(k,k) = G(k,k) + p(i,j-1); 
                G(k,k1) = G(k,k1) - p(i,j-1);
            end
            if j < m % nie jest to prawy brzeg, więc jest sąsiad z prawej
                k1 = n * (j - 1 + 1) + i;
                G(k,k) = G(k,k) + p(i,j);   
                G(k,k1) = G(k,k1) - p(i,j);
            end
            if i > 1 % nie jest to pierwszy wiersz, więc jest  sąsiad powyżej
                k1 = n * (j - 1) + i - 1;
                G(k,k) = G(k,k) + q(i-1,j); 
                G(k,k1) = G(k,k1) - q(i-1,j);
            end
            if i < n % nie jest to ostatni wiersz, więc jest sąsiad powyżej
                k1 = n * (j - 1) + i + 1;
                G(k,k) = G(k,k) + q(i,j);   
                G(k,k1) = G(k,k1) - q(i,j);
            end
        end
    end

    % Wektor prądów b. Wszystkie niepodłączone węzły mają prądy zero (tyle samo
    % wpływa co wypływa). Dwa węzły są podłączone do źródła prądowego.
    % UWAGA: oznaczenie b zamiast I, i, j itp. aby uniknąć nieporozumień takich
    % jak pomylenie z macierzą jednostkową i/lub liczbami zespolonymi.
    %
    node_A = 1;
    node_B = nm;
    b = sparse(nm,1);
    b(node_A) =  1.0; % prąd o natężeniu  1 ampera
    b(node_B) = -1.0; % prąd o natężeniu -1 ampera

    % Modyfikujemy układ równań tak, aby ostatni węzeł miał potencjał zero.
    % Ok, moglibyśmy po prostu zrobić pętlę for i = 1:(n-1), bo i tak wyliczony
    % w tej pętli wiersz macierzy G zostanie teraz nadpisany na nowo.
    %
    G(nm,:)  = 0;
    G(nm,nm) = 1;
    b(nm)    = 0;
    
    % Właściwe obliczenia - rozwiązanie układu równań.
    %
    v = G \ b;

    % Obliczenie oporności zastępczej. Ponieważ prąd z założenia wynosił 1 amper,
    % to do obliczenia oporu zastępczego dzielenie przez 1 może być pominięte.
    % Konieczne jest użycie funkcji full - operowaliśmy na macierzach rzadkich.
    %
    equivalent_resistance = full(v(node_A) - v(node_B));
end
