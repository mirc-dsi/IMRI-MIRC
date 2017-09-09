function [ B,B_field_x,B_field_y,B_field_z, Gx,p]=get_actual_field(Ic,C,u0)
%Input parameters
% u0=4*pi*10^-7; 
% load C ; %winding pattern 
 r=1; 
n=1; 
p=1; 
% Store the top and bottom coil arc information
% arclength=zeros(2,1); 
while n<(length(C)+1) 
points=C(2,n); % points of the arc
B=C(:,(n+1):(n+points)); %get locations of the points
% figure(101),plot(B);hold all;pause (0.1);
x1= B(1,1:(length(B)-1))'; % x-coordinate
y1= B(2,1:(length(B)-1))'; % y-coordinate
x2= B(1,2:length(B))';
y2= B(2,2:length(B))';
D=[x1 y1 x2 y2]; %concate and store all the points
arclength(p)=sum(sqrt((x1-x2).^2+(y1-y2).^2)); % find arc length
A1((n:(n+points-2))-2*(p-1),:)=D; % store the points in A1
% figure(101),plot(A1);hold all;pause (0.1);
n=n+points+1; 
p=p+1; 
end
ybot=-4e-2; % distance of the bottom coil from origin
Atop=[A1(:,1) ybot*ones(size(A1,1),1) A1(:,2) A1(:,3) ybot*ones(size(A1,1),1) A1(:,4) Ic*ones(size(A1,1),1)]; % store the top coil arc
Abot=[A1(:,1) -ybot*ones(size(A1,1),1) A1(:,2) A1(:,3) -ybot*ones(size(A1,1),1) A1(:,4) Ic*ones(size(A1,1),1)]; % store bottom coil information
% figure(101),plot(Abot);hold all;pause (0.1);
A=[Atop Abot]; %store the entire coil information in A 
% figure(101),plot(Atop);hold all;pause (0.1);


%% Here the calculation points are specified. In this example, the z directed magnetic field at the y = 0.1 mm target plane is calculated over x = ±3.5 cm and z = ±3.5 cm. 
% Solve over 
x=linspace(-3.5e-2,3.5e-2,64); %region over which magnetic field is calcuated
y=-.1e-3; 
z=linspace(-3.5e-2,3.5e-2,64); 
[X,Y,Z]=meshgrid(x,y,z); % generate the mesh
P=zeros(length(x),length(z),3); % store the mesh in P for all three direction X,Y,Z
P(:,:,1)=X; 
P(:,:,2)=Y; 
P(:,:,3)=Z; 
%Initialize actual field to zeros
B_field_x=zeros(size(x,2),size(z,2)); 
B_field_y=zeros(size(x,2),size(z,2)); 
B_field_z=zeros(size(x,2),size(z,2)); 

%% Calculate the field using arc information
for p=1:size(A,1) 

start=zeros(length(x),length(z),3); % initialize  the start points of the arc 
stop=zeros(length(x),length(z),3); % initialize the stop points of the arc
o=ones(length(x),length(z)); 
start(:,:,1)=o*A(p,1); % start points is x
start(:,:,2)=o*A(p,2); % start point in y
start(:,:,3)=o*A(p,3); % start point in z 
stop(:,:,1)=o*A(p,4); % stop points of x
stop(:,:,2)=o*A(p,5); % stop point in y 
stop(:,:,3)=o*A(p,6); % stop point in z 

I=A(p,7); %  get the current in this segment

%Calculation of dl
norm_PminStart=sqrt((P(:,:,1)-start(:,:,1)).^2+(P(:,:,2)-start(:,:,2)).^2+(P(:,:,3)-start(:,:,3)).^2);
norm_StopminStart=sqrt((stop(:,:,1)-start(:,:,1)).^2+(stop(:,:,2)-start(:,:,2)).^2+(stop(:,:,3)-start(:,:,3)).^2); 
norm_PminStop=sqrt((P(:,:,1)-stop(:,:,1)).^2+(P(:,:,2)-stop(:,:,2)).^2+(P(:,:,3)-stop(:,:,3)).^2);

% Calculate angle 
cos_alpha2=dot(stop-start,P-start,3)./(norm_StopminStart.*norm_PminStart); 
cos_alpha1=dot(stop-start,P-stop,3)./(norm_StopminStart.*norm_PminStop); 
rho=norm_PminStart.*sin(acos(cos_alpha2)); 

% Biot savart law
B_phi=u0*I./(4*pi.*rho).*(cos_alpha2-cos_alpha1); 
d=cross(P-start,stop-start,3); 
dx=d(:,:,1);
dy=d(:,:,2);
dz=d(:,:,3);
normd=zeros(size(d)); 
normd(:,:,1)=sqrt(dx.^2+dy.^2+dz.^2); 
normd(:,:,2)=sqrt(dx.^2+dy.^2+dz.^2); 
normd(:,:,3)=sqrt(dx.^2+dy.^2+dz.^2); 
direction=cross(P-start,stop-start,3)./normd; 
%Field calculation in x,y and z direction
B_field_x=B_field_x+B_phi.*direction(:,:,1); 
B_field_y=B_field_y+B_phi.*direction(:,:,2); 
B_field_z=B_field_z+B_phi.*direction(:,:,3); 
% 
% B=sqrt((B_field_x).^2+(B_field_y).^2+(B_field_z).^2);
% B=[B(:) B(:) B(:)];
B = cat(2,B_field_x(:),B_field_y(:),B_field_z(:));
end 

%% Display
figure(7);surf(z*1000,x*1000,B_field_z*10000);ylabel('x (mm)');xlabel('z (mm)');zlabel('B_z (G/A)'); 
[Gz,Gx]=gradient(B_field_z,abs(z(2)-z(1)),abs(x(2)-x(1))); title('Field calculated by Biot-savarts law');


figure(8);surf(x*1000,z*1000,rot90(Gx)*10000/100);ylabel('z (mm)','FontSize',14);xlabel('x (mm)','FontSize',14);zlabel('G_x (G/cm)','FontSize',14); 
set(gca,'FontSize',12); title('Gradient calculated by Biot-savarts law');

text(-20,-20,min(min(Gx*10000/100)),['Min/Max =' num2str(min(min(Gx))/max(max(Gx)),'%6.2f')],'FontSize',14);
end
