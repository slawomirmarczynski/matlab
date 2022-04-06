function [r0, drmin_relative ] = ResistorMesh(n,m,R)
% Obliczanie rezystancji inteligentnej tkaniny, funkcja dla programu MATLAB.
%
% Dane: 
%
%   n - liczba wêz³ów poziomo
%   m - liczba wêz³ów pionowo
%   R - opór pojedynczej ga³êzi (w omach)
%
% Wyniki:
%
%   r0             - opór zastêpczy uk³adu (w omach)
%   drmin_relative - najmniejsza mo¿liwa wzglêdna zmiana oporu wywo³ana
%                    zniszczeniem (przerwaniem) jednego z oporów;
%                    np. wartoœæ drmin_relative = 0.05 oznacza i¿ mo¿liwe jest
%                    uszkodzenie które da wzrost oporu o jedynie 5%.

    % Je¿eli nie podano n, m, R to przyjmowane s¹ wartoœci domyœlne.
    %
    if nargin < 1, n = 10; end
    if nargin < 2, m = 10; end
    if nargin < 3, R =  1; end

    % Sieæ oporników jest zapamiêtana jako dwa wektory przewodnoœci:
    % p poziomo,q to te u³o¿one pionowo. Czyli z wêz³a o wspó³rzêdnych (i,j), 
    % który ma numer n*(j-1) + i, wychodziæ mog¹ ga³êzie p(i,j-1), p(i,j),
    % q(i-1,j), q(i,j) je¿eli nie jest on po³o¿ony na brzegu. 
    %
    % Wektory p0, q0 przechowuj¹ pe³n¹ siatkê po³¹czeñ.
    %
    p0 = ones(n,m-1) / R;
    q0 = ones(n-1,m) / R;
    
    % Obliczanie oporu zastêpczego dla pe³nej sieci oporników.
    %
    r0 = resistance(n,m,p0,q0);
    
    % Obliczanie oporu zastêpczego dla usuniêtych pojedynczych oporników 
    % - wybierane s¹ tylko poziome. Wyniki s¹ wpisywane do tablicy rp.
    %
    rp = zeros(size(p0));       
    for k = 1:length(p0);
        p = p0;
        p(k) = 0;
        rp(k) = resistance(n,m,p,q0);
    end

    % Obliczanie oporu zastêpczego dla usuniêtych pojedynczych oporników 
    % - wybierane s¹ tylko pionowe. Wyniki s¹ wpisywane do tablicy rq.
    %
    rq = zeros(size(q0));
    for k = 1:length(q0);
        q = q0;
        q(k) = 0;
        rq(k) = resistance(n,m,p0,q);
    end
    
    % Scalanie danych, z powstaj¹cego wektora usuwane s¹ wszystkie powtarzaj¹ce
    % siê wyniki.
    %
    r = unique( [ rp(:) ; rq(:) ] );
    
    % Wypisywanie, w bardzo uproszczony sposób, wyników na konsoli:
    % drmax jest maksymaln¹ wartoœci¹ bezwzglêdnej ró¿nicy pomiêdzy oporem
    % sieci oporników po uszkodzeniu (jednego oporu) i przed uszkodzeniem;
    % drmin jest minimaln¹ wartoœci¹ bezwzglêdnej ró¿nicy pomiêdzy oporem
    % sieci po i przed uszkodzeniem.
    %
    r0    
    drmax = max( abs( r - r0 ) )    
    drmin = min( abs( r - r0 ) )
    drmax_relative = drmax / r0
    drmin_relative = drmin / r0
    
end


