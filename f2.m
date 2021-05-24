
a = 0;
b = 500;
N = 1570;

t = linspace(a, b, N);
y = 12 * sin(2*pi* 15 * t) + 10 * cos(2*pi* 17.5 * t) + ...    
    1 * rand(1, N);

Delta = t(2) - t(1);

f = (-N/2 : +N/2)' ./ (N * Delta);
f = f';

F = Delta * fft(y);

F = F(:);
if mod(N, 2) == 0
    F = [F ; F(1) ];
    F = fftshift(F);
else
    F = fftshift(F);
    F = [F ; F(1) ];
end

fplus = f(f >= 0);
Fplus = F(f >= 0);

P = 2 * abs(Fplus).^2;

figure(1);
clf;
subplot(3,1,1); plot(t, y);
subplot(3,1,2); loglog(fplus, P);
