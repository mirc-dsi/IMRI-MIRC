%% File to display spectra mosaic 
addpath(genpath('.'));
dwtmode('per');
clc;
%% Load full data and reconstructed data
load fid_4d.mat                     % full data [5D]
% load fid_recog.mat                % Reconstructed data [5D]    
D = [16 16 32 2064];
%% Reduce dimension of loaded data for compatibility [dispaly_spectra_mosaic works with 3D variables as inputs]

    for ch=1:32
        fid_sq=squeeze(d(:,:,ch,:));%ws_raw_sq=squeeze(ws_raw(:,y,:,ch,:));
    end

spectra = reconstruct_spectra(fid_sq);

    for ch=1:32
        mrecon_sq=squeeze(mrecon(:,:,ch,:));%mrecon_sq=squeeze(mrecon_full(:,y,:,ch,:));
    end

%% Display Spectra mosaic to compare original and reconstructed data
display_spectra_mosaic(spectra(1:16,1:16,:), mrecon_sq(1:16,1:16,:));
RMSE =  get_RMSE(abs(spectra),abs(mrecon_sq));
disp(RMSE);
%% Write truth file. Original data

    % dlmwrite('ws_raw_sq.txt', ws_raw_sq, 'delimiter','\t','newline','pc'); % to obtain txt file for the data
%     dlmwrite('ws_raw_sq_32_32.txt', ws_raw_sq, 'delimiter','\t','newline','pc');
[filename, pathname] = uigetfile('C:\Users\reddy\Dropbox\Research\Current projects\UCLA_EPSI\CSI_Code_review_final\CSI_Code_review_final\MRSI_CS_UCLA_SG_RR\MRSI_Recon_channelwise\without density comp\*.txt', 'Pick the corresponding txt file for the brain');
fileaddress  = fullfile(pathname,filename);
fidraw=fopen(fileaddress);
str_data = textscan(fidraw,'%s');%,'delimiter','\n');
str_data2 = str_data{1,1}; % Str_data2 has original data
           
     fileID=fopen('saved_32_32.txt','r'); % saved.txt has the header in fo required for jmrui format
     Intro = textscan(fileID,'%s',20,'Delimiter','\n');
     Intro2 = Intro{1,1};
     fclose(fileID);
      
     for i=1:20  % to copy first 20 lines i.e. header info into new file=header+original data
         str_data3_new{i}=Intro2{i}; % str_data3_new is a cell array of new file
     end
     
     i=21;
     
     while feof(fidraw)~=0 %&& i~=262144 % to copy content into new file 21st line onwards
         str_data3_new{i}=str_data2{i-20};
         i=i+1;
     end
     
     fileaddress  = fullfile(pathname,'data_32_32_1.txt'); % data_32_32.txt has content in jmrui format
     save_jMRUI_fmts(spectra,str_data3_new,fileaddress);

%% Check voxel matching - Spectrum of interest is in the first 400 points.
figure;
subplot(211);
plot(squeeze(abs(spectra(16,4,1:100))));hold on;
plot(squeeze(abs(mrecon_sq(16,4,1:100))),'r'); 


subplot(212);
plot(squeeze(abs(spectra(1,1,1:100))));hold on;
plot(squeeze(abs(mrecon_sq(1,1,1:100))),'r');
drawnow;


%% Write reconstructed file.
% dlmwrite('mrecon_sq.txt', mrecon_sq, 'delimiter','\t','newline','pc');
dlmwrite('mrecon_sq_32_32_1.txt', mrecon_sq, 'delimiter','\t','newline','pc');

%%
% [filename,pathname]=uiputfile('\*.txt','Save as jmrui file');
% fileaddress=fullfile('mrecon_sq_32_32.txt');
% if(filename ~= 0)
% fileaddress = fullfile(pathname,filename);
% % save_jMRUI_fmts(mrecon_sq,str_data2,fileaddress);
% save_jMRUI_fmts(mrecon_sq,str_data3_new,fileaddress);
% end


%%  Reconstructed data

    [filename_r, pathname] = uigetfile('C:\Users\reddy\Dropbox\Research\Current projects\UCLA_EPSI\CSI_Code_review_final\CSI_Code_review_final\MRSI_CS_UCLA_SG_RR\MRSI_Recon_channelwise\without density comp\*.txt', 'Pick the corresponding txt file for the brain');
    fileaddress_r  = fullfile(pathname,filename_r);
    fidrec=fopen(fileaddress_r);
    str_data_r = textscan(fidrec,'%s');%,'delimiter','\n');
    str_data2_r = str_data_r{1,1};
    
       
     fileID_r=fopen('saved_rec.txt','r');
     Intro_r = textscan(fileID_r,'%s',20,'Delimiter','\n');
     Intro2_r = Intro_r{1,1};
     fclose(fileID_r);
     
     
     for i=1:20
         str_data3_new_r{i}=Intro2_r{i};
     end
     
     i=21;
     
     while feof(fidrec)~=0 %&& i~=262144
         str_data3_new_r{i}=str_data2_r{i-20};
         i=i+1;
     end
     
     fileaddress_rec  = fullfile(pathname,'rec_32_32_1.txt');
     save_jMRUI_fmts(mrecon_sq,str_data3_new_r,fileaddress_rec);