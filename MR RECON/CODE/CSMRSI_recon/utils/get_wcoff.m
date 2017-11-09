function [W,B]=get_wcoff(y,B)
level =4;
wname='db4';
sp = squeeze(y(:,1,:));
samp = wavedec2((real(sp)),level,wname);

W1 = zeros(size(y,2),length(samp));
W2 = W1;

for k=1:size(y,2)
spectra = squeeze(y(:,k,:));
[W1(k,:),~] = wavedec2((real(spectra)),level,wname);
[W2(k,:),B] = wavedec2((imag(spectra)),level,wname);
end

W = W1+1i*W2;
