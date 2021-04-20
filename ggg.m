f = @(x) 3 + sin(x);
g = @(x) 0.5 * (x - 5).^2 - 1;

a = 0;
b = 10;
N = 1000;


xL = fzero( @(x) f(x) - g(x), [-1000, 4.9999]);
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
plot(x, f(x), x, g(x));
grid on;
xlabel 'oś x';
ylabel 'oś y';
legend('', 'f(x)', 'g(x)');


