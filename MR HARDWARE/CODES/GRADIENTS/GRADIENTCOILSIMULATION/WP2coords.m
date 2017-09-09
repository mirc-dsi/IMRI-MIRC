function [coords] = WP2coords(C,disp)
%% This function takes in cropped wire pattern and provides their x and z co-ordinates
% Input C - contour matrix 
% Output coords - N x 2 matrix (:,1) - x; (:,2) - y

ind =1;
coords=[];
while (ind < length(C))
    num_coords = squeeze(C(2,ind)); 
    coords = [coords squeeze(C(:,ind+1:ind+num_coords))];
    ind = ind + num_coords +1;
end

%% Display
if(disp==1)
figure(60); plot(coords(1,:), coords(2,:),'k*');hold all
end
