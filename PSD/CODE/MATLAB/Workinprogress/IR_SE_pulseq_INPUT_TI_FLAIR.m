%% Path preferences
% cd('C:\Users\arush\Desktop\MR_INDIA_CODE\pulseq-master_All\matlab');
% addpath(genpath('.'));
cd('C:\Users\arush\Desktop\PSD_CODE\MATLAB');
addpath(genpath('.'));
sname = 'IR_SE_FLAIR_MIRC.seq';
dirname = ('C:\Users\arush\Desktop\PSD_CODE\MATLAB\Seq files');
%% Inputs for the code and initialization of the variables
seq=mr.Sequence();              % Create a new sequence object
fov=32e-3; Nx=16; Ny=16;  % Define FOV and resolution
count=0;                  % initialization of the count
TE=20e-3;                 % input value of TE
TR=4000e-3;                 % input value of TR
TI=2700e-3;                  % input value of TI
j=Ny;
%%

 for i=1:Ny
     % Set system limits
lims = mr.opts('MaxGrad',33,'GradUnit','mT/m',...
    'MaxSlew',100,'SlewUnit','T/m/s','ADCdeadtime',10e-6,...
    'RFdeadTime',10e-6,'ADCdeadTime',10e-6);  


%% excitation
% Create 90 degree slice selection pulse and gradient
[rf, gz] = mr.makeSincPulse(pi/2,lims,'Duration',3e-3,...
    'SliceThickness',3e-3,'apodization',0.5,'timeBwProduct',4);


%% 
% Define other gradients and ADC events
deltak=1/fov;
kWidth = Nx*deltak;
readoutTime = 25.6e-4;%Nx*dwelltime in seconds
gx = mr.makeTrapezoid('x',lims,'FlatArea',kWidth,'FlatTime',readoutTime);
adc = mr.makeAdc(Nx,lims,'Duration',gx.flatTime,'Delay',gx.riseTime);

                                              
%% prephase and rephase lobes
count=count+1;
gxPre = mr.makeTrapezoid('x',lims,'Area',gx.area/2,'Duration',readoutTime./2);
gzReph = mr.makeTrapezoid('z',lims,'Area',-gz.area/2,'Duration',1e-3);
gyPre = mr.makeTrapezoid('y',lims,'Area',-(Ny/2-count)*deltak,'Duration',readoutTime./2);


%%
% Refocusing pulse with spoiling gradients
[rf180, gz180] = mr.makeSincPulse(pi,lims,'Duration',3e-3,...
  'SliceThickness',3e-3,'apodization',0.5,'timeBwProduct',1);%sinc pulse


%% calculation of Delay
delayTE1=TE/2-1e-3-6e-3;
delayTE2=TE/2-(readoutTime./2);
delayTE3=TR-TE-(readoutTime);
gxPrelast = mr.makeTrapezoid('x',lims,'Area',-gx.area/2,'Duration',readoutTime./2);
gyPrelast = mr.makeTrapezoid('y',lims,'Area',-(Ny/2-count)*deltak,'Duration',readoutTime./2);
%%
% Define sequence blocks
seq.addBlock(rf180);
seq.addBlock(mr.makeDelay(TI));
seq.addBlock(rf,gz);
seq.addBlock(gxPre,gyPre,gzReph);
seq.addBlock(mr.makeDelay(delayTE1));
seq.addBlock(rf180,gz180);
seq.addBlock(mr.makeDelay(delayTE2));
seq.addBlock(gx,adc);           
seq.addBlock(gxPrelast,gyPrelast);              
seq.addBlock(mr.makeDelay(delayTE3));
seq.plot('TimeRange', [0 TR]*1e3);
%seq.plot('TimeRange',[0 (TR+TI)*1e3]);
% FOV_x=Nx;
% FOV_y=Ny;
% del_x=1e-3;
% del_y=1e-3;


% %% generating values
% Kmax_x=1/(2*del_x);
% del_kx=(2*Kmax_x)/Nx;
% Kmax_y=1/(2*del_y);
% del_ky=(2*Kmax_y)/Ny;
% 
% 
% %% dividing the space equally
% KX=linspace(-Kmax_x,Kmax_x,Nx);
% KY=linspace(-Kmax_y,Kmax_y,Ny);
% 
% 
% %% Display of k-space Trajectory 
% figure(200);
% plot(KX,KY,'w','LineStyle',':');hold on;
% plot(KX(1,:),KY(1,j),'*');hold on;
% j=j-1;
end
% seq.write('IR_FLAIR.seq');   % Output sequence for scanner
seq.plot('TimeRange',[0 TR*1e3]);
fname = fullfile(dirname,sname);
seq.write(fname);