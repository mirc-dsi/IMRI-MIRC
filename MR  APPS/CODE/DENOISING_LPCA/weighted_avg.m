function Denoised_value=weighted_avg(overlapping_block)
 %% Function to calculate weighted average of denoised patches
 Val =zeros(size(overlapping_block(1).patch)); Theta=0;
 for k=1:length(overlapping_block)
     patch = overlapping_block(k).patch;
     theta = overlapping_block(k).theta;
     Val = Val + (patch.*theta);
     Theta = Theta + theta;
     
 end
 
 Denoised_value = Val./Theta;
 if(Denoised_value>0.5)
Denoised_value=0;
end
 
 
%  for i=1:No_overlap_block
%            compute_sum(i)=sum(overlapping_block,:).*theta;                      
%  end
%  Denoised_value=compute_sum./theta; 