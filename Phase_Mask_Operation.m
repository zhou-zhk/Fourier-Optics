close all;clear;
%% Original Part
lambda1=266e-9; 
width=10e-3; % 10mm

N=4001; % number of pixels
V=N;
y=linspace(-(width/2),(width/2),V);
x=linspace(-(width/2),(width/2),N);
[X,Y]=meshgrid(x,y); % coordinate system
[theta0,rho0] = cart2pol(X,Y);

w0=0.8*width; % gaussian beam waist
U0=exp(-rho0.^2/w0.^2);

figure;
imagesc(U0)
axis image; colorbar;
title('Original Gaussian Beam Intensity','fontname','times new roman','fontsize',12);
figure;
imagesc(angle(U0));
axis image; colorbar;
title('Original Gaussian Beam Phase','fontname','times new roman','fontsize',12);

%% Phase Plate
% 4-floor phase plate
% ph1=ones((N+1)/2)*pi;
% ph2=ones((N-1)/2,(N+1)/2)*pi;
% ph3=ones((N+1)/2,(N-1)/2)*pi;
% ph4=ones((N-1)/2)*pi;
% phmask1=[0.5*ph1 0*ph3;ph2 1.5*ph4]; 
% 镜像phmask1=[0*ph3 0.5*ph1;1.5*ph4 ph2];
%无相位操控时，相位板变为1001*1001光阑 phmask1=[0*ph1 0*ph3;0*ph2 0*ph4];

% 8-floor phase plate
% ph1=ones((N+1)/2)*0;
% for i =1:1:(N+1)/2
%     for j = 1:1:(N+1)/2
%         if i>j
%             ph1(i,j)=pi*3/2;
%         else
%             ph1(i,j)=pi;
%         end
%     end
% end
% ph2=ones((N-1)/2,(N+1)/2)*0;
% for i = 1:1:(N-1)/2
%     for j = 1:1:(N+1)/2
%         if (N+1)/2-j>i-1
%             ph2(i,j)=0;
%         else
%             ph2(i,j)=pi/2;
%         end
%     end
% end
% ph3=ones((N+1)/2,(N-1)/2)*0;
% for i =1:1:(N+1)/2
%     for j = 1:1:(N-1)/2
%         if (N+1)/2-j>i-1
%             ph3(i,j)=pi/2;
%         else
%             ph3(i,j)=0;
%         end
%     end
% end
% ph4=ones((N-1)/2)*0;
% for i =1:1:(N-1)/2
%     for j = 1:1:(N-1)/2
%         if i>j
%             ph4(i,j)=pi;
%         else
%             ph4(i,j)=pi*3/2;
%         end
%     end
% end
% phmask1=[ph1 ph3;ph2 ph4];  % 八台阶相位板已表述为phmask1

% 12-floor phase plate
ph1=ones((N+1)/2)*pi;
for i = 1:1:(N+1)/2
    for j = 1:1:(N+1)/2
        if (N+1)/2-i>((N+1)/2-j)*3^0.5
            ph1(i,j)=1.5*pi;
        elseif ((N+1)/2-i)*3^0.5<(N+1)/2-j
            ph1(i,j)=0.5*pi;
        else
            ph1(i,j) =0;
        end
    end
end
ph2=ones((N-1)/2,(N+1)/2)*pi;
for i = 1:1:(N-1)/2
    for j = 1:1:(N+1)/2
        if (N+1)/2-j>3^0.5*i
            ph2(i,j)=pi;
        elseif (N+1)/2-j<i/3^0.5
            ph2(i,j)= 0;
        else
            ph2(i,j) = 1.5*pi;
        end
    end
end
ph3=ones((N+1)/2,(N-1)/2)*pi;
for i = 1:1:(N+1)/2
    for j = 1:1:(N-1)/2
        if (N+1)/2-i+1 < j/3^0.5
            ph3(i,j)=0;
        elseif (N+1)/2-i < j*3^0.5
            ph3(i,j)=pi/2;
        else
            ph3(i,j) = pi;
        end
    end
end
ph4=ones((N-1)/2)*pi;
for i = 1:1:(N-1)/2
    for j = 1:1:(N-1)/2
        if i>j*3^0.5
            ph4(i,j)=pi*0.5;
        elseif i>j/3^0.5
            ph4(i,j)=pi;
        else
            ph4(i,j) = pi*1.5;
        end
    end
end
phmask1=[ph1 ph3;ph2 ph4];  % 十二台阶相位板已表述为phmask1

% 相位板信息
figure;
imagesc(phmask1)
axis image; colorbar;
title('Phase Mask 1','fontname','times new roman','fontsize',12);

% 透镜聚焦过程
f=20;   % focus
T=pi/lambda1/(f)*(Y.^2+X.^2); % lens phase
U=U0.*exp(-1i*phmask1);
out=diffraction_tool(lambda1,U.*exp(-1i*T),x,N,f);
out = smoothdata(out);
out = smoothdata(out,2);
I=abs(out).^2;

% Plotting/Visualisation process
figure;
imagesc(I);
axis image;colorbar;
title('Seed Laser Shaping Intensity 1 Original','fontname','times new roman','fontsize',12);
figure;
imagesc([-5,5],[-5,5],angle(out));
axis image;colorbar;
title('Seed Laser Shaping Phase 1 Original','fontname','times new roman','fontsize',12);

ct = 0.34;  % 中心区域大小的分布，取决于波长lambda,透镜焦距f,光斑尺寸width
out_c = out(ct*(N-1):(1-ct)*(N-1),ct*(N-1):(1-ct)*(N-1));
I_c = abs(out_c).^2/max(I,[],"all");  % 中心区域的强度分布
phase_c = angle(out_c);  % 中心区域的相位分布
figure;       
imagesc([0 width*10^3],[0 width*10^3],I_c);
colorbar;axis image;xlabel('x(mm)');ylabel('y(mm)');
title('Seed Laser Shaping Central Intensity 1','fontname','times new roman','fontsize',12);
figure;       
imagesc([0 width*10^3],[0 width*10^3],phase_c);
colorbar;axis image;xlabel('x(mm)');ylabel('y(mm)');
title('Seed Laser Shaping Central Phase 1','fontname','times new roman','fontsize',12);
