a = 0;
b = 10 * pi;
N = 30000;

x = linspace(a, b, N+1);
y = 100 * sin(2*pi*x) .* exp(-x/10) + 50 * cos(2*pi*5 .* x);
r = 2000 * rand(1, N+1);
y = y + r;

Delta = x(2) - x(1);
f = (-N/2:N/2)' ./ (N * Delta);

F = fft(y);
F = Delta .* F;
F = fftshift(F);

P = 2.0 * abs(F).^2;
fdlaP = f(f > 0);
P = P(f > 0);

subplot(2,1,1); plot(x, y);
subplot(2,1,2); loglog(fdlaP, abs(P));


