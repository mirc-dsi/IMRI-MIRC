%load yesmove_1avg.mat;
load yesmove_raw_invitro.mat;
%kspace_csi_data=permute(yesmove_1avg,[3 4 2 1]);
kspace_csi_data=permute(yesmoveraw,[3 4 2 1]);

spatial_fid_ym=fftshift(fft(fft(fftshift(kspace_csi_data),[],1),[],2)); %Note that the 1 and 2 represent the dimensions of raw_data that are kx and ky. I've inserted 1 and 2 assuming you've transposed the raw data to be raw_data(kx,ky,ch,time)
spectra_CSrecon_ym=zeros(size(kspace_csi_data));
for ch=1:16
    for x=1:16
        for y=1:16
            spectra_CSrecon_ym(x,y,ch,:)=fftshift(fft(squeeze(spatial_fid_ym(x,y,ch,:))));
        end
    end
end

%Plotting:

%figure;plot(real(squeeze(spectra_CSrecon_ym(7,11,3,:))));
ym_ch3=squeeze(spectra_CSrecon_ym(:,:,3,:));
figure;plot(real(squeeze(ym_ch3(7,11,:))));axis tight;

ym_ch3_roi=squeeze(ym_ch3(:,:,500:1000));
figure;plot(real(squeeze(ym_ch3_roi(7,11,:))));axis tight;

display_spectra_mosaic(ym_ch3_roi(6:8,10:11,100:400), ym_ch3_roi(6:8,10:11,100:400));