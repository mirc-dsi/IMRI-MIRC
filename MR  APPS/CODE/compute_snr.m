  function snr_im=compute_snr(In)
%  In=rand(128,128,10,6);
In=reshape(In,size(In,1)*size(In,2),size(In,3),size(In,4));
for sl=2:size(In,2)-2
     for dir=1:size(In,3)
         roi_input(:,sl,dir)=In(:,sl,dir)>0.2;
% figure; imagesc(roi_input); colormap(gray); colorbar;
roi_bg(:,sl,dir)=In(:,sl,dir)-roi_input(:,sl,dir);
% figure; imagesc(roi_bg); colormap(gray); colorbar;
roi_bg_intensity(sl,dir)=mean(roi_bg(:,sl,dir));
roi_intensity(sl,dir)=mean(roi_input(:,sl,dir));
 noise_std(sl,dir)=std(roi_bg(:,sl,dir)); 
 snr_im=(20*log10(roi_intensity./noise_std));
 if(isnan(snr_im))
      snr_im=0;
  end
%       
     end
 end
  figure;imagesc(snr_im);colormap(jet);c = colorbar;
c.Label.String = 'SNR (in dB)';