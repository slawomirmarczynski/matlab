f = @(x) 1 ./ x;
g = @(x) 0.5 * (x - 5).^2 - 1;

a = 0;
b = 10;
N = 1000;


xL = fzero( @(cokolwiek) f(cokolwiek) - g(cokolwiek), [-1000, 4.9999]);
xR = fzero( @(x) f(x) - g(x), [5.0001, 1000]);

xi = linspace(xL, xR, N);
up = f(xi);
down = g(xi);

xx = [xi, fliplr(xi)];
yy = [up, fliplr(down)];

fill(xx, yy, 'yellow');
hold all;

x = linspace(a, b, N);
x = [x, xx];
x = unique(x);

myplot = plot(x, f(x),'-r', x, g(x), '-b');

grid on;
grid minor;
xlabel 'oś x';
ylabel 'oś y';

legend([myplot], 'f(x)', 'g(x)');

ylim([-2, 2]);


