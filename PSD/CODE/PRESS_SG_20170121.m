%% Spin Echo with kspace traversal from top to bottom
% Author - Sairam Geethanath
% Date - 21/01/2017

%% Definitions
TR =800e-3;
TE = 200e-3;
% Define FOV and resolution
fov = 256e-3;

% delays from the Pulseq document
tau1 = 19000e-6;
tau2 = 46000e-6;
tau3 = 44800e-6;

% Number of points in readout and dwell time
Nx = 256;
dwell_time = 25e-9;

seq=mr.Sequence();              % Create a new sequence object
%%  Slice selection on three axes

% Create 90 degree slice selection pulse and gradient
[rf_90, gz_90] = mr.makeSincPulse(90*pi/180,'Duration',4e-3,...
    'SliceThickness',5e-3,'apodization',0.5,'timeBwProduct',4);
gzReph = mr.makeTrapezoid('z','Area',-gz_90.area/2,'Duration',2e-3);


%  Create 180 degree slice selection pulse and gradient
[rf_180_gy, gy_180] = mr.makeSincPulse(180*pi/180,'Duration',4e-3,...
    'SliceThickness',5e-3,'apodization',0.5,'timeBwProduct',4, 'grad_dir', 'y');


%  Create 180 degree slice selection pulse and gradient
[rf_180_gx, gx_180] = mr.makeSincPulse(180*pi/180,'Duration',4e-3,...
    'SliceThickness',5e-3,'apodization',0.5,'timeBwProduct',4, 'grad_dir', 'x');

%%  Define other gradients and ADC events
adc = mr.makeAdc(Nx,'Dwell',dwell_time,'Delay',0, 'freqOffset', 0, 'phaseOffset',0);
delay_tau1 = tau1;
delay_tau2 = tau2;
delay_tau3 = tau3;

%% Built the PRESS sequence

    seq.addBlock(rf_90,gz_90); %B1
    seq.addBlock(gzReph);%B2
    seq.addBlock(mr.makeDelay(delay_tau1));%B3
    
    seq.addBlock(rf_180_gy, gy_180); %B4
    seq.addBlock(mr.makeDelay(delay_tau2));%B5

    seq.addBlock(rf_180_gx, gx_180); %B6
    seq.addBlock(mr.makeDelay(delay_tau3));%B7
    
     seq.addBlock(adc);%B8
    
 %%
      
fig=seq.plot('TimeRange',[0 800e-3],'timeDisp','ms');
seq.write('PRESS.seq')       % Write to pulseq file