L = 1.0
for alfa0 = 10:10:180
    ode45(@(t, q) wahadlo_fun(t, q, L), [0, 40], [alfa0, 0])
    hold all
    ode45(@(t, q) wahadlo_harm(t, q, L), [0, 40], [alfa0, 0])
end


function dqdt = wahadlo_fun(t, q, L)
    alfa = q(1);
    v = q(2);
    
    g = 9.81;
    
    dalfa_dt = v / L;
    dv_dt = - g * sind(alfa);
    
    dqdt = zeros(2, 1);
    dqdt(1) = dalfa_dt;
    dqdt(2) = dv_dt;
end

function dqdt = wahadlo_harm(t, q, L)
    alfa = q(1);
    v = q(2);
    
    g = 9.81;
    
    dalfa_dt = v / L;
    dv_dt = - g * alfa * pi / 180.0;
    
    dqdt = zeros(2, 1);
    dqdt(1) = dalfa_dt;
    dqdt(2) = dv_dt;
end