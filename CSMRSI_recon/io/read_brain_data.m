%function[time_dom_signal,freq_dom_signal,str_data2] = read_brain_data(D)

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

%D=ss;
D = [16 16 201];
%dbstop if error
[filename, pathname] = uigetfile('\*.txt', 'Pick the corresponding txt file for the brain');
% [filename, pathname] = uigetfile('C:\Users\sgeeth\Documents\Data\CS_CSI\Brain_Choi\Hdata1\*.txt', 'Pick the corresponding txt file for the brain');
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
        ind(h)=g+1;
        waitbar(g/length(str_data2),h3);
    end
end

close(h3);

time_dom_signal = zeros(D);
freq_dom_signal = zeros(D);
num_data = zeros(D(3),4);
s=1;

for k=D(1):-1:1
    Fdisp =[];
    for j = 1:D(2)
        d=1;
          for h =ind(s):(ind(s)+D(3)-1)
             num_data(d,:) = str2num(str_data2{h});
             d = d+1;
          end
        freq_dom_signal(k,j,:) = num_data(:,3) +1i*num_data(:,4);
        time_dom_signal(k,j,:) = num_data(:,1) +1i*num_data(:,2);
        
        s =s+1;
        %% Display
%         F_norm =squeeze(freq_dom_signal(k,j,:));
%         F_norm = F_norm./(5e5);
%         F = ((D(1)-k+1))+real(F_norm);
%         Fdisp = cat(1,Fdisp,F);
%         plot(Fdisp);hold on;drawnow;
%         axis([0 16385 0 17]);
%         plot(real(squeeze(freq_dom_signal(k,j,:)))); hold on;
        
    end
end


% freq_dom_signal = freq_dom_signal/max(abs(freq_dom_signal(:)));
