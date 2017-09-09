function [data] = gen_sph_epts(Nth,Nph)

 

%% Lets fix z and y, determine x

r = 1;%linspace(-1,1,Nx); %Number of points on the radial spoke - 1/2 on each side

theta = linspace(-pi/2,pi/2,Nth); 

phi = linspace(-pi,pi,Nph);

ind =1;

x = zeros(1, Nth.*Nph);

y =x; z=x;

 

    for th =1:length(theta)

        for ph = 1:length(phi)

            

            [x(ind), y(ind), z(ind)] = sph2cart(phi(ph), theta(th), r);

            ind = ind +1;

           

        end

    end

    

%%

data.cart.x = x;

data.cart.y =y;

data.cart.z =z;

 

data.sph.r =r;

data.sph.theta = theta;

data.sph.phi = phi;

%% Display for validation only

%  plot3(x,y,z,'ro');grid on; hold on;drawnow;

% figure(2); 
% 
% subplot(311); plot(x); 
% 
% subplot(312); plot(y);
% 
% subplot(313); plot(z);
