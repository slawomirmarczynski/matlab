function zasieg
%
% Zasiêg strza³u pociskiem BB z typowej wiatrówki (2012, S³awomir Marczyñski)


  % Warunki pocz¹tkowe
  
  x0    =    1.5;          % metry
  y0    =    0.0;          % metry
  v0    =  120.0;          % prêdkoœæ pocz¹tkowa, w metrach na sekundê
  alfa  =   45.0;          % k¹t w stopniach
  
  init  = [ x0, y0, v0 * cosd(alfa), v0 * sind(alfa)];
  
  
  % Parametry steruj¹ce symulacj¹
  
  n       = 500; % w ilu punktach ma byæ podane rozwi¹zanie
  t_start =   0; % czas startu symulacji, sekundy
  t_end   =  20; % czas stopu  symulacji, sekundy
  
  t   = linspace(t_start, t_end, n); % generowanie wektora czasu
  opt = odeset('Events',@events);    % dodawana jest funkcja kontroluj¹ca


  % W tym miejscu wywo³ujemy ode45 aby rozwi¹zaæ równania, 
  % pierwszy, niepotrzebny, wektor zwracany przez ode45 odrzucamy tyld¹
  
  [~, wyniki] = ode45(@fcn, t, init, opt, 0.33E-3, 4.5E-3, 1.2, 9.81);

  
  % Równanie jest ju¿ rozwi¹zane numerycznie, prezentujemy wyniki
  
  plot(wyniki(:,1),wyniki(:,2));
  grid on;
  xlabel 'x';
  ylabel 'y';
  title  'trajektoria'
end


function dqdt = fcn(t, q, m, D, ro, g)

  cx = 0.45; % wspó³czynnik oporu areodynamicznego

  dqdt = zeros(size(q)); 
  
  x  = q(1);
  y  = q(2);
  vx = q(3);
  vy = q(4);
  
  v  = sqrt(vx^2 + vy^2);
  F  = (cx/8) * (ro * D * v)^2 * pi;
     
  dqdt(1) = vx;
  dqdt(2) = vy;
  dqdt(3) = - (vx/v) * (F/m);
  dqdt(4) = - (vy/v) * (F/m) - g;

end


function [value,halt,direction] = events(t,q, m, D, ro, g)

% Obliczenia bêd¹ przerywane (halt = 1) gdy q(2) przejdzie przez zero (value = 0)
% od wartoœci dodatnich do ujemnych (direction = -1). 

  value     = q(2);
  halt      =   1 ;
  direction =  -1 ;
  
end