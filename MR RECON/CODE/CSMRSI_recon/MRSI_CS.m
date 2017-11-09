%% Main file for demonstration of compressed sensing based reconstruction of undersampled MRSI data
% r =0.3
% Tv =0.001
% XV =0.005
% Uses k-space true recon.

%% Choose periodization mode for wavelet decomposition
close all;
dwtmode('per');
addpath(genpath('.'));clc;
%load fid.mat; % fid of the .mat file given by CMRR i.e., input data
%load 2dcsi_yesmove_uncomb_full_2.mat;%loads fid data 
load nomove_uncomb_phasecor.mat
%% Construct and visualize 1X MRSI data
%fid2dmove = permute(fid2dmove,[3 4 2 1]);
d_nomove=permute(csi_nomove_uncom,[3 4 2 1]); %kx,ky,ch,data points
%Spectra = zeros(size(fid2dmove));
%Spectra_nomove = zeros(size(d_nomove));

% for ch=1:size(fid2dmove,3)
%     Spectra(:,:,ch,:) = fftn(squeeze(fid2dmove(:,:,ch,:)));
% end

% for ch=1:size(d_nomove,3)
%      Spectra_nomove(:,:,ch,:) = fftn(squeeze(d_nomove(:,:,ch,:)));
% end
%% Variable Initialization
write_spectra =0;
usamp = 0.5;%usamp factors of 0.5,0.33,0.25,0.2,0.1
%D = [16 16 32 2064];% Size of the data set
D = [14 14 16 2048];
P =10;

% Reconstruction parameters follow:
        maxIter= 8; % Number of ncg iterations (internal to the recon iter) was 8.
        xfmWeight =0.001;
        TVWeight =0.005;
        level = 4;
        wname = 'db4';
%% Data manipulation

%d=squeeze(fid); % To squeeze 1's from the original 7 Dimension 
%d=permute(fid2dmove,[3 4 2 1]); % rearrange the data in the order kx, ky, channels, data points respectively
mrecon=zeros(size(d_nomove));

%% Undersample k-space
pdf = genPDF([D(1) D(2)],P,usamp,2,usamp,0);%10x WAS 0.1 FOR ALL OTHER CASES%0.5,0.33,0.25,0.20,0.10
[mask,~,actpctg] = genSampling(pdf,30,3);%actpctg is the actual usamp achieved
disp(['Actual undersampling is ',num2str(sum(mask(:))/numel(mask))]);% another verification
figure;imagesc(mask);
mask = mask./pdf;   %Density compensation
sampling_mask=repmat(mask,[1 1 D(4)]); 

%% Channel-wise reconstruction
%for ch= 1:16
 ch=2;
    dnew=squeeze(d_nomove(:,:,ch,:));
    kspace_us=dnew.*sampling_mask;
    csi_zfwdc = reconstruct_spectra(kspace_us);  %Zero filled with density compensation

% Normalization to aid in regularization parameters being constant for
% varying acceleration
        kspace_us = kspace_us/max(abs(csi_zfwdc(:)));
        csi_zfwdc = csi_zfwdc/max(abs(csi_zfwdc(:))); % 



% Wavelet coeffs.

        [W,B] =get_wcoff(csi_zfwdc);
        for k=1:8 % Number of recon iterations was 8.
            mrec = ncg(W,B,sampling_mask,kspace_us,maxIter,TVWeight,xfmWeight,level,wname);
            [W,B] =get_wcoff(mrec);
        end 
         mrecon(:,:,ch,:)=mrec;    
%end


%% Calculate RMSE value        

% original data channel combined
for ch1=1:16
    d_ch_combined=squeeze(d_nomove(:,:,ch1,:));
end

% Reconstructed data channel combined
for ch2=1:16
    mrecon_ch_combined=squeeze(mrecon(:,:,ch2,:));
end





RMSE =  get_RMSE(abs(d_ch_combined),abs(mrecon_ch_combined));
disp(RMSE);



display_spectra_mosaic(d_ch_combined(4:10,4:10,1:400), mrecon_ch_combined(4:10,4:10,1:400));
display_spectra_mosaic(d_ch_combined(1:14,1:14,1:2048), mrecon_ch_combined(1:14,1:14,1:2048));
 
%% Applying svd to reconstructed noisy data
%o=permute(fid2dmove,[3 4 2 1]);
o=squeeze(Spectra(:,:,8,:));

o_rs=reshape(o,196,2048);

m=squeeze(mrecon(:,:,8,:)); % consider only 8th channel reconstructed data
m_rs=reshape(m,196,2048); 
figure;imagesc(abs(m_rs)); title('Reconstructed noisy data');
figure;imagesc(abs(o_rs)); title('original data');
figure;

subplot(4,1,1); plot(abs(o_rs(100,:))); title('original data');

subplot(4,1,2); plot(abs(m_rs(100,:))); title('Reconstructed noisy data');

%%

%[U,S,V] = svd(m_rs); %P=U*S*V'


%% Visualise S (diagonal elements) to set threshold
figure;imagesc(S);caxis([0 10]); title('visualise S to set threshold');


%%

[U,S,V] = svd(m_rs);
t1=13.6;%13 out of 196

S(S<t1)=0;
m_rs_thresholded_1=U*S*V';
figure;imagesc(abs(m_rs_thresholded_1)); title('Thresholded data-1');
subplot(4,1,3); plot(abs(m_rs_thresholded_1(100,:))); title('Thresholded data-1');


%%


[U,S,V] = svd(m_rs);
t2=15; % 7 out of 196 elements
S(S<t2)=0;
m_rs_thresholded_2=U*S*V';
figure;imagesc(abs(m_rs_thresholded_2)); title('Thresholded data-2');
subplot(4,1,4);plot(abs(m_rs_thresholded_2(100,:))); title('Thresholded data-2');

%% Calculate difference image

%diff=P-P_thresholded;
diff=m_rs-m_rs_thresholded;
figure;imagesc(abs(diff)); title('Difference image');




% %% 
% % display_spectra_mosaic(spectra);
% %% Write truth file.
% if(write_spectra ==1)
%     [filename,pathname]=uiputfile('C:\Users\sgeeth\Documents\Data\CS_CSI\For_paper\Processed_data\*.txt','Save as true jmrui file');
%     fileaddress = fullfile(pathname,filename);
%     save_jMRUI_fmts(spectra,str_data2,fileaddress);
% end
% %% Check grid matching - added this part for visualization - Spectrum of interest is in the first 400 points.
% display_spectra_mosaic(spectra(4:10,4:10,1:400), m1(4:10,4:10,1:400));
% % display_spectra_mosaic(spectra(1:16,1:16,1:400), m1(1:16,1:16,1:400));
% 
% %% Check voxel matching - Spectrum of interest is in the first 400 points.
% figure;
% subplot(211);
% plot(squeeze(abs(spectra(8,8,1:400))));hold on;
% plot(squeeze(abs(m1(8,8,1:400))),'r'); 
% 
% 
% subplot(212);
% plot(squeeze(abs(spectra(1,1,1:400))));hold on;
% plot(squeeze(abs(m1(1,1,1:400))),'r');
% drawnow;
% 
% 
% %% Write reconstructed file.
% [filename,pathname]=uiputfile('\*.txt','Save as jmrui file');
% if(filename ~= 0)
% fileaddress = fullfile(pathname,filename);
% save_jMRUI_fmts(m1,str_data2,fileaddress);
% end