function out=diffraction_tool(Lambda,pupil,y,N,z)
t_s=y(2)-y(1);                            %瞳函数采样周期
f_s = 1/t_s;                              %采样频率
f_x = linspace(-f_s/2,f_s/2,N);           %频域坐标
[X1,Y1]=meshgrid(f_x, f_x);               %构建频域坐标
r1=sqrt(X1.^2+Y1.^2);                     %频域半径
H=exp(1i*2*pi*sqrt(1/Lambda^2-r1.^2)*z);  %数字传播相位
%%%数字传播技术中相关频谱参数设置（无须额外更改）%%%

%%%数字传播技术结合fft工具实际操作%%%
F=fft2(pupil);             %对瞳函数傅里叶变换
Fs=fftshift(F).*H;         %将频谱图中零频率成分移动至频谱图中心，并乘上传播相位
out=ifft2(ifftshift(Fs));  %傅里叶逆变换，频率域反变换到空间域
%%%数字传播技术结合fft工具实际操作%%%

%%% 展示衍射一定距离后的光强与相位 %%%
end
