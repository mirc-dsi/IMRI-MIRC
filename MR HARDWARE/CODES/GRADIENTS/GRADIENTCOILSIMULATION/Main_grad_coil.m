%%Modified John carl Bosshard thesis code
%Date:15-06-2017

%Gradient field parameters
Gfp.u0=4*pi*10e-7;% constant  permeability % u0 = Gfp.u0;
GxA=.00734; %G/cm Target field 
Gfp.GxA=GxA/10000*100; %T/m
Gfp.x_linlim=8.4e-2;% Linear field
Gfp.z_linlim=8.4e-2; % Beyond these regions the field starts returning to zero so that area under curve remains zero
Gfp.turns=16;% number of counters used to generate discrete current patterns
 
%Gradient coil dimensions in meters
Gcd.G_dimx=10e-2;
Gcd.G_dimx=Gcd.G_dimx-eps;
Gcd.G_dimz=16.8e-2-eps;
 
%FOV parameters
Fov.FOVx=50e-2;% in meters  - FOVx
Fov.FOVz=50e-2;% in meters - FOVz
Fov.N = 64;% Number of points of measurement in each direction
Fov.n = 16; %Downsampling in x
Fov.m = 16; %Downsampling in z

%% This function takes target field as input and output is winding pattern
 [Ic,C,Jx,Gxa,xi,zi,cutting,Gza,psi]=get_winding_pattern(Gfp,Gcd,Fov);
%% Winding pattern and current will be input for this code and output is gradient field at x-direction
 [ B,B_field_x,B_field_y,B_field_z, Gx,p]=get_actual_field(Ic,C,Gfp.u0); 

 %% Torque calculation
 disp=1;
 [coords] = WP2coords(C,disp);
 %% %% Torque calculation
[T,Tx,Ty,Tz]=get_torque(coords,xi,zi,B_field_y,B_field_z);
