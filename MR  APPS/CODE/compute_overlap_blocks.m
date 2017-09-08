  function  Denoised_value=compute_overlap_blocks(i,j,q,psize,In_im)
%%Determine Overlapping blocks
%%
dbstop if error;
% denoised_patch=reshape(denoised_patch,psize);
% % Block_Size=size(denoised_patch);
% Px=psize(1);
% Py=psize(2);
% Pz=psize(3);
In_img_size = size(In_im);
Nx = In_img_size(1) -1;
Ny = In_img_size(2) - 1;

Nz=In_img_size(3) -1;
%% Determine the start and end points of the 3x3x3

            [sx,ex]=get_patch_coords(i,Nx);[xr] = check_win_length(sx,ex,Nx);
            [sy,ey]=get_patch_coords(j,Ny);[yr] = check_win_length(sy,ey,Ny);
            [sz,ez]=get_patch_coords(q,Nz);[zr] = check_win_length(sz,ez,Nz);
             patch=squeeze(In_im(xr,yr,zr,:));   %Create a 3x3x3 patch
            [theta,denoised_patch]=compute_parameters(patch);  
            k=1;
            denoised_patch = reshape(denoised_patch, psize);
            overlapping_block(k).patch =squeeze(denoised_patch(2,2,2,:));%this is the center voxel of interest
            overlapping_block(k). theta = theta;
%%
% %%Loop over the set of co-ordinates and find the overlapping patches
k=1;
for x=sx:ex
    for y=sy:ey
         for z=sz:ez
            k=k+1;
            [ax,bx]=get_patch_coords(x,Nx); [xr] = check_win_length(ax,bx,Nx);in = find(xr==i);%traces i 
            [ay,by]=get_patch_coords(y,Ny); [yr] = check_win_length(ay,by,Ny);jn = find(yr==j);%traces j 
            [az,bz]=get_patch_coords(z,Nz); [zr] = check_win_length(az,bz,Nz);kn = find(zr==q);%traces k 
            patch=squeeze(In_im(xr,yr,zr,:));   %Create a 3x3x3 patch
     
            if((~isnan(patch(:))) & (~isinf(patch(:))))
%                             disp(k);
                            [theta,denoised_patch_overlap]=compute_parameters(patch);  
                            %Find out Covarience,Noise threshold, Theta for every patch and denoise using inverse PCA
                            if(isnan(denoised_patch_overlap))
                                denoised_patch_overlap = zeros(size(denoised_patch_overlap));
                            end
                            denoised_patch_overlap = reshape(denoised_patch_overlap, psize);
                            overlapping_block(k).patch = squeeze(denoised_patch_overlap(in,jn,kn,:));
                            overlapping_block(k). theta = theta;
            end
           
        end
     end
end
%  No_overlap_block=k;          
 Denoised_value=weighted_avg(overlapping_block);
 