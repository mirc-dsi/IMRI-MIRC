system = mr.opts('MaxGrad',30,'GradUnit','mT/m', 'MaxSlew',170,'SlewUnit','T/m/s');
seq=mr.Sequence(system);
fov=220e-3;
Nx=64; Ny=64;
sliceThickness=5e-3;
flip1=90*pi/180;
flip2=180*pi/180;

% rf and rf180
[rf, gz] = mr.makeSincPulse(flip1,system,'Duration',4e-3,...
    'SliceThickness',sliceThickness,'apodization',0.5,'timeBwProduct',4);
[rf180, gz180] = mr.makeSincPulse(flip2,system,'Duration',4e-3,...
    'SliceThickness',sliceThickness,'apodization',0.5,'timeBwProduct',4);

% figure
% subplot(2,1,1);
% plot(rf180.t,angle(rf180.signal));
% subplot(2,1,2);
% plot(rf.t,angle(rf.signal))

% gx
deltak=1/fov;
kWidth = Nx*deltak;
readoutTime = 6.4e-3;
s1 = mr.opts('MaxGrad',20,'GradUnit','mT/m', 'MaxSlew',170,'SlewUnit','T/m/s');
s2 = mr.opts('MaxGrad',30,'GradUnit','mT/m', 'MaxSlew',170,'SlewUnit','T/m/s');
gx1 = mr.makeTrapezoid('x',s1,'FlatArea',kWidth,'FlatTime',readoutTime);
gx2 = mr.makeTrapezoid('x',s2,'FlatArea',kWidth,'FlatTime',readoutTime);

% adc
adc = mr.makeAdc(Nx,'Duration',gx2.flatTime,'Delay',gx2.riseTime);

% gyPre (phase readout)
phaseAreas = (Ny-(1:Ny)-Ny/2)*deltak;
s1 = mr.opts('MaxGrad',30,'GradUnit','mT/m', 'MaxSlew',170,'SlewUnit','T/m/s');
gyPre = mr.makeTrapezoid('y',s1,'Area',phaseAreas(1),'Duration',2e-3);

% delays
TE = 100e-3;
TR = 500e-3;
tau = TE/2;
delay1 = tau - mr.calcDuration(rf)/2 - mr.calcDuration(gx1) - mr.calcDuration(rf180)/2;
delay1 = mr.makeDelay(delay1);
delayTE = tau - mr.calcDuration(rf180)/2 - mr.calcDuration(gyPre) - mr.calcDuration(gx2)/2;
delayTE = mr.makeDelay(delayTE);
delayTR = TR - mr.calcDuration(rf)/2 - mr.calcDuration(gx1) - mr.calcDuration(gx2)*5 - mr.calcDuration(gyPre);
delayTR = mr.makeDelay(delayTR);

for i=1:Ny
    seq.addBlock(rf,gz);
    seq.addBlock(gx1);
    seq.addBlock(delay1);
    for j=1:5
        seq.addBlock(rf180,gz180);
        gyPre = mr.makeTrapezoid('y',s1,'Area',phaseAreas(i),'Duration',2e-3);
        seq.addBlock(gyPre);
        seq.addBlock(delayTE);
        seq.addBlock(gx2,adc);
        seq.addBlock(gyPre);
        seq.addBlock(delayTE);
    end
    seq.addBlock(delayTR);
end
seq.plot();