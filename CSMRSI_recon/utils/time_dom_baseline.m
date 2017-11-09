function [kspace]= time_dom_baseline(kspace,num_points)

for k=1:size(kspace,1)
    for m = 1:size(kspace,2)
        
        S = mean((squeeze(kspace(k,m,end-num_points:end))));
        kspace(k,m,:) = squeeze(kspace(k,m,:)) -S;
    end
end
