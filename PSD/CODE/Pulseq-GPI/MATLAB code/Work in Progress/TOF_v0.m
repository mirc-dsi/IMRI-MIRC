%% Pulse sequence for TOF angiography using pulseq.
% PSD : haackey et al. pg No.719
% Date: 09:01:2016
%% Path 
cd('C:\Users\arush\Desktop\PSD_CODE\MATLAB');
addpath(genpath('.'));
sname = 'TOF_MIRC.seq';
dirname = ('C:\Users\arush\Desktop\PSD_CODE\MATLAB\Seq files');
%% System parameters  
system = mr.opts('MaxGrad',30,'GradUnit','mT/m','MaxSlew',170,'SlewUnit','T/m/s');
seq=mr.Sequence(system);        % Create a new sequence object

% Define sequence parameters      
FOV=200e-3;                     % FOV (in mm)
Nx=128; Ny=128;                 % Resolution (Nrpts)
sliceThickness=5e-3;            % 5mm
RF_sat=3e-3;                    % 90deg RF pulse duration
FA1=pi/2;                       % FA 90deg excitation pulse
Tsat=5e-3;                      % Time b/w 2 RF pulses (in ms)
RF_exc=3e-3;                    % Subsequent exc RF pulse duration
FA2=pi/6;                       % FA 30deg
dwell_time=1e-5;                % Dwell time in us
TR=20e-3;                          %ms
%TE

% Slice selective RF pulse (alpha 1 and 2)
[rf1, gz1] = mr.makeSincPulse(FA1,system,'Duration',RF_sat,'SliceThickness',sliceThickness,'apodization',0.5,'timeBwProduct',4);        
[rf2, gz2] = mr.makeSincPulse(FA2,system,'Duration',RF_exc,'SliceThickness',sliceThickness,'apodization',0.5,'timeBwProduct',4);        

% Define gradients
gzDeph = mr.makeTrapezoid('z',system,'Area',-gz2.area/2,'Duration',RF_exc/2);
gzReph = mr.makeTrapezoid('z',system,'Area',gz2.area/2,'Duration',RF_exc/2);

deltak=1/FOV;
kWidth=deltak*Nx;
readoutTime=Nx.*dwell_time;
gx = mr.makeTrapezoid('x',system,'FlatArea',kWidth,'FlatTime',readoutTime);
adc = mr.makeAdc(Nx,'Duration',gx.flatTime,'Delay',gx.riseTime);
gxDeph=mr.makeTrapezoid('x',system,'Area',gx.area/2,'Duration',readoutTime/2);
gxReph=mr.makeTrapezoid('x',system,'Area',-gx.area/2,'Duration',readoutTime/2);

gy_area = deltak.*((0:Ny-1)-Ny/2);
gz_area = deltak.*((0:Ny-1)-Ny/2);

delay1=Tsat-(RF_sat/2)-(RF_exc/2);
delay2=TR-(2*mr.calcDuration(gx))-mr.calcDuration(gz2)-delay1-RF_sat/2;
delay_RF = mr.makeDelay(delay1);
delay_TR = mr.makeDelay(delay2);
% Define Sequence
for i=1:Ny
    seq.addBlock(rf1,gz1);
    seq.addBlock(delay_RF);
    seq.addBlock(rf2,gz2);
    seq.addBlock(gzDeph,gxDeph);
    seq.addBlock(gzReph);
    gz=mr.makeTrapezoid('z',system,'Area',gz_area(i),'Duration',readoutTime/2);
    gy=mr.makeTrapezoid('y',system,'Area',gy_area(i),'Duration',readoutTime/2);
    seq.addBlock(gxReph,gy,gz);
    seq.addBlock(gx,adc);
    seq.addBlock(delay_TR);
     

end
% seq.write('TOF.seq');
% %seq.plot('timeRange',[0 TR]);
% seq.plot();
%  
% seq.write('TOF.seq');
seq.plot('timeRange',[0 TR]);
fname = fullfile(dirname,sname);
seq.write(fname);