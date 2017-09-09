function [T,Tx,Ty,Tz]=get_torque(coords,xi,zi,B_field_x,B_field_y)
%% Torque Calculation

B_field_z=zeros(size(B_field_x));
B = cat(2,B_field_x(:),B_field_y(:),B_field_z(:));

coord_T=coords';
coord_T=coord_T(1:length(B),:);
var=zeros(length(coord_T),1);
% coil(:,1)=coord_T(:,1);
% coil(:,2)=var;
% coil(:,3)=coord_T(:,2);
coil=[coord_T var];

T=cross(coil,B);

% Extract each direction torque
T_x=(T(:,1));
T_y=(T(:,2));
T_z=(T(:,3));
% 
% % Reshape the torque variables
Tx=reshape(T_x,[length(B_field_x),length(B_field_x)]);
Ty=reshape(T_y,[length(B_field_y),length(B_field_y)]);
Tz=reshape(T_z,[length(B_field_z),length(B_field_z)]);

 coordxx=reshape(coords(1,1:4096),[length(B_field_x),length(B_field_x)]);
 coordzz=reshape(coords(2,1:4096),[length(B_field_z),length(B_field_z)]);
%% Display
figure(60); quiver(coordxx,coordzz,Tx,Tz,'Linewidth',5,'Color',[1 0 0]);hold all;
% figure(60); quiver3(xi,xi',zi,Tx,Ty,Tz,'Linewidth',1,'Color',[1 0 0]);hold all;
figure(60); quiver3(xi,xi',zi,B_field_x,B_field_y,B_field_z,'Linewidth',1,'Color',[ 1 0 1]);hold all;
figure(60); figure(60); plot(coords(1,:), coords(2,:),'k*');hold all
xlabel('x'); ylabel('y'); zlabel('z');title('Torque');legend('Torque','Gradient magnetic field','Coil pattern');
axis ([-0.2 0.2 -0.2 0.2 -0.2 0.2]);
end
