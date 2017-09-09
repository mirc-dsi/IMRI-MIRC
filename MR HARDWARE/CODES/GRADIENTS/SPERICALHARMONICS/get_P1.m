function P=get_P1(m,x)
%P1=Pmm

    
    prod=1;
    for i=1:m
        prod=((2*i)-1).*prod;
    end
    
    P =prod*(1-(x.^2)).^((m)/2);

     if(m==0)
        P = 1;
    end
   
end