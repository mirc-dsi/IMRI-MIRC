function res = D3(image)



Dx = image([2:end,end],:,:) - image;
Dy = image(:,[2:end,end],:) - image;
Dz = image(:,:,[2:end,end]) - image;
%res = [sum(image(:))/sqrt(sx*sy); Dx(:);  Dy(:)]; 
res = cat(4,Dx,Dy,Dz);


