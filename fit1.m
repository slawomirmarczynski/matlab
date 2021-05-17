x = [1, 2, 3, 5, 8];
y = [2, 2.5, 3, 4.5, 2.7];

figure(1);
clf;
plot(x,y, 'b*', 'MarkerSize', 24)
hold on;

lo = min(x);
hi = max(x);

xi = linspace(lo, hi, 1000);
yi = interp1(x, y, xi, 'spline');

plot(xi, yi);