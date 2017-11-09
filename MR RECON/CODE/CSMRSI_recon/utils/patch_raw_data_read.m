%% Reconstructs mrecon in line with UMN data convention
addpath(genpath('.'));
CSrecon_invivo=mrecon;
%% Convert mrecon back to kx,ky,t channel by channel - raw_fid_data(kx,ky,ch,t)
CSrecon_invivo_kxkyt=zeros(size(CSrecon_invivo));
spectra_CSrecon=zeros(size(CSrecon_invivo));
nch=size(CSrecon_invivo,3);
for ch=1:nch
    CSrecon_invivo_kxkyt(:,:,ch,:)=reconstruct_kspace(squeeze(CSrecon_invivo(:,:,ch,:)));
end
%% Dump Ryan's code here to reconstruct in the manner that they like

spatial_fid=fftshift(fft(fft(fftshift(CSrecon_invivo_kxkyt),[],1),[],2)); %Note that the 1 and 2 represent the dimensions of raw_data that are kx and ky. I've inserted 1 and 2 assuming you've transposed the raw data to be raw_data(kx,ky,ch,time)

for ch=1:16
    for x=1:16
        for y=1:16
            spectra_CSrecon(x,y,ch,:)=fftshift(fft(squeeze(spatial_fid(x,y,ch,:))));
        end
    end
end

%Plotting:
%%
spectra_CSrecon_ch3=squeeze(spectra_CSrecon(:,:,3,:));
%figure;plot(real(squeeze(spectra_CSrecon_ch3(7,11,:))));axis tight;

spectra_CSrecon_ch3_roi=squeeze(spectra_CSrecon_ch3(:,:,500:1000));
%figure;plot(real(squeeze(spectra_CSrecon_ch3_roi(7,11,:))));axis tight;

display_spectra_mosaic(spectra_CSrecon_ch3_roi(6:8,10:11,100:400), spectra_CSrecon_ch3_roi(6:8,10:11,100:400));