function [ TI ] = TI_comp( T1,TR,SE )
%computation of TI
switch SE
    
    case 1
        TI=T1*(log(2)-log(1+exp(-(TR/T1))));
    case 2
       TI=T1*(log(2)-log(1+exp(-((TR-TE_last)/T1))));
end
    


end

