%%
function [Ic,C,Jx,Gxa,xi,zi,cutting,Gza,psi]=get_winding_pattern(Gfp,Gcd,Fov)
 
%% Edited by Sairam Geethanath
% Improved readability of the code by variable name change, structuring
% according to each operation for the two axes
% Converted to a function useful to incorporate into an optimization
% framework
 
%% Inputs
display =1;

%% Constant and target field
x=linspace(-Fov.FOVx,Fov.FOVx,Fov.N); %create linear variations in x
z=linspace(-Fov.FOVz,Fov.FOVz,Fov.N);% create linear variations in z
delta_z=abs(z(2)-z(1));
delta_x = abs(x(2) - x(1));
y=0.01e-2;
a=4e-2; % distance from y=0 to two current plane in y-direction as the field is calc in x
[xi,zi]=meshgrid(x,z); %create a repmat in these two directions - important quantities
 
 
 
%% Prepare the boundaries for the target field calculation
% Linearity space constraints applied
x_linlim=Gfp.x_linlim-eps;
z_linlim=Gfp.z_linlim-eps;
 
xdim=x(x>x_linlim); xdim=xdim(1);%Fix it to the value just greater than the limit in x-dim space
zdim=z(z>z_linlim);zdim=zdim(1);
 
% X Gradient  dimensions space constraints applied
Gxdim=x(x>Gcd.G_dimx); Gxdim=Gxdim(1); %Fix it to the value just greater than the Gradient coil dimensions
Gzdim=z(z>Gcd.G_dimz);Gzdim=Gzdim(1);
 
%% Calculate the target field distribution over the ROI including reversal - generate the xgrad
P0 = zeros(1,length(x(x<-Gxdim)));
P1 = ((Gfp.GxA*-xdim)-xdim/(Gxdim-xdim)*Gfp.GxA*(xdim+x(x>=-Gxdim & x<=-x_linlim))); %Negative dip from 0 to -Gmax
P2 = Gfp.GxA*x(x>-x_linlim & x<x_linlim);%Ramp
P3 = ((Gfp.GxA*xdim)-xdim/(Gxdim-xdim)*Gfp.GxA*(x(x>=x_linlim & x<=Gxdim)-xdim));% Negative dip from +Gmax to 0
P4 = zeros(1,length(x(x>Gxdim)));
Bz_profile = [P0 P1 P2 P3 P4 ]; %plot(Bz_profile); 
Bz=ones(length(z),1)*Bz_profile;
 
%% Prune Bz to fit zlimits and G_dimz limits; make sure the fields are cancelled in z with opposing fields
Bz(zi>z_linlim & zi<Gcd.G_dimz)=-zdim/(Gzdim-zdim)*Bz(zi>z_linlim & zi<Gcd.G_dimz); %Space outside the linear variation but inside the gradient coil dimension
Bz(zi<-z_linlim & zi>-Gcd.G_dimz)=-zdim/(Gzdim-zdim)*Bz(zi<-z_linlim & zi>-Gcd.G_dimz);% Similarly on the other side - opposing balancing field for these regions :)
Bz(zi<-Gcd.G_dimz)=0; %Everything outside the gradient coil dimensions - Set values outside to 0
Bz(zi>Gcd.G_dimz)=0; % Everything outside the gradient coil dimensions -Set values outside to 0
 
 
%% compute fourier transform of target field to determine target current distribution
 
Bk=fftshift(fft2(fftshift(Bz)));
% Define points in fourier domain
Nx=length(x);nx=-Nx/2:(Nx/2-1);
Nz=length(z);nz=-Nz/2:(Nz/2-1);
kx1=nx*pi/Fov.FOVx;
kz1=nz*pi/Fov.FOVz;
[kx,kz]=meshgrid(kx1,kz1);
 
 
%% Apodize (filter) the freq space of target field to remove high spatial
% freq component resulting physically realizable current density
 
z0=.010;
x0=.010;
Bk=Bk.*exp(-2*(x0^2*kx.^2+z0^2*kz.^2)); %Apodization filter -gaussian filter
TargetB=real(ifftshift(ifft2(ifftshift(Bk)))); %Smoothened target field - more practical to achieve
[Gx,Gz]=gradient(TargetB,delta_x,delta_z); %?
 
