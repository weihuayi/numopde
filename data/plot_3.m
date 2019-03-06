
t = linspace(0, 2*pi, 512);
[u,v] = meshgrid(t);
a = -0.4; b = .5; c = .1;
n = 3;
x = (a*(1 - v/(2*pi)) .*(1+cos(u)) + c) .* cos(n*v);
y = (a*(1 - v/(2*pi)) .*(1+cos(u)) + c) .* sin(n*v);
z = b*v/(2*pi) + a*(1 - v/(2*pi)) .* sin (u);
surf(x,y,z,y)
axis off
axis equal
colormap(hsv(1024))
shading interp
material shiny
lighting phong
camlight('left', 'infinite')
view([-160 25])
