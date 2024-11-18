close all; clc; clear;
% this file does not utilize the function of diffraction tool
wavelength = 800e-9;                          % the wavelength of the optical beam, IR beam 800nm
l = 0.16;                                     % the size of image plane, 0.16m 
N = 4001;                                     % the pixle number which should be odd instead of even because of the Fourier algorithm

x = linspace(-l/2, l/2, N);
y = linspace(-l/2, l/2, N);
[X,Y] = meshgrid(x,y);                        % coordinates of image plane

u = exp(-(X.^2 + Y.^2)/(2*(0.01)^2));         % intensity of the optical field
U = fftshift(fft2(u));                        % Fourier transform 

% coordinates of frequency domain
dx = x(2) - x(1);
fx = linspace(-1/(2*dx), 1/(2*dx), N);
[Fx, Fy] = meshgrid(fx, fx);

D = exp(1i*pi*wavelength*(Fx.^2 + Fy.^2));    % the diffraction function (Fresnel diffraction)
out = ifft2(ifftshift(U.*D));                 % optical amplitude of image plane

% sketch the results of the Fourier transform of the optical beam field
figure;
imagesc(abs(out2).^2);
title('image plane');
colorbar; 
axis image;

figure;
imagesc(u);
title('object plane');
colorbar;
axis image;