%% Downsample the entire problem by predefined factors
% n=size(TargetB,2)/64;
% m=size(TargetB,1)/64;
x1=downsample(x,Fov.n);
z1=downsample(z,Fov.m);
Target_Bds=downsample(downsample(TargetB',Fov.n)',Fov.m);
Gx1=downsample(downsample(Gx',Fov.n)',Fov.m);
 
%%
if(display==1)
            % Apodized Target Field
            figure(1);surf(x1*1000,z1*1000,Target_Bds);title('Apodized Target Field');xlabel('x (mm)');ylabel('z (mm)');
 
            %Line profile of Target field
            figure(2);subplot(311);plot(x*1000,Bz(size(Bz,1)/2,:),'Linewidth',2)
            hold on;plot(x*1000,TargetB(size(Bz,1)/2,:),'--','Linewidth',2);xlabel('x (mm)');ylabel('B_z (T)');
 
            % Gradient plots of original and apodized fields
            subplot(312);plot((x(1:(length(x)-1))+abs(x(2)-x(1))/2)*1000,....
                diff(TargetB(size(Bz,1)/2,:))/abs(x(2)-x(1)),....
                '--','Linewidth',2);ylabel('G_x (T/m)');xlabel('x (mm)');
 
            hold on;plot((x(1:(length(x)-1))+abs(x(2)-....
                x(1))/2)*1000,diff(Bz(size(Bz,1)/2,:))/abs(x(2)-....
            x(1)),'Linewidth',2);ylabel('G_x (T/m)');xlabel('x (mm)');
 
            subplot(313);plot(z*1000,Bz(:,size(Bz,2)/2+1),'Linewidth',2);
            hold on;plot(z*1000,TargetB(:,size(Bz,2)/2+1),'--','Linewidth',2);xlabel('z (mm)');ylabel('B_z (T) - cross');
 
            figure(3);surf(x1*1000,z1*1000,Gx1);
            % title('Apodized Target Gradient');xlabel('x (mm)');ylabel('z (mm)')
            plotsize=3.5e-2;
            surf(z(z>-plotsize & z<plotsize)*1000,x(x>-plotsize & ...
            x<plotsize)*1000,Gx(x>-plotsize & x<plotsize,z>....
            -plotsize & z<plotsize)*10000/100);ylabel('z (mm)','FontSize',14);
 
 
            xlabel('x(mm)','FontSize',14);zlabel('G_x (G/cm/A)','FontSize',14);title('Apodized Target Gradient','FontSize',14);
            text(-20,-20,min(min(Gx(x>-plotsize & x<plotsize,z>-plotsize & z<plotsize)*10000/100)),['Min/Max =' ....
            num2str(min(min(Gx(x>-plotsize & x<plotsize,z>-plotsize & z<plotsize)))/max(max(Gx(x>....
            -plotsize & x<plotsize,z>-plotsize & z<plotsize))),'%6.3f')],'FontSize',14);
 
end
%% Use FT of field to generate the FT of current density
jxk=Bk./(-Gfp.u0.*exp(-a.*sqrt(kx.^2+kz.^2)).*sinh(y.*sqrt(kx.^2+kz.^2))-eps);%Notation is a problem here - Uppercase
 
%Take inverse FT of jx to find current density Jx
Jx=ifftshift(ifft2(ifftshift(jxk)));
 
%% Find stream function using current density
psi=-cumtrapz(Jx)*delta_z; %Need to read this from thess tomorrow - SG TODO/AK - TODO - All the magic is happening here :)
psi=psi-ones(length(z),1)*(psi(length(z),:)+psi((1),:))/2;% Subtracts a Bz profile - why?
figure(5);imagesc(x*100,z*100,psi);axis image;axis xy;colorbar;title('Stream function'); axis([-30 30 -30 30]);
[Gxa,Gza]=gradient(psi,delta_x,delta_z);
%Plotting
if(display ==1)
        figure(4);
        subplot(121);imagesc(x*100,z*100,Jx);xlabel('x (cm)');
        ylabel('z (cm)');title('x current density (A/m)');axis image;axis xy;colorbar
        subplot(122);imagesc(x*100,z*100,Gxa);xlabel('x (cm)');
        ylabel('z (cm)');title('z current density (A/m)');
        axis image;axis xy;colorbar
end
%% Generate cutting current pattern from stream function
 
Num_contours=Gfp.turns*5-1;
contours=linspace(-max(max(psi)),max(max(psi)),Num_contours-5);
contours1=contours(2:(length(contours)-1));%contours is the var, contour is the function
 
% if(display ==1) - Minimum display required to make this function work at
% this time - SG
        figure(6);cutting=contour(x,z,psi,contours1,'LineWidth',2,'linecolor','b');axis image;grid on;
        axis([-0.114 0.114 -0.20 0.20]);
        contours2=contours(2:length(contours))-abs(contours(2)-contours(1))/2;
        hold on;
        C=contour(x,z,psi,contours2,'LineStyle',':','LineWidth',1,'linecolor','r');%??
        xlabel('x (cm)','FontSize',14);ylabel('z (cm)','FontSize',14);
        title('Cutting Pattern','FontSize',14);
        set(gca,'FontSize',14);
        Ic=2*max(max(psi))/(2*Gfp.turns);
        legend('Cutting','Modeling','location','EastOutside');
        
        %% Saving variables
        save('C','C','Ic');
        save('cutting','cutting');

%% save the pattern
save('Jx')
end 