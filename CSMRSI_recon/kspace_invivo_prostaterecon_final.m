%% Choose periodization mode for wavelet decomposition
%close all;
dwtmode('per');
addpath(genpath('.'));
clc;

%% Load data to be reconstructed and the mask

load nomove_1avg.mat; % t,ch,x,y % data provided on 05/10/2017 % already multiplied by weights
load mask;% provided on 05/10/2017
load yesmove_1avg.mat;
%% Changing matrix dimensions from t,ch,kx,ky to kx,ky,ch,t
%yesmove_1avg_ch = yesmove_1avg(:,3,:,:);
kspace_csi_data=permute(nomove_1avg,[3 4 2 1]); % Change matrix dimension according to convinience
kspace_csi_data = kspace_csi_data./(max(abs(kspace_csi_data(:)))); %normalise 

%% 
spectra = zeros(size(kspace_csi_data));
nch = size(kspace_csi_data,3);
for ch =1:nch
    
    spectra(:,:,ch,:) = reconstruct_spectra(squeeze(kspace_csi_data(:,:,ch,:)));%x,y,ch,f
    
end
spectra = spectra./ (max(abs(spectra(:))));
%% Variable Initialization

write_spectra =0;
D = [16 16 16 2048]; 
P =3;
mrecon=zeros(size(kspace_csi_data));
% Reconstruction parameters follow:
        maxIter= 8; % Number of ncg iterations (internal to the recon iter) was 8.
        xfmWeight =0.001;
        TVWeight =0.005; %0.005
        level = 4;
        wname = 'db4';
        
%% Undersample k-space
usamp= 0.2266; % based on mask provided on 05/10/2017 - Formula used: usamp=sum(mask(:))/numel(mask)
r = usamp;%radius of sampling
pdf = genPDF([D(1) D(2)],P,usamp,2,usamp,r);
disp(['Actual undersampling is ',num2str(sum(mask(:))/numel(mask))]);% another verification
figure;imagesc(mask);
mask = mask./pdf;   %Density compensation
figure;imagesc(mask);title('Density compensated mask');
sampling_mask=repmat(mask,[1 1 D(4)]); 

%% Channel-wise reconstruction
for ch =1:nch
%ch=3;    
    dnew=squeeze(kspace_csi_data(:,:,ch,:));
    kspace_us=dnew.*sampling_mask;
    csi_zfwdc = reconstruct_spectra(kspace_us);  %Zero filled with density compensation

% Normalization to aid in regularization parameters being constant for
% varying acceleration
%         disp(norm(abs(csi_zfwdc(:))));
        csi_zfwdc = csi_zfwdc/max(abs(csi_zfwdc(:))); 
        kspace_us = kspace_us/max(abs(csi_zfwdc(:)));
        
% Wavelet coeffs.

        [W,B] =get_wcoff(csi_zfwdc);
        for k=1:8 % Number of recon iterations was 8.
            mrec = ncg(W,B,sampling_mask,kspace_us,maxIter,TVWeight,xfmWeight,level,wname);
            figure(102);plot(abs(squeeze(mrec(9,9,:))));title('spectra from kspace'); %hold all;
            [W,B] =get_wcoff(mrec);
        end 
         mrecon(:,:,ch,:)=mrec;    
end

%%
mrecon = mrecon./ (max(abs(mrecon(:))));
%%
load yesmove_invivo.mat;
for ch=1:nch

    mrec_weighted=weights_yesmove(ch,1).*squeeze(mrecon(:,:,ch,:)); % Weights of in-vivo nomove is same as invivo yesmove
    mrecon_weighted(:,:,ch,:)=mrec_weighted;
end
%%
mrecon_weighted_sum = sum(mrecon_weighted,3);
%%
mrecon_weighted_sum = mrecon_weighted_sum./ (max(abs(mrecon_weighted_sum(:))));
%% Store only ROI

os= squeeze(spectra(:,:,3,:));
orig_ROI = os(:,:,1148:1448); % original spectrum cropped

rs= squeeze(mrecon(:,:,3,:));
recon_ROI = rs(:,:,1148:1448); % reconstructed spectrum cropped

ss= mrecon_weighted_sum(:,:,1148:1448); %channel weighted

%%
figure;plot(real(squeeze(orig_ROI(9,9,:))));axis tight;
figure;plot(real(squeeze(recon_ROI(9,9,:))));axis tight;
figure;plot(real(squeeze(ss(9,9,:))));axis tight;

%% RMSE calculation for roi

RMSE = get_RMSE(abs(orig_ROI(:)),abs(ss(:)));

%% plot all time points

figure;plot(real(squeeze(os(9,9,:))));axis tight;
figure;plot(real(squeeze(mrecon_weighted_sum(9,9,:))));axis tight;

%% plot absolute of roi
figure;plot(abs(squeeze(orig_ROI(9,9,:))));axis tight;
figure;plot(abs(squeeze(ss(9,9,:))));axis tight;