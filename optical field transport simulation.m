wavelength = 800e-9;  % the wavelength of the optical field
l = 0.05;  % size of image plane
N = 1001;  % pixles

x = linspace(-l/2, l/2, N);
y = linspace(-l/2, l/2, N);
[X,Y] = meshgrid(x,y);  % coordinates of image plane

u = exp(-(X.^2 + Y.^2)/(2*(0.01)^2));  % intensity of the optical field
U = fftshift(fft2(u));  % Fourier transform 

% coordinates of frequency domain
dx = x(2) - x(1);
fx = linspace(-1/(2*dx), 1/(2*dx), N);
[Fx, Fy] = meshgrid(fx, fx);

D = exp(1i*pi*wavelength*(Fx.^2 + Fy.^2));  % diffraction function
out = ifft2(ifftshift(U.*D));  % optical amplitude of image plane

% sketch the result of the Fourier transform of the optical beam
figure;
imagesc(abs(out2).^2);
colorbar;axis image;
title('image plane');
figure;
imagesc(u);
colorbar;axis image;
title('object plane');
