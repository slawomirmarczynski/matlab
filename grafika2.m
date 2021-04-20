N = 1000;

theta_v = linspace(0, 360, N);
phi_v = linspace(0, 360, N);

[theta, phi] = meshgrid(theta_v, phi_v);
r = 1.0;
R = 5.0;

x = (R + r * cosd(phi)) .* cosd(theta);
y = (R + r * cosd(phi)) .* sind(theta);
z = r * sind(phi);

z( x > 0 & y > 0 ) = NaN;

surf(x, y, z);
shading interp;

axis square;
axis equal;
