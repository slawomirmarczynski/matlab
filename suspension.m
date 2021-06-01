% Problem - jakie siły (co do wartości) występują gdy
% w specyficzny sposób umocujemy małą kulkę na sprężynkach?

a = 0.50; % metry
b = 0.50; % metry
c = 0.20; % metry

k = 1000; % N/m

L0 = 0.5 * sqrt(a.^2 + b.^2 + c.^2); % długość spężynki

delta = 1E-4;

[theta, phi] = meshgrid(0:5:180, 0:5:360);

x = delta .* sind(theta) .* cosd(phi);
y = delta .* sind(theta) .* sind(phi);
z = delta .* cosd(theta);

dU = zeros(size(x));

xs = -a/2; ys = -b/2; zs = -c/2;
L = sqrt((x - xs).^2 + (y - ys).^2 + (z - zs).^2);
dL = L - L0;
dU = dU + k/2 * dL.^2;            

xs = +a/2; ys = -b/2; zs = -c/2;
L = sqrt((x - xs).^2 + (y - ys).^2 + (z - zs).^2);
dL = L - L0;
dU = dU + k/2 * dL.^2;            

xs = -a/2; ys = +b/2; zs = -c/2;
L = sqrt((x - xs).^2 + (y - ys).^2 + (z - zs).^2);
dL = L - L0;
dU = dU + k/2 * dL.^2;            

xs = +a/2; ys = +b/2; zs = -c/2;
L = sqrt((x - xs).^2 + (y - ys).^2 + (z - zs).^2);
dL = L - L0;
dU = dU + k/2 * dL.^2;            

xs = -a/2; ys = -b/2; zs = +c/2;
L = sqrt((x - xs).^2 + (y - ys).^2 + (z - zs).^2);
dL = L - L0;
dU = dU + k/2 * dL.^2;            

xs = +a/2; ys = -b/2; zs = +c/2;
L = sqrt((x - xs).^2 + (y - ys).^2 + (z - zs).^2);
dL = L - L0;
dU = dU + k/2 * dL.^2;            

xs = -a/2; ys = +b/2; zs = +c/2;
L = sqrt((x - xs).^2 + (y - ys).^2 + (z - zs).^2);
dL = L - L0;
dU = dU + k/2 * dL.^2;            

xs = +a/2; ys = +b/2; zs = +c/2;
L = sqrt((x - xs).^2 + (y - ys).^2 + (z - zs).^2);
dL = L - L0;
dU = dU + k/2 * dL.^2;            

F = abs(- dU ./ delta);

surf(x, y, z, F);
axis equal;

