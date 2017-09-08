

%% Program to denoise given image using local PCA method
% Dated: 15-5-2017
% Author: Seema S Bhat
% Modified by: Sairam Geethanath, version history v00
% v00 - compute_overlap_blocks - took only the point for averaging;
% computed PCA correctly, weighted the 6 directions correctly
%
% please note: each slice has 3 bvalues and 6 directions.
% So one slice will have 1 b0 value, 1000 balue with 6 directions and 2000
% bvalue with 6 directions

display =1;

%% Reading data - configure options
i =1; 
mr=0;%if you want to read mat files - activates if this is set to 1
dw=0;%If you want to write dicom files - activates if this is set to 1
dr=1;% if you want to read dicom files - - activates if this is set to 1
slice_num =10;
dir_num =6;

%% Case for reading mat files
if(mr==1)
         load('data_read_slice10.mat');
%         b_2000=b_values(71:end); 
%         dir_2000=Dir1(:,71:end);
        Im_2000=im_data(:,:,71:end); % all slice having b2000 ( 10 slices * 6 directions)
%         b_0=b_values(1:10);
%         Im_0=im_data(:,:,1:10);
        In_im=zeros(128,128,10,6); %Hardcoded here as well
i=1;
    for direc =1:6%number of directions - need this to be a variable
        In_im(:,:,:,direc) = squeeze(Im_2000(:,:,i:i+9));
         i = i+10;
    end
end

%% Case for writing dicom files  
% In_im=zeros(128,128,10,6);
 if(dw ==1)
              mkdir('Dicomfiles'); cdir = pwd;cd('Dicomfiles');  
     for slice =1:size(In_im,3)
                 if(slice < 10)
                         slice_str = ['0',num2str(slice)];
                          else
                         slice_str = num2str(slice);
                   end
          
                 for direc = 1:size(In_im,4);
                                 if(direc < 10)
                                     direc_str = ['0',num2str(direc)];
                                 else
                                     direc_str = num2str(direc);
                                 end
                     dicomwrite(uint16(squeeze(In_im(:,:,slice,direc))),['Im_slice' ,slice_str,'_direc' , direc_str, '.dcm']');
        
                 end
     end
         cd(cdir);
 end
 
        
         

%% Case for reading dicom files
if(dr ==1)
         dirname=uigetdir('');files = dir(dirname);
         S = (dicomread(fullfile(dirname,files(3).name)));
         In_im =  zeros(size(S,1), size(S,2), length(files) -2);
         for k= 3:length(files)
             fname = fullfile(dirname, files(k).name);
             In_im(:,:,k-2) =dicomread(fname); %k =1 , 2 same slice different directions, reqd:  3rd dimension is slice 4th is direction
          
         end
         % Reshape In_im according to convention
         In_im = reshape(In_im, [size(S,1), size(S,2), dir_num, slice_num,]);
         
end
%%
 In_im = permute(In_im, [1 2 4 3]);
In_im = double(In_im);
In_im = In_im./max(abs(In_im(:)));
psize = [3,3,3,6];
figure,squeeze(imagesc(In_im(:,:,2,2)));
%%

% Compute PCA denoised image

%
Denoised_Val = zeros(size(In_im));
tic;
for i = 2:126
    for j = 2:126
        for k = 2:8
                      if(squeeze(In_im(i,j,k,1)) > 0.15) %noise threshold to speed up
                           Denoised_Val(i,j,k,:)=compute_overlap_blocks(i,j,k,psize,In_im);
                      else
                           Denoised_Val(i,j,k,:) = zeros(1,6);
                      end
  
        end
    end
         disp([i]);
end
toc;
%% Display
 im=squeeze(In_im(:,:,5,1));
% figure,imagesc(im);colormap(gray);
% roi_in=roipoly();
% roi_i=im.*roi_in;
% figure,imagesc(roi_i);colomap(gray);
% roi_bg=im-roi_i;
% cnr=mean(roi_i(:))-mean(roi_bg(:))./std(roi_bg(:));
im2=im>0.2;
figure,imagesc(im2),colormap(gray);
roi_bg1=im-im2;
figure,imagesc(roi_bg1),colormap(gray);

snr1=mean(im2(:))./std(roi_bg1(:));
if(display==1)
slice = 3;dir =1;
SNR_orig=compute_snr(In_im);
 CNR_orig=compute_cnr(In_im);
 
for i=1:size(In_im,4)
     Denoised_Val(:,:,i)=medfilt2(Denoised_Val(:,:,i));
 end
SNR_denoised=compute_snr(Denoised_Val);
CNR_denoised=compute_cnr(Denoised_Val);

Im_orig=In_im(:,:,:,dir);Im_orig = Im_orig(:,:);
Im_denoised = Denoised_Val(:,:,:,dir);Im_denoised = Im_denoised(:,:);
M=medfilt2(Im_denoised,[5 5]);
figure(201); imagesc(medfilt2(squeeze(Denoised_Val(:,:,3,3))));colormap(gray);color bar;
diff_map=imabsdiff((squeeze(In_im(:,:,5,1))),squeeze(Denoised_Val(:,:,5,1)));
figure(105); imagesc(diff_map);colormap(gray);color bar;
Im_test = cat(1, Im_orig, M);
figure(103); imagesc(Im_test);colormap(jet);color bar;
title('Denoising using local-PCA - version0');
 end
% %% threshold
 %%
 figure; imagesc(M);colormap(gray); colorbar;
