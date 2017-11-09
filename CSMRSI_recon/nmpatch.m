%load nomove_1avg.mat;
load nomove_raw_invitro.mat;
%kspace_csi_data=permute(nomove_1avg,[3 4 2 1]);
kspace_csi_data=permute(no_move_rawfid,[3 4 2 1]);
spatial_fid_nm=fftshift(fft(fft(fftshift(kspace_csi_data),[],1),[],2)); %Note that the 1 and 2 represent the dimensions of raw_data that are kx and ky. I've inserted 1 and 2 assuming you've transposed the raw data to be raw_data(kx,ky,ch,time)
spectra_CSrecon_nm=zeros(size(kspace_csi_data));
for ch=1:16
    for x=1:16
        for y=1:16
            spectra_CSrecon_nm(x,y,ch,:)=fftshift(fft(squeeze(spatial_fid_nm(x,y,ch,:))));
        end
    end
end

%Plotting:

%figure;plot(real(squeeze(spectra_CSrecon_nm(7,11,3,:))));
nm_ch3=squeeze(spectra_CSrecon_nm(:,:,3,:));
figure;plot(real(squeeze(nm_ch3(7,11,:))));axis tight;

nm_ch3_roi=squeeze(nm_ch3(:,:,500:1000));
figure;plot(real(squeeze(nm_ch3_roi(7,11,:))));axis tight;

display_spectra_mosaic(nm_ch3_roi(6:8,10:11,100:400), nm_ch3_roi(6:8,10:11,100:400));