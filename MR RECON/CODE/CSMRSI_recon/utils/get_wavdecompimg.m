function[T]= get_wavdecompimg(coefs,sizes,Wave_Name)
Level_Anal = size(sizes,1) -2;
X = cell(1,Level_Anal);
%%
for k=1:1:Level_Anal
  
               [Y21,Y31,Y41]= detcoef2('all',real(coefs),sizes,k);  
               [Y22,Y32,Y42]= detcoef2('all',imag(coefs),sizes,k);     
               
               Y2 = Y21 + 1i*Y22;
               Y3 = Y31 + 1i*Y32;
               Y4 = Y41 + 1i*Y42;
               
               if(k==Level_Anal)
                          Y1 = appcoef2(real(coefs),sizes,Wave_Name,k)+ appcoef2(imag(coefs),sizes,Wave_Name,k);
               else
                          Y1 =zeros(size(Y3));
               end
               X{k} = [Y1 Y2; Y3 Y4];   
%                imagesc(abs(X{k}));       %  For debugging.   
 
end
%%  re-organize
for k=Level_Anal:-1:1
    if(k==Level_Anal)
    T = (X{k});
    T_old =T;
    else
        T = X{k};
        [M,N]=size(T);
        T(1:M/2,1:N/2) = T_old;
        T_old = T;
    end
   
end



%% Display the figure
 figure;imshow(abs(T),[]);colormap(gray);
