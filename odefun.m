function dqdt = odefun(t, q)

% Ta funkcja musi wejść do ODE45 lub podobnej

    x = q(1);
    v = q(2);
    
    m0 = 10.0; % kg
    s = 10; % sekundy
    k = 100;
    
    m = m0 * exp(-t / s);
    F = -k * x;
    
    a = F / m  +  v / s;
    
    dqdt = zeros(2, 1);
    
    dqdt(1) = v;
    dqdt(2) = a;    
end