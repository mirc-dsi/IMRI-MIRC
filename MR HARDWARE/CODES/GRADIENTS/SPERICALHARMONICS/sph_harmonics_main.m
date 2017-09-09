%%
%Date-06/02/2017
%Input:degree(l) and order(m)
%Output:Ylm (theta,phi);Spherical harmonics
%% Enter the Number of degree and order
L=input('Enter the degree-');
m=input('Enter the order-');
K = sqrt(factorial(L-m)./(factorial(L+m))); %Using equation 9 instead of equation 5 for calculation
% K1=sqrt(((2*L+1)/(4*pi)).*((factorial(L-m))/(factorial(L+m))));%equation 5

%% Generate the co-ordinates of a sphere - Unit sphere
% [x1, y1, z1]=sphere(5);
% plot3(x1,y1,z1,'ro-');
% surf(x1,y1,z1);
[data] = gen_sph_epts(50,50);

x2=data.cart.x;
y2=data.cart.y;
z2=data.cart.z; 

phis = data.sph.phi;
thetas = data.sph.theta;
r = data.sph.r;

xp = zeros(size(x2));
yp =xp; zp = xp;Y2 = xp;
ind =1;

%% Legendre polynomials 
%Initialize Y 
Y = zeros(length(thetas));
P_total = zeros(length(thetas),1);

  for th =1:length(thetas) % BUG 2
      
       theta = thetas(th) - pi/2; %This offset provides negative values of cos(x) and is reqd for spanning the sphere
        P_total(th) = get_Plm(L,m,theta);

        for ph = 1: length(phis)
                  phi= phis(ph); %BUG 3 here - check computation of P_total
                   
%                          K1=sqrt(((2*L+1)/(4*pi)).*((factorial(L-m))/(factorial(L+m))));%equation 5
                            if m>0
                               Y(th,ph)=sqrt(2).*K.*cos(abs(m)*phi).*P_total(th);
%                                Y(th,ph)=sqrt(2).*get_K(l,m).*cos(m*phi).*P_total(th);
                            elseif m==0
                                Y(th,ph)=K.*P_total(th);
                            else 
                                Y(th,ph)=sqrt(2)*K*sin(abs(m)*phi).*P_total(th);
                            end
                           
                            [xp(ind),yp(ind),zp(ind)] = sph2cart(phi, theta +pi/2, r);%The offset of pi/2 is removed while calculating Cartesian co-ords
                            Y2(ind) = Y(th,ph);
                            ind = ind +1;
                           
        end
         %% Display section here
                      
        
        if(mod(th,100)==0)
            disp(th);
        end
        
        
        
  end
%% Display 
figure(1);scatter3(xp,yp,zp,1000,(Y2),'filled');title(['Y',num2str(L),num2str(m)]);hold on;
xlabel('Xaxis/m');ylabel('Yaxis/m');zlabel('Zaxis/m');
colorbar;colormap('jet');caxis([-1 1]);drawnow;
        