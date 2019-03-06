
x = 0:.01:2*pi;
y1 = sin(x);
y2 = sin(2*x);
y3 = sin(4*x);
plot(x, [y1; y2; y3])
legend('y=sin(x)', 'y=sin(2x)','y=sin(4x)')
