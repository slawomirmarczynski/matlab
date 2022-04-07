function gumka
%
% GUMKA - rozwi¹zywanie równañ ODE (2012, S³awomir Marczyñski)

  %----------------------------------------------------------------------
  % Parametry i dane wejœciowe

  m  =   0.1  ; % masa ciê¿arka w kilogramach
  l0 =   1.0  ; % d³ugoœæ nitki gumowej (nierozci¹gniêtej)
  l  =   1.1  ; % d³ugoœæ nitki gumowej (po zawieszeniu ciê¿arka)
  g  =   9.81 ; % przyspieszenie ziemskie normalne
  
  k  =   m * g / (l - l0);
  
  %----------------------------------------------------------------------
  % Warunki pocz¹tkowe
  
  x0    =   0.5; % w metrach
  y0    =   0.0; % w metrach
  z0    =  -0.5; % w metrach
  
  v0    =   0.1; % prêdkoœæ pocz¹tkowa, w metrach na sekundê
  alfa  =  90.0; % k¹t w stopniach
  beta  =   0.0; % k¹t w stopniach
  
  v0x   = v0 * cosd(beta) * cosd(alfa); 
  v0y   = v0 * cosd(beta) * sind(alfa);
  v0z   = v0 * sind(beta);
  
  init  = [ x0, y0, z0, v0x, v0y, v0z];
  
  %----------------------------------------------------------------------
  % Parametry steruj¹ce symulacj¹
  n       = 500; % w ilu punktach ma byæ podane rozwi¹zanie
  t_start =   0; % czas startu symulacji, sekundy
  t_end   =  20; % czas stopu  symulacji, sekundy
  
  t   = linspace(t_start, t_end, n); % generowanie wektora czasu
  opt = odeset('InitialStep',0.0001/v0,'MaxStep',0.0001/v0);

  %----------------------------------------------------------------------
  % W tym miejscu wywo³ujemy ode45 aby rozwi¹zaæ równanie

  [czas, wyniki] = ode45(@fcn, t, init, opt, m, l0, k, g);

  %----------------------------------------------------------------------
  % Równanie jest ju¿ rozwi¹zane numerycznie, pozostaje pokazaæ wyniki
  
  plot3(wyniki(:,1), wyniki(:,2), wyniki(:,3));
  axis square;
  grid on;
  xlabel 'x';
  ylabel 'y';
  zlabel 'z';
  title  'trajektoria ciê¿arka'
end


function dqdt = fcn(t, q, m, l0, k, g)
% 
% Funkcja fcn oblicza prawe strony uk³adu równañ ró¿niczkowych:
% 
%   dq(1)/dt = f1(t,q(1),q(2),...,q(n))
%   dq(2)/dt = f1(t,q(1),q(2),...,q(n))
%        ... = ...
%   dq(n)/dt = f1(t,q(1),q(2),...,q(n))
  
  dqdt = zeros(size(q)); 
  
  x  = q(1);
  y  = q(2);
  z  = q(3);
  vx = q(4);
  vy = q(5);
  vz = q(6);
  
  r = sqrt(x^2 + y^2 + z^2);
  delta = r - l0;
   
  dqdt(1) = vx;
  dqdt(2) = vy;
  dqdt(3) = vz;
  
  if delta > 0.
    dqdt(4) = - (x/r) * k * delta / m;
    dqdt(5) = - (y/r) * k * delta / m;
    dqdt(6) = - (z/r) * k * delta / m - g;
  else
    dqdt(4) = 0.;
    dqdt(5) = 0.;
    dqdt(6) =  - g;
  end

end
