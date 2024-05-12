wavelength = 800e-9;
l = 0.05;  % size of image plane
N = 1000;  % pixles

x = linspace(-l/2, l/2, N);
y = linspace(-l/2, l/2, N);
[X,Y] = meshgrid(x,y);

u = exp(-(X.^2 + Y.^2)/(2*(0.01)^2));  % intensity of the optical field
