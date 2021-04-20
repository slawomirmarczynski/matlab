lo = -3;
hi = +3;
N = 100;

xv = linspace(lo, hi, N);
yv = linspace(lo, hi, N);

[x, y] = meshgrid(xv, yv);

z = sin(5*x) .* sin(5*y) .* (x.^2 + y.^3);

z( x > 0 & y > 0 ) = NaN;


surfl(x, y, z)
