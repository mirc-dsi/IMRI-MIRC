function [X,B]=get_iwcoff(W,B)
wname ='db4';
samp = waverec2((real(W(1,:))),B,wname);

X1 = zeros(size(samp,1),size(W,1),size(samp,2));
X2 = X1;

for k =1:size(W,1)
X1(:,k,:) = waverec2((real(squeeze(W(k,:)))),B,wname);
X2(:,k,:) = waverec2((imag(squeeze(W(k,:)))),B,wname);
end

X = X1+1i*X2;
