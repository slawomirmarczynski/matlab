figure(1);
clf;

x = [];
y = [];
t = [];

x_ginput = [1]; % cokolwiek
while ~isempty(x_ginput)
    [x_ginput, y_ginput] = ginput(1);    
    x = [x ; x_ginput];
    y = [y ; y_ginput];
    plot(x, y, '*r');
end
hold all;

N = length(x);
M = 50;

t = 0 : (N - 1);

ti = linspace(t(1), t(end), M);
xi = interp1(t,x, ti, 'spline');
yi = interp1(t,y, ti, 'spline');

s = 0;
for i = 2 : M
    ds = sqrt((xi(i) - xi(i-1))^2 + (yi(i) - yi(i-1))^2);
    s = s + ds;
end
M
s

M = 2 * M;
ti = linspace(t(1), t(end), M);
xi = interp1(t,x, ti, 'spline');
yi = interp1(t,y, ti, 'spline');

s = 0;
for i = 2 : M
    ds = sqrt((xi(i) - xi(i-1))^2 + (yi(i) - yi(i-1))^2);
    s = s + ds;
end
M
s

M = 2 * M;
ti = linspace(t(1), t(end), M);
xi = interp1(t,x, ti, 'spline');
yi = interp1(t,y, ti, 'spline');

s = 0;
for i = 2 : M
    ds = sqrt((xi(i) - xi(i-1))^2 + (yi(i) - yi(i-1))^2);
    s = s + ds;
end
M
s


plot(xi, yi, 'b-o');









