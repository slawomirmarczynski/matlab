N = 100; % liczba wierszy
M = 100; % liczba kolumn

% Macierz A

A = speye(N * M);

for i = 2 : (N - 1)
    for j = 2 : (M - 1)
        if i < round(N/4) || i > round(3*N/4) ...
                ||  j < round(M/4) || j > round(3*M/4)
            k  = i + (j - 1) * N;
            A(k, k) = 4;
            A(k, k - 1) = -1;
            A(k, k + 1) = -1;
            A(k, k - M) = -1;
            A(k, k + M) = -1;
        end
    end
end

b = zeros(N * M, 1);

for i = round(N/4): round(3*N/4)
    for j = round(M/4) : round(3*M/4)
        k = i + (j - 1) * N;
        b(k) = 100;
    end
end

for i = 1 : N  % pętla po numerze wiersza
    j = 1;
    k = i + (j - 1) * N;
    if i < round(N/4) || i > round(3*N/4) ...
            ||  j < round(M/4) || j > round(3*M/4)
        b(k) = 20; % temperatura z lewej strony
    else
        b(k) = 100;
    end
    j = M;
    k = i + (j - 1) * N;
    if i < round(N/4) || i > round(3*N/4) ...
            ||  j < round(M/4) || j > round(3*M/4)
        b(k) = 20; % temperatura z prawej strony
    end
end

for j = 1 : M  % pętla po numerze kolumny
    i = 1;
    k = i + (j - 1) * N;
    if i < round(N/4) || i > round(3*N/4) ...
            ||  j < round(M/4) || j > round(3*M/4)        
        b(k) = 20; % temperatura u góry
    end
    i = M;
    k = i + (j - 1) * N;
    if i < round(N/4) || i > round(3*N/4) ...
            ||  j < round(M/4) || j > round(3*M/4)
        b(k) = 20; % temperatura u dołu
    end
end



%A = sparse(A);

tic
T = A \ b;
toc

T = reshape(T, N, M);

contour(T, [20:5:100], 'ShowText', 'on');
grid on;
grid minor;
axis ij;
axis equal;

