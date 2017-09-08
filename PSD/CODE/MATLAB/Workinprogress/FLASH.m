%% FLASH sequence inplementation 
% minimum TE is 10 and Minimum TR is 20
% TR<<T2
% INPUT parameters TR,TE and Alpha

%FLASH implemented here is based on the gradient echo imaging using spoiled
%steady-state imaging

%% Path preferences
% cd('C:\Users\arush\Desktop\MR_INDIA_CODE\pulseq-master_All\matlab');
% addpath(genpath('.'));
cd('C:\Users\arush\Desktop\PSD_CODE\MATLAB');
addpath(genpath('.'));
sname = 'FLASH_MIRC.seq';
dirname = 'C:\Users\arush\Desktop\PSD_CODE\MATLAB\Seq files';
%%
seq=mr.Sequence();              % Create a new sequence object
fov=220e-3; Nx=256; Ny=256;     % Define FOV and resolution
%%
lims = mr.opts('MaxGrad',33,'GradUnit','mT/m',...
    'MaxSlew',100,'SlewUnit','T/m/s','ADCdeadtime',10e-6,...
    'RFdeadTime',10e-6,'ADCdeadTime',10e-6); 
preTime=8e-4;
%%
% Create alpha degree RF pulse and gradient
alpha=30*pi/180;
[rf, gz] = mr.makeSincPulse(alpha,'Duration',4e-3,...
    'SliceThickness',5e-3,'apodization',0.5,'timeBwProduct',4);

% Define other gradients and ADC events
deltak=1/fov;
kWidth = Nx*deltak;
%readoutTime =lims.gradRasterTime.*Nx;%Nx*dwelltime in seconds
%gx = mr.makeTrapezoid('x',lims,'FlatArea',kWidth,'FlatTime',readoutTime);
gx = mr.makeTrapezoid('x','FlatArea',Nx*deltak,'FlatTime',1e-3);
adc = mr.makeAdc(Nx,'Duration',gx.flatTime,'Delay',gx.riseTime);
gxPre = mr.makeTrapezoid('x','Area',-gx.area/2,'Duration',2e-3);
gzReph = mr.makeTrapezoid('z','Area',-gz.area/2,'Duration',2e-3);
gzSpoil = mr.makeTrapezoid('z',lims,'Area',gz.area*2,'Duration',3*preTime);
phaseAreas = ((0:Ny-1)-Ny/2)*deltak;

% Calculate timing
TE=20e-3;
TR=40e-3;
delayTE=TE - mr.calcDuration(gxPre) - mr.calcDuration(gz) ...
    - mr.calcDuration(gx)/2;
delayTR=TR - mr.calcDuration(gxPre) - mr.calcDuration(gz) ...
    - mr.calcDuration(gx) - delayTE;

% Loop over phase encodes and define sequence blocks
for i=1:Ny
    seq.addBlock(rf,gz);
    gyPre = mr.makeTrapezoid('y','Area',phaseAreas(i),'Duration',2e-3);
    seq.addBlock(gxPre,gyPre,gzReph);
    seq.addBlock(mr.makeDelay(delayTE));
    seq.addBlock(gx,adc);
    seq.addBlock(mr.makeDelay(delayTE/2));
    seq.addBlock(gzSpoil);
    seq.addBlock(mr.makeDelay(delayTR))
end
seq.plot('TimeRange',[0 TR*1e3]);
% seq.write('flash.seq')       % Write to pulseq file
fname = fullfile(dirname,sname);
seq.write(fname);