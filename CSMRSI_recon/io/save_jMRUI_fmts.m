function save_jMRUI_fmts(spectra_data,str_data2,fileaddress,pros)
% save_jMRUI_fmts(spectra_data,str_data2,fileaddress)
% addpath('C:\Users\sgeeth\Documents\Code\Kspace\CS_CSI_Ver4\utils');
if(nargin < 4)
    pros =0;
end
fid = fopen(fileaddress,'wt');

for g=1:20
    count=fprintf(fid,[str_data2{g} '\n']);
end


%--------------------------------------------------------------------------
%Print out the reconstructed values to the text file as reqd.
%--------------------------------------------------------------------------
h = waitbar(0,'Please wait...');
D =size(spectra_data);
Dest = D(1)*D(2);counter =0;

for n=1:D(1)
    for m=1:D(2)

        F = (squeeze(spectra_data(D(1)-n+1,m,:))); 
%% Change this back when you are doing normal stuff.
if(pros==0)
              H = ifft(ifftshift(F));  
              counter = counter + 1;
else
             H = ifft(ifftshift(F));  
             counter = counter + 1;
                       
end

%         subplot(211);plot(real(F),'r'); hold on;
%         subplot(212);plot(real(H),'r'); hold on;
        fprintf(fid,'Signal %d out of %d in file\n',counter,Dest);
        waitbar(counter/Dest,h,([num2str((counter*100/Dest),'%3.2f'),'%']));
        for s=1:D(3)
            fprintf(fid,'%-5.4E\t %5.4E\t %5.4E\t %5.4E\n',real(H(s)),imag(H(s)),real(F(s)),imag(F(s)) );
        end
    end
end
 close (h);
fclose(fid);



