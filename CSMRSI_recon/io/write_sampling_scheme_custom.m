function write_sampling_scheme_custom(N)

[filename,pathname]=uiputfile('C:\Users\sgeeth\Documents\Data\CS_CSI\For_paper\Raw_data\*.txt','Save as jmrui file');
fileaddress = fullfile(pathname,filename);
fid = fopen(fileaddress,'wt');

for k=0:N-1
    fprintf(fid,'%d-%d\n',k,k);
end