t_begin = 0;
t_end = 4;

global N L k m;

N = 10;
L = 0.01; % metrów
k = 100;  % N/m
m = 0.10; % kg

init_x = L:L:(N*L);
init_x(1) = init_x(1) + 1.0*L;
init_x(N) = init_x(N) - 0.5*L;
init_v = zeros(1, N);

[t, q] = ode45(@problem, [t_begin, t_end], [init_x, init_v]);
x = q(:, 1:N);
v = q(:, (N+1):end);
plot(t, x);
grid on;
grid minor;
title 'fala mechaniczna';
xlabel 'czas, sekundy';
ylabel 'współrzędna x, metry';


function dqdt = problem(t, q)
    
    global N L k m;

    x = q(1:N);
    v = q((N+1):(2*N));
    
    F = zeros(size(x));
    
    for i = 2:(N-1)
        F(i) = - k*(x(i) - x(i-1) - L) + k*(x(i+1) - x(i) - L);
    end
    F(1) = - k*(x(1) - L) + k*(x(2) - x(1) - L);
    F(N) = - k*(x(N) - x(N-1) - L) + k*((N+1)*L - x(N) - L);
    
    a = F / m;
    
    dqdt = [v; a];

end
