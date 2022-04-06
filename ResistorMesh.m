function [r0, drmin_relative ] = ResistorMesh(n,m,R)
% Obliczanie rezystancji inteligentnej tkaniny, funkcja dla programu MATLAB.
%
% Dane: 
%
%   n - liczba w�z��w poziomo
%   m - liczba w�z��w pionowo
%   R - op�r pojedynczej ga��zi (w omach)
%
% Wyniki:
%
%   r0             - op�r zast�pczy uk�adu (w omach)
%   drmin_relative - najmniejsza mo�liwa wzgl�dna zmiana oporu wywo�ana
%                    zniszczeniem (przerwaniem) jednego z opor�w;
%                    np. warto�� drmin_relative = 0.05 oznacza i� mo�liwe jest
%                    uszkodzenie kt�re da wzrost oporu o jedynie 5%.

    % Je�eli nie podano n, m, R to przyjmowane s� warto�ci domy�lne.
    %
    if nargin < 1, n = 10; end
    if nargin < 2, m = 10; end
    if nargin < 3, R =  1; end

    % Sie� opornik�w jest zapami�tana jako dwa wektory przewodno�ci:
    % p poziomo,q to te u�o�one pionowo. Czyli z w�z�a o wsp�rz�dnych (i,j), 
    % kt�ry ma numer n*(j-1) + i, wychodzi� mog� ga��zie p(i,j-1), p(i,j),
    % q(i-1,j), q(i,j) je�eli nie jest on po�o�ony na brzegu. 
    %
    % Wektory p0, q0 przechowuj� pe�n� siatk� po��cze�.
    %
    p0 = ones(n,m-1) / R;
    q0 = ones(n-1,m) / R;
    
    % Obliczanie oporu zast�pczego dla pe�nej sieci opornik�w.
    %
    r0 = resistance(n,m,p0,q0);
    
    % Obliczanie oporu zast�pczego dla usuni�tych pojedynczych opornik�w 
    % - wybierane s� tylko poziome. Wyniki s� wpisywane do tablicy rp.
    %
    rp = zeros(size(p0));       
    for k = 1:length(p0);
        p = p0;
        p(k) = 0;
        rp(k) = resistance(n,m,p,q0);
    end

    % Obliczanie oporu zast�pczego dla usuni�tych pojedynczych opornik�w 
    % - wybierane s� tylko pionowe. Wyniki s� wpisywane do tablicy rq.
    %
    rq = zeros(size(q0));
    for k = 1:length(q0);
        q = q0;
        q(k) = 0;
        rq(k) = resistance(n,m,p0,q);
    end
    
    % Scalanie danych, z powstaj�cego wektora usuwane s� wszystkie powtarzaj�ce
    % si� wyniki.
    %
    r = unique( [ rp(:) ; rq(:) ] );
    
    % Wypisywanie, w bardzo uproszczony spos�b, wynik�w na konsoli:
    % drmax jest maksymaln� warto�ci� bezwzgl�dnej r�nicy pomi�dzy oporem
    % sieci opornik�w po uszkodzeniu (jednego oporu) i przed uszkodzeniem;
    % drmin jest minimaln� warto�ci� bezwzgl�dnej r�nicy pomi�dzy oporem
    % sieci po i przed uszkodzeniem.
    %
    r0    
    drmax = max( abs( r - r0 ) )    
    drmin = min( abs( r - r0 ) )
    drmax_relative = drmax / r0
    drmin_relative = drmin / r0
    
end


function equivalent_resistance = resistance(n,m,p,q)
% Obliczanie oporu zast�pczego dla liczby w�z��w n, m oraz wektor�w przewodno�ci
% p,q. Poniewa� jest to funkcja lokalna, to nie b�dzie (bo nie mo�e) wywo�ywana
% inaczej ni� z funkcji ResistorMesh. Nie musimy wi�c zastanawia� si� nad tym
% gdzie i jak mog�aby by� u�yta, czy podano wszystkie dane wej�ciowe itd. itp.
%
% Jest w tym samym pliku co funkcja ResistorMesh - czyli trudniej o pomy�kowe
% u�ycie nie tej co trzeba funkcji resistance w ResistorMesh.
%
% UWAGA: obliczenia mog�yby przebiega� szybciej, gdyby nie tworzy� za ka�dym
% razem ca�ej macierzy G. Jednak zysk na czasie nie jest a� tak wielki jakby
% mog�o si� wydawa� - tworzenie jest szybkie w por�wnaniu z odwracaniem.

    % Utworzenie macierzy przewodno�ci G.
    %
    nm = n*m;
    G = sparse(nm,nm); % utworzenie zerowej macierzy rzadkiej
    for i = 1:n
        for j = 1:m
            k = n * (j - 1) + i;  % numer w�z�a
            if j > 1 % nie jest to lewy brzeg, wi�c jest s�siad z lewej
                k1 = n * (j - 1 - 1) + i;
                G(k,k) = G(k,k) + p(i,j-1); 
                G(k,k1) = G(k,k1) - p(i,j-1);
            end
            if j < m % nie jest to prawy brzeg, wi�c jest s�siad z prawej
                k1 = n * (j - 1 + 1) + i;
                G(k,k) = G(k,k) + p(i,j);   
                G(k,k1) = G(k,k1) - p(i,j);
            end
            if i > 1 % nie jest to pierwszy wiersz, wi�c jest  s�siad powy�ej
                k1 = n * (j - 1) + i - 1;
                G(k,k) = G(k,k) + q(i-1,j); 
                G(k,k1) = G(k,k1) - q(i-1,j);
            end
            if i < n % nie jest to ostatni wiersz, wi�c jest s�siad powy�ej
                k1 = n * (j - 1) + i + 1;
                G(k,k) = G(k,k) + q(i,j);   
                G(k,k1) = G(k,k1) - q(i,j);
            end
        end
    end

    % Wektor pr�d�w b. Wszystkie niepod��czone w�z�y maj� pr�dy zero (tyle samo
    % wp�ywa co wyp�ywa). Dwa w�z�y s� pod��czone do �r�d�a pr�dowego.
    % UWAGA: oznaczenie b zamiast I, i, j itp. aby unikn�� nieporozumie� takich
    % jak pomylenie z macierz� jednostkow� i/lub liczbami zespolonymi.
    %
    node_A = 1;
    node_B = nm;
    b = sparse(nm,1);
    b(node_A) =  1.0; % pr�d o nat�eniu  1 ampera
    b(node_B) = -1.0; % pr�d o nat�eniu -1 ampera

    % Modyfikujemy uk�ad r�wna� tak, aby ostatni w�ze� mia� potencja� zero.
    % Ok, mogliby�my po prostu zrobi� p�tl� for i = 1:(n-1), bo i tak wyliczony
    % w tej p�tli wiersz macierzy G zostanie teraz nadpisany na nowo.
    %
    G(nm,:)  = 0;
    G(nm,nm) = 1;
    b(nm)    = 0;
    
    % W�a�ciwe obliczenia - rozwi�zanie uk�adu r�wna�.
    %
    v = G \ b;

    % Obliczenie oporno�ci zast�pczej. Poniewa� pr�d z za�o�enia wynosi� 1 amper,
    % to do obliczenia oporu zast�pczego dzielenie przez 1 mo�e by� pomini�te.
    % Konieczne jest u�ycie funkcji full - operowali�my na macierzach rzadkich.
    %
    equivalent_resistance = full(v(node_A) - v(node_B));
end
