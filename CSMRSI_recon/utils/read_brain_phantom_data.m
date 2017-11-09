function[time_dom_signal,freq_dom_signal,str_data2] = read_brain_phantom_data
%----------------------------------------------------------
%Open and read the file - Use cells as much as poss
%Remove hard coding of this and its mother file asap!
%----------------------------------------------------------
% [filename, pathname] = uigetfile('c:\phd\UTSW\Kspace\FaMeMRI\DATA\Clinical\Brain\*.dcm', 'Pick a DCM file for the brain');
% fileaddress  = fullfile(pathname,filename);
% I = dicomread(fileaddress);
% figure;imagesc(I);colormap(gray);

[filename, pathname] = uigetfile('C:\Users\reddy\Dropbox\Research\UCLA_EPSI\CSI_Code_review_final\CSI_Code_review_final\*.txt', 'Pick the corresponding txt file for the brain');
fileaddress  = fullfile(pathname,filename);
fid=fopen(fileaddress);
h3 = waitbar(0,'Please wait...');
str_data = textscan(fid,'%s','delimiter','\n');
str_data2 = str_data{1,1};
%str_data3 = zeros(length(str_data2),25);
h=0;
for(g=1:length(str_data2))
    tempo = str_data2{g}';
    k=findstr(tempo','out');
    if(k>0)
        h = h +1;
        ind(h)=g;
        waitbar(g/length(str_data2),h3);
    end
end

%----------------------------------------------------------
%Lose precision and read faster in str2num.
%----------------------------------------------------------

num_data = zeros(4,1024);
time_data = zeros(256,1024);g=0;freq_data = zeros(256,1024);

for mat = 1:length(ind)-1
          s=ind(mat)+1;t=(ind(mat+1)-1);
          for h =s:t
             num_data(:,h-s+1) = str2num(str_data2{h})';
          end
         time_data(mat,:) = num_data(1,:) + 1j*num_data(2,:);
         freq_data(mat,:) = num_data(3,:) + 1j*num_data(4,:);
             
end
close(h3);

time_dom_signal = reshape(time_data,16,16,1024);
freq_dom_signal = reshape(freq_data,16,16,1024);

test_data_time = squeeze(fftshift(fft(time_dom_signal(4,4,:))));
test_data_freq = squeeze(freq_dom_signal(4,4,:));
figure;
subplot(211);plot(abs(test_data_time));xlabel('Time dom FTed');
subplot(212);plot(abs(test_data_freq));xlabel('Freq domain');

