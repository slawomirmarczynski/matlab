% Obliczanie minimalnej powierzchni bańki mydlanej
% rozpiętej na ramce drucianej w kształcie krawędzi
% prostopadłościanu.

x = linspace(0, 7);
y = linspace(0, 6);

[xx, yy] = meshgrid(x, y);
s = fun(xx, yy);
meshc(xx, yy, s);


function s = fun(x, y)

a =  7.0;  % długość krawędzi, centymetry
b =  6.0;  % długość krawędzi, centymetry
c =  5.0;  % długość krawędzi, centymetry

%x = 2.5;  % centralny prostokąt, równolegle do a, centymery
%y = 3.5;  % centralny prostokąt, równolegle do b, centymery

s0 = x .* y; % pole powierzchi centralnej części
s1 = (x + a) / 2 .* sqrt((a/2).^2 + ((b-y)/2).^2); % pole trapezu I
s2 = (y + b) / 2 .* sqrt((b/2).^2 + ((a-x)/2).^2); % pole trapezu II
s3 = c / 2 .* sqrt((a - x).^2 + (b - y).^2); % pole trójkąta

% pole całej bańki

s = s0 + 4 * s1 + 4 * s2 + 4 * s3;
end

