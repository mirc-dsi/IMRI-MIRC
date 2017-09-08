% Author: Sneha Potdar
% Date: 15th June 2017
% Sequence: SSFP sequence

%% 
cd('C:\Users\arush\Desktop\PSD_CODE\MATLAB');
addpath(genpath('.'));
sname = 'SE-EPI_MIRC.seq';
dirname = ('C:\Users\arush\Desktop\PSD_CODE\MATLAB\Seq files');
%% System Limits
seq=mr.Sequence();              % Create a new sequence object
fov=220e-3; Nx=64; Ny=64;     % Define FOV and resolution

%% Create 20 degree slice selection pulse and gradient
[rf, gz] = mr.makeSincPulse(50*pi/180,'Duration',4e-3,...
    'SliceThickness',5e-3,'apodization',0.5,'timeBwProduct',4);

[rf1, gz1] = mr.makeSincPulse(-(50*pi/180),'Duration',4e-3,...
    'SliceThickness',5e-3,'apodization',0.5,'timeBwProduct',4);
%% Define other gradients and ADC events
deltak=1/fov;
gx = mr.makeTrapezoid('x','FlatArea',Nx*deltak,'FlatTime',6.4e-3);
adc = mr.makeAdc(Nx,'Duration',gx.flatTime,'Delay',gx.riseTime);
gxPre = mr.makeTrapezoid('x','Area',-gx.area/2,'Duration',2e-3);
gzReph = mr.makeTrapezoid('z','Area',-gz.area/2,'Duration',2e-3);
phaseAreas = ((0:Ny-1)-Ny/2)*deltak;

%% Calculate timing
TE=20e-3;
TR=30e-3;
% delayTR = (TR-mr.calcDuration(gxPre/2))-(TE-gx.flatTime/2);
 delayTE=TE - mr.calcDuration(gxPre) - mr.calcDuration(gz)/2 ...
     - mr.calcDuration(gx)/2;
delayTR=TR - mr.calcDuration(gxPre) - mr.calcDuration(gz) ...
    - mr.calcDuration(gx) - delayTE;

%% Loop over phase encodes and define sequence blocks
for i=1:Ny
    seq.addBlock(rf,gz);
    gyPre = mr.makeTrapezoid('y','Area',phaseAreas(i),'Duration',2e-3);
    seq.addBlock(gyPre,gzReph,gx);
    seq.addBlock(gxPre);
          
    seq.addBlock(rf1,gz1);
    seq.addBlock(gzReph,gx,adc);
    seq.addBlock(gxPre);
    seq.addBlock(mr.makeDelay(delayTR))
end

%%
% seq.write('ssfp.seq')       % Write to pulseq file
%seq.plot('TimeRange',[0 TR]);
seq.plot();
fname = fullfile(dirname,sname);
seq.write(fname);