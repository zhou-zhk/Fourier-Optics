close all;clear;clc;
% parameters
lambda=266e-6;  % 266nm=266e-6mm
width=10;  % 10mm

H=1001; % number of pixels, be odd 
V=H;
y=linspace(-(width/2),(width/2),V);
x=linspace(-(width/2),(width/2),H);
[X,Y]=meshgrid(x,y); % coordinate system
[theta,r]=cart2pol(X,Y);

w0=0.8*width;  % gaussian beam waist
U0=exp(-r.^2/w0.^2);

figure;
imagesc(U0); 

ph1=ones(501)*pi;
ph2=ones(500,501)*pi;
ph3=ones(501,500)*pi;
ph4=ones(500)*pi;
phmask=[0.5*ph1 0*ph3;ph2 1.5*ph4];

figure;
imagesc(phmask);  % the phase distribution of the phase plate 

f=20000;   % focus length 20000mm=20m, for shorter wavelength about 1-10 nm, the focus distance should be about 0.01-0.1m
T=pi/lambda/(f)*(Y.^2+X.^2); % lens phase
U=U0.*exp(-1i*phmask);
out=diffraction_tool(lambda,U.*exp(-1i*T),x,H,f);  % use the function of diffraction tool 
I=abs(out).^2;

% The remaining code is for plotting/visualisation purposes only
figure
imagesc([-5,5],[-5,5],I);
figure
imagesc([-5,5],[-5,5],angle(out));

figure
imagesc([-1,1],[-1,1],I(401:601,401:601)); % central domain of the image
figure
imagesc([-1,1],[-1,1],angle(out(401:601,401:601)));
