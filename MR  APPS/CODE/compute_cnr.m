%% Function to compute contrast to noise ratio
 function CNR=compute_cnr(In_im)
%  In_im=rand(128,128,10,6);
In_im=reshape(In_im,size(In_im,1)*size(In_im,2),size(In_im,3),size(In_im,4));

for sl=1:size(In_im,2)-2
     for dir=1:size(In_im,3)
roi_input(:,sl,dir)=In_im(:,sl,dir)>0.2;
roi_bg(:,sl,dir)=In_im(:,sl,dir)-roi_input(:,sl,dir);
roi_bg_intensity(sl,dir)=mean(roi_bg(:,sl,dir));
roi_intensity(sl,dir)=mean(roi_input(:,sl,dir));
roi_std=std(roi_bg(:,sl,dir));
 disp([roi_std]);
CNR=(roi_intensity-roi_bg_intensity)./roi_std;
 if(isnan(CNR))
      CNR=0;
  end
     end
end
 figure;imagesc(CNR);colormap(jet);s = colorbar;
s.Label.String = 'CNR';