function equivalent_resistance = resistance(n,m,p,q)
% Obliczanie oporu zastêpczego dla liczby wêz³ów n, m oraz wektorów przewodnoœci
% p,q. Poniewa¿ jest to funkcja lokalna, to nie bêdzie (bo nie mo¿e) wywo³ywana
% inaczej ni¿ z funkcji ResistorMesh. Nie musimy wiêc zastanawiaæ siê nad tym
% gdzie i jak mog³aby byæ u¿yta, czy podano wszystkie dane wejœciowe itd. itp.
%
% Jest w tym samym pliku co funkcja ResistorMesh - czyli trudniej o pomy³kowe
% u¿ycie nie tej co trzeba funkcji resistance w ResistorMesh.
%
% UWAGA: obliczenia mog³yby przebiegaæ szybciej, gdyby nie tworzyæ za ka¿dym
% razem ca³ej macierzy G. Jednak zysk na czasie nie jest a¿ tak wielki jakby
% mog³o siê wydawaæ - tworzenie jest szybkie w porównaniu z odwracaniem.

    % Utworzenie macierzy przewodnoœci G.
    %
    nm = n*m;
    G = sparse(nm,nm); % utworzenie zerowej macierzy rzadkiej
    for i = 1:n
        for j = 1:m
            k = n * (j - 1) + i;  % numer wêz³a
            if j > 1 % nie jest to lewy brzeg, wiêc jest s¹siad z lewej
                k1 = n * (j - 1 - 1) + i;
                G(k,k) = G(k,k) + p(i,j-1); 
                G(k,k1) = G(k,k1) - p(i,j-1);
            end
            if j < m % nie jest to prawy brzeg, wiêc jest s¹siad z prawej
                k1 = n * (j - 1 + 1) + i;
                G(k,k) = G(k,k) + p(i,j);   
                G(k,k1) = G(k,k1) - p(i,j);
            end
            if i > 1 % nie jest to pierwszy wiersz, wiêc jest  s¹siad powy¿ej
                k1 = n * (j - 1) + i - 1;
                G(k,k) = G(k,k) + q(i-1,j); 
                G(k,k1) = G(k,k1) - q(i-1,j);
            end
            if i < n % nie jest to ostatni wiersz, wiêc jest s¹siad powy¿ej
                k1 = n * (j - 1) + i + 1;
                G(k,k) = G(k,k) + q(i,j);   
                G(k,k1) = G(k,k1) - q(i,j);
            end
        end
    end

    % Wektor pr¹dów b. Wszystkie niepod³¹czone wêz³y maj¹ pr¹dy zero (tyle samo
    % wp³ywa co wyp³ywa). Dwa wêz³y s¹ pod³¹czone do Ÿród³a pr¹dowego.
    % UWAGA: oznaczenie b zamiast I, i, j itp. aby unikn¹æ nieporozumieñ takich
    % jak pomylenie z macierz¹ jednostkow¹ i/lub liczbami zespolonymi.
    %
    node_A = 1;
    node_B = nm;
    b = sparse(nm,1);
    b(node_A) =  1.0; % pr¹d o natê¿eniu  1 ampera
    b(node_B) = -1.0; % pr¹d o natê¿eniu -1 ampera

    % Modyfikujemy uk³ad równañ tak, aby ostatni wêze³ mia³ potencja³ zero.
    % Ok, moglibyœmy po prostu zrobiæ pêtlê for i = 1:(n-1), bo i tak wyliczony
    % w tej pêtli wiersz macierzy G zostanie teraz nadpisany na nowo.
    %
    G(nm,:)  = 0;
    G(nm,nm) = 1;
    b(nm)    = 0;
    
    % W³aœciwe obliczenia - rozwi¹zanie uk³adu równañ.
    %
    v = G \ b;

    % Obliczenie opornoœci zastêpczej. Poniewa¿ pr¹d z za³o¿enia wynosi³ 1 amper,
    % to do obliczenia oporu zastêpczego dzielenie przez 1 mo¿e byæ pominiête.
    % Konieczne jest u¿ycie funkcji full - operowaliœmy na macierzach rzadkich.
    %
    equivalent_resistance = full(v(node_A) - v(node_B));
end
