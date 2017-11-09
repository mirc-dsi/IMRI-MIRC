function save_pe_masks(mask)



[filename, pathname] = uiputfile('E:\MATLAB_BKPS\Prospective_pulse_CSI\Wrapup_CSMRSI_3_phantom\io\PE_tables\*.txt'); 
fileaddress = fullfile(pathname,filename);
fid = fopen(fileaddress,'wt');

%--------------------------------------------------------------------------
%Print out the phase encode values to the text file as reqd.
%--------------------------------------------------------------------------
h = waitbar(0,'Please wait...');

for n=1:size(mask,1)
    for m=1:size(mask,2)
        fprintf(fid,'%d\t',mask(n,m));
    end
    fprintf(fid,'\n');
    waitbar((n/(size(mask,1)*size(mask,2))),h);
end
close (h);
fclose(fid);



