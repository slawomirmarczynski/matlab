global k

for k = [300, 600, 1000]
    ode45(@(t,q)oblicz(t,q,k), [0, 25], [0, 0, 0, 10.0, 0, 0]);
    hold all;
end

function dqdt = oblicz(t, q, k)
    x1 = q(1);
    x2 = q(2);
    x3 = q(3);
    v1 = q(4);
    v2 = q(5);
    v3 = q(6);
        
    m1 = 0.1;
    m2 = 0.1;
    m3 = 0.6;
    
    F1 = -k * (x1 - x2);
    F2 =  k * (x1 - x2) - k * (x2 - x3);
    F3 =  k * (x3 - x2);
    
    a1 = F1 / m1;
    a2 = F2 / m2;
    a3 = F3 / m3;
    
    dqdt = zeros(6, 1);
    dqdt(1) = v1;
    dqdt(2) = v2;
    dqdt(3) = v3;
    dqdt(4) = a1;
    dqdt(5) = a2;
    dqdt(6) = a3;
end