%% File description
% Author: Sneha Potdar
% Date: 7th July 2017
% Modified: Sairam Geethanath
% Modified Date: 26th July 2017
% Latest Modified by: Sneha Potdar 2nd August 2017
% HASTE : Half Fourier Acqusition Single-shot Turbo Spin Echo Imaging

%% Path preferences
addpath(genpath('.'));
cd('C:\Users\arush\Desktop\MIRC_CDAC-T\MATLAB\Sequences');
sname = 'HASTE_MIRC.seq';
dirname = ('C:\Users\arush\Desktop\MIRC_CDAC-T\MATLAB\Seq files');
%% User Inputs
seq=mr.Sequence();              % Create a new sequence object
fov=256e-3; Nx=256; Ny=256;     % Define FOV and resolution
count=0;                        % counter for updatng phase encode lines
Nex_fact = round((5*Ny)/8);            % A little more than half k-space; HASTE acquisition 
TE=100e-3;                      % in s
TR=180e-3;                      % in s
BW = 50e3;                      %Hz
Slicethickness = 5e-3;
%%  PSD developer inputs
TBW = 4;                        %Hz

%% Define system limits - not defined by programmer but by hardware
Gmax =33;                               %mT/m
SRmax = 100;                          %T/m/s
GradRasterTime = 1/(2*BW);%s
ADCDT = 10e-6;            %s
RFDT = 1e-6;                 %s

%% Set system limits as defined above
lims = mr.opts('MaxGrad',Gmax,'GradUnit','mT/m',...
    'MaxSlew',SRmax,'SlewUnit','T/m/s','ADCdeadtime',ADCDT,...
    'RFdeadTime',RFDT);  
%% Excitation
[rf, gz] = mr.makeSincPulse(pi/2,lims,'Duration',3e-3,...
    'SliceThickness',Slicethickness,'apodization',0.5,'timeBwProduct',TBW);
%% Define other gradients and ADC events
deltak=1/fov;
kWidth = Nx*deltak;
readoutTime =GradRasterTime.*Nx;%Nx*dwelltime in seconds
gx = mr.makeTrapezoid('x',lims,'FlatArea',kWidth,'FlatTime',readoutTime);
adc = mr.makeAdc(Nx,lims,'Duration',gx.flatTime,'Delay',gx.riseTime);
                                            
%% prephase and rephase lobes
count=count+1;
gxPre = mr.makeTrapezoid('x',lims,'Area',-gx.area/2,'Duration',readoutTime./2);%Negative Gx pre
gzReph = mr.makeTrapezoid('z',lims,'Area',-gz.area/2,'Duration',3e-3);
gyPre = mr.makeTrapezoid('y',lims,'Area',-(Ny/2-count)*deltak,'Duration',readoutTime./2);

[rf180, gz180] = mr.makeSincPulse(pi,lims,'Duration',3e-3,...
  'SliceThickness',3e-3,'apodization',0.5,'timeBwProduct',4);
 

%% Calculate delay time
delayTE1=TE/2-mr.calcDuration(gzReph)-mr.calcDuration(rf)- mr.calcDuration(rf180)/2;
delayTE2=TE/2-mr.calcDuration(gx)./2-mr.calcDuration(rf180)/2;
delayTE3=TR-TE-mr.calcDuration(gx);

%% Define sequence blocks
%% RF 90 and 180 will execute once as it is a Single Shot FSE

phaseAreas = ((0:Ny-1)-Ny/2)*deltak;
seq.addBlock(rf,gz);
seq.addBlock(mr.makeDelay(delayTE1));

count=1;
for j=1:Nex_fact
seq.addBlock(rf180,gz180);
seq.addBlock(mr.makeDelay(delayTE2));
gyPre_1 = mr.makeTrapezoid('y','Area',-phaseAreas(j),'Duration',2e-3);
seq.addBlock(gxPre,gyPre_1);
seq.addBlock(gx,adc);  % Read one line of k-space
gyPre = mr.makeTrapezoid('y','Area',phaseAreas(j),'Duration',2e-3); %Starts with negative areas
seq.addBlock(gxPre,gyPre);
seq.addBlock(mr.makeDelay(delayTE3));
end
seq.plot();             % Plot sequence waveforms
%seq.plot('TimeRange',[0 TR*10]);
% seq.write('Haste_SP.seq');   % Output sequence for scanner
fname = fullfile(dirname,sname);
seq.write(fname);