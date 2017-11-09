function[time_dom_signal,freq_dom_signal,str_data2] = read_brain_data_mod(D)

%% Trajectory that is read into jMRUI
% ----------->Nth
%
%
%
% ----------->2nd
% ----------->1st

%----------------------------------------------------------
%Open and read the file - Use cells as much as poss
%----------------------------------------------------------


dbstop if error
[filename, pathname] = uigetfile('.\*.txt', 'Pick the corresponding txt file for the brain');
fileaddress  = fullfile(pathname,filename);
fid=fopen(fileaddress);
h3 = waitbar(0,'Please wait...');
str_data = textscan(fid,'%s','delimiter','\n');
str_data2 = str_data{1,1};
%str_data3 = zeros(length(str_data2),25);
h=0;
for g=1:length(str_data2)
    tempo = str_data2{g}';
  
    k=findstr(tempo','out');
    if(k>0)

        h = h +1;
        ind(h)=g;
        waitbar(g/length(str_data2),h3);
    end
end


num_data = zeros(4,D(3));
time_data = zeros(D(1)*D(2),D(3));freq_data = zeros(D(1)*D(2),D(3));

for mat = 1:length(ind)
          s=ind(mat);t=(ind(mat)+D(3));
          for h =(s+1):t
             num_data(:,h-s) = str2num(str_data2{h})';
          end
         time_data(mat,:) = (num_data(1,:) + 1j*num_data(2,:));
         freq_data(mat,:) = (num_data(3,:) + 1j*num_data(4,:));
             
end
close(h3);

time_dom_signal = zeros(D);
freq_dom_signal = zeros(D);
S =[];
for k=1:D(1)
     t = ((k-1)*D(2)+1):k*D(2);
     h=1:D(2);
        time_dom_signal(D(1)-k+1,h,:) = squeeze(time_data(t,:));
        freq_dom_signal(D(1)-k+1,h,:) = squeeze(freq_data(t,:));
        S2 = k.*squeeze(freq_data(t,:));
        S = cat(2,S,S2);
        plot(abs(S));hold on;
        
end


% freq_dom_signal = freq_dom_signal/max(abs(freq_dom_signal(:)));
