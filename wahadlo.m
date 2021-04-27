function dqdt = wahadlo(t, q)

    alfa = q(1);
    v = q(2);
    
    L = 1.0;
    g = 9.81;
    
    dalfa_dt = v / L;
    dv_dt = - g * sin(alfa);
    
    dqdt = zeros(2, 1);
    dqdt(1) = dalfa_dt;
    dqdt(2) = dv_dt;
